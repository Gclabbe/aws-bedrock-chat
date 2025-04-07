import React from 'react';

function ModelSelector({ selectedModel, onModelChange }) {
  const models = [
    { id: 'anthropic.claude-v2', name: 'Claude V2' },
    { id: 'anthropic.claude-instant-v1', name: 'Claude Instant' },
    { id: 'meta.llama2-13b-chat-v1', name: 'Llama 2 (13B)' },
    { id: 'amazon.titan-text-express-v1', name: 'Amazon Titan' }
  ];

  return (
    <div className="model-selector-container">
      <label htmlFor="model-selector">AI Model:</label>
      <select
        id="model-selector"
        value={selectedModel}
        onChange={(e) => onModelChange(e.target.value)}
        className="model-selector"
      >
        {models.map(model => (
          <option key={model.id} value={model.id}>
            {model.name}
          </option>
        ))}
      </select>
    </div>
  );
}

export default ModelSelector;
