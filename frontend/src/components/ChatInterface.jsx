import React, { useState, useEffect } from 'react';
import MessageList from './MessageList';
import MessageInput from './MessageInput';
import ModelSelector from './ModelSelector';
import { sendMessageToApi } from '../services/api';
import '../styles/main.css';

function ChatInterface() {
  const [messages, setMessages] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedModel, setSelectedModel] = useState('anthropic.claude-v2');

  const handleSendMessage = async (text) => {
    if (text.trim() === '') return;

    const userMessage = { role: 'user', content: text };
    setMessages(prev => [...prev, userMessage]);
    setLoading(true);

    try {
      const response = await sendMessageToApi(messages, userMessage, selectedModel);
      setMessages(prev => [...prev, { role: 'assistant', content: response.message }]);
    } catch (error) {
      console.error('Error sending message:', error);
      setMessages(prev => [...prev, {
        role: 'assistant',
        content: 'Sorry, there was an error processing your request.'
      }]);
    } finally {
      setLoading(false);
    }
  };

  const handleModelChange = (model) => {
    setSelectedModel(model);
  };

  return (
    <div className="chat-interface">
      <ModelSelector selectedModel={selectedModel} onModelChange={handleModelChange} />
      <MessageList messages={messages} loading={loading} />
      <MessageInput onSendMessage={handleSendMessage} disabled={loading} />
    </div>
  );
}

export default ChatInterface;
