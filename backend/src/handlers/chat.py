import json
import boto3
from ..utils.prompt_formatters import format_prompt_for_model
from ..utils.response_processors import process_model_response

bedrock_runtime = boto3.client('bedrock-runtime')


def lambda_handler(event, context):
    """
    Lambda handler for the chat API endpoint.

    Args:
        event: API Gateway event
        context: Lambda context

    Returns:
        API Gateway response object
    """
    try:
        # Parse request body
        body = json.loads(event.get('body', '{}'))
        messages = body.get('messages', [])
        model_id = body.get('model', 'anthropic.claude-v2')

        # Format prompt based on selected model
        prompt, request_params = format_prompt_for_model(messages, model_id)

        # Invoke Bedrock model
        response = bedrock_runtime.invoke_model(
            modelId=model_id,
            body=json.dumps(request_params)
        )

        # Process the response from the model
        result = process_model_response(response, model_id)

        # Return successful response
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'response': result,
                'model': model_id
            })
        }

    except Exception as e:
        # Log the error and return an error response
        print(f"Error processing request: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'An error occurred processing your request',
                'message': str(e)
            })
        }
