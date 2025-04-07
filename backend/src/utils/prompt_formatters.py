def format_prompt_for_model(messages, model_id):
    """
    Format messages based on the selected model's requirements.

    Args:
        messages: List of message objects
        model_id: ID of the model to use

    Returns:
        tuple: (formatted_prompt, request_parameters)
    """
    if 'anthropic.claude' in model_id:
        return format_anthropic_prompt(messages)
    elif 'meta.llama' in model_id:
        return format_llama_prompt(messages)
    elif 'amazon.titan' in model_id:
        return format_titan_prompt(messages)
    else:
        raise ValueError(f"Unsupported model: {model_id}")


def format_anthropic_prompt(messages):
    """
    Format prompt for Anthropic Claude models.

    Args:
        messages: List of message objects

    Returns:
        tuple: (formatted_prompt, request_parameters)
    """
    prompt = "\n\nHuman: "
    for message in messages:
        role = message.get('role', '').lower()
        content = message.get('content', '')

        if role == 'user':
            prompt += f"{content}\n\nAssistant: "
        elif role == 'assistant':
            prompt += f"{content}\n\nHuman: "

    # Remove trailing "Human: " if needed
    if prompt.endswith("\n\nHuman: "):
        prompt = prompt[:-9]

    request_params = {
        "prompt": prompt,
        "max_tokens_to_sample": 1000,
        "temperature": 0.7,
        "top_p": 0.9,
    }

    return prompt, request_params


def format_llama_prompt(messages):
    """
    Format prompt for Meta Llama models.

    Args:
        messages: List of message objects

    Returns:
        tuple: (formatted_prompt, request_parameters)
    """
    prompt = ""
    for message in messages:
        role = message.get('role', '').lower()
        content = message.get('content', '')

        if role == 'user':
            prompt += f"[INST] {content} [/INST]"
        elif role == 'assistant':
            prompt += f" {content} "

    request_params = {
        "prompt": prompt,
        "max_gen_len": 512,
        "temperature": 0.7,
        "top_p": 0.9,
    }

    return prompt, request_params


def format_titan_prompt(messages):
    """
    Format prompt for Amazon Titan models.

    Args:
        messages: List of message objects

    Returns:
        tuple: (formatted_prompt, request_parameters)
    """
    prompt = ""
    for idx, message in enumerate(messages):
        role = message.get('role', '').lower()
        content = message.get('content', '')

        if role == 'user':
            prompt += f"User: {content}\n"
        elif role == 'assistant':
            prompt += f"Assistant: {content}\n"

    # Add final assistant prompt
    prompt += "Assistant: "

    request_params = {
        "inputText": prompt,
        "textGenerationConfig": {
            "maxTokenCount": 1000,
            "temperature": 0.7,
            "topP": 0.9,
        }
    }

    return prompt, request_params
