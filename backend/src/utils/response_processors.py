import json


def process_model_response(response, model_id):
    """
    Process response from Bedrock model based on model type.

    Args:
        response: Raw response from Bedrock invoke_model
        model_id: ID of the model used

    Returns:
        str: Processed response text
    """
    # Get the response body as string and parse it
    response_body = json.loads(response['body'].read())

    # Extract the response text based on model type
    if 'anthropic.claude' in model_id:
        return response_body.get('completion', '')

    elif 'meta.llama' in model_id:
        return response_body.get('generation', '')

    elif 'amazon.titan' in model_id:
        return response_body.get('results', [{}])[0].get('outputText', '')

    else:
        # Default fallback
        return str(response_body)
