const API_ENDPOINT = process.env.REACT_APP_API_ENDPOINT || 'https://your-api-gateway-url/prod';

export async function sendMessageToApi(previousMessages, newMessage, model) {
  try {
    const response = await fetch(`${API_ENDPOINT}/chat`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        messages: [...previousMessages, newMessage],
        model: model
      }),
    });

    if (!response.ok) {
      throw new Error(`API error: ${response.status}`);
    }

    const data = await response.json();
    return {
      message: data.response,
      model: data.model
    };
  } catch (error) {
    console.error('API request failed:', error);
    throw error;
  }
}
