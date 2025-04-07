from dataclasses import dataclass
from typing import List, Optional


@dataclass
class Message:
    """Representation of a chat message."""

    role: str  # 'user' or 'assistant'
    content: str  # Message content

    @classmethod
    def from_dict(cls, data):
        """Create a Message from a dictionary."""
        return cls(
            role=data.get('role', ''),
            content=data.get('content', '')
        )


@dataclass
class Conversation:
    """Representation of a conversation."""

    messages: List[Message]
    model_id: Optional[str] = None

    @classmethod
    def from_request(cls, request_body):
        """Create a Conversation from an API request body."""
        messages = [Message.from_dict(msg) for msg in request_body.get('messages', [])]
        model_id = request_body.get('model')

        return cls(messages=messages, model_id=model_id)
