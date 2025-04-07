# AWS Bedrock Models

This document provides information about the different AWS Bedrock models supported by this application.

## Available Models

### Anthropic Claude Models

#### Claude V2
- **Model ID**: `anthropic.claude-v2`
- **Strengths**: Strong reasoning, instruction following, and creative content generation
- **Use Cases**: Complex conversations, content creation, reasoning tasks
- **Max Tokens**: 100,000

#### Claude Instant
- **Model ID**: `anthropic.claude-instant-v1`
- **Strengths**: Faster responses, lower cost
- **Use Cases**: Quick responses, simpler tasks, prototyping
- **Max Tokens**: 100,000

### Meta Models

#### Llama 2 (13B)
- **Model ID**: `meta.llama2-13b-chat-v1`
- **Strengths**: Open source, good performance for size
- **Use Cases**: General chat, instruction following
- **Max Tokens**: 4,096

### Amazon Models

#### Titan Text
- **Model ID**: `amazon.titan-text-express-v1`
- **Strengths**: Amazon's own foundation model
- **Use Cases**: Text generation, summarization
- **Max Tokens**: 4,096

## Prompt Formatting

Each model requires specific prompt formatting to work effectively:

### Claude Format
### Llama 2 Format
[INST] [user message] [/INST] [assistant response]


Copy

### Titan Format
User: [user message]
Assistant: [assistant response]

markdown

Copy

## Best Practices

1. **Model Selection**: Choose the appropriate model for your use case
   - For complex reasoning: Claude V2
   - For quick responses: Claude Instant
   - For cost-effectiveness: Llama 2 or Titan

2. **Prompt Engineering**:
   - Be specific with instructions
   - Provide examples when needed
   - Use clear and concise language

3. **Temperature Settings**:
   - Lower (0.1-0.3): More deterministic, factual responses
   - Medium (0.4-0.7): Balance of creativity and focus
   - Higher (0.8-1.0): More creative, varied responses
