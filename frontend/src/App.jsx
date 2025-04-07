import React from 'react';
import ChatInterface from './components/ChatInterface';
import './styles/main.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>AWS Bedrock Chat</h1>
      </header>
      <ChatInterface />
    </div>
  );
}

export default App;
