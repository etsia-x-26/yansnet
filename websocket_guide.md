# WebSocket Exploitation Guide

This guide describes how to connect to and use the WebSocket messaging system in the Yansnet backend.

## 1. Connection Configuration

The backend uses **STOMP** over **SockJS** for real-time communication.

*   **Endpoint:** `http://yansnetapi.enlighteninnovation.com/ws` (or your production URL)
*   **Protocols supported:** WebSocket, SockJS fallback.
*   **Heartbeats:** Enabled by default by the broker.

## 2. STOMP Prefixes

*   **Application Destination Prefix (`/app`):** Use this prefix when sending messages to the backend.
*   **Broker Destinations:**
    *   `/topic`: Used for broadcasting messages to multiple subscribers (e.g., public chat, global notifications).
    *   `/queue`: Used for point-to-point messaging.
    *   `/user`: Used for user-specific private messages.

## 3. Communication Patterns

### Public Chat / Broadcast
To participate in the public chat, follow these steps:

1.  **Subscribe** to `/topic/public` to receive updates.
2.  **Add User** (Join event) by sending a message to `/app/chat.addUser`.
3.  **Send Message** by sending a message to `/app/chat.sendMessage`.

### Private Messaging (Standard STOMP)
*   **Subscribe** to `/user/queue/messages` to receive private messages.
*   The backend can use `SimpMessagingTemplate` to send messages to `/user/{username}/queue/messages`.

## 4. Message Payload (`ChatMessage`)

All messages sent and received via the `/chat.*` routes use the following JSON structure:

```json
{
  "content": "Hello World!",
  "sender": "john_doe",
  "type": "CHAT",       // Enum: CHAT, JOIN, LEAVE, TYPING
  "timestamp": "2026-01-11T12:00:00Z"
}
```

## 5. Frontend Implementation Example (StompJS)

```javascript
import { Client } from '@stomp/stompjs';
import SockJS from 'sockjs-client';

const socket = new SockJS('http://yansnetapi.enlighteninnovation.com/ws');
const client = new Client({
  webSocketFactory: () => socket,
  debug: (str) => console.log(str),
  onConnect: (frame) => {
    console.log('Connected: ' + frame);

    // 1. Subscribe to public channel
    client.subscribe('/topic/public', (message) => {
      const payload = JSON.parse(message.body);
      console.log('Received:', payload);
    });

    // 2. Announce presence (Join)
    client.publish({
      destination: '/app/chat.addUser',
      body: JSON.stringify({ sender: 'wilfried', type: 'JOIN' })
    });
  },
  onStompError: (frame) => {
    console.error('Broker reported error: ' + frame.headers['message']);
  }
});

client.activate();

// 3. To send a message later:
const sendMessage = (text) => {
  client.publish({
    destination: '/app/chat.sendMessage',
    body: JSON.stringify({
      content: text,
      sender: 'wilfried',
      type: 'CHAT'
    })
  });
};
```

## 6. Security Note

*   Development: Origins are set to `*`.
*   Production: Ensure `setAllowedOrigins` or `setAllowedOriginPatterns` is properly configured in `WebSocketConfig.java` to prevent unauthorized cross-origin connections.
