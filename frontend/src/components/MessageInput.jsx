import React, { useState } from 'react';

function MessageInput({ onSendMessage, disabled }) {
  const [input, setInput] = useState('');

  const handleSend = () => {
    if (input.trim() !== '') {
      onSendMessage(input);
      setInput('');
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <div className="input-area">
      <input
        type="text"
        value={input}
        onChange={(e) => setInput(e.target.value)}
        onKeyPress={handleKeyPress}
        placeholder="Type your message..."
        disabled={disabled}
      />
      <button
        onClick={handleSend}
        disabled={disabled || input.trim() === ''}
      >
        Send
      </button>
    </div>
  );
}

export default MessageInput;
