# 📡 Exemples de Requêtes et Réponses API

## 1. Envoyer une Demande de Connexion

### Request
```http
POST https://yansnetapi.enlighteninnovation.com/api/connections/request
Content-Type: application/json
Authorization: Bearer YOUR_JWT_TOKEN

{
  "fromUserId": 123,
  "toUserId": 456
}
```

### Response Success (200 OK)
```json
{
  "success": true,
  "message": "Connection request sent successfully",
  "data": {
    "connectionId": 789,
    "fromUserId": 123,
    "toUserId": 456,
    "status": "PENDING",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

### Response Error (400 Bad Request)
```json
{
  "success": false,
  "message": "Connection request already exists",
  "error": {
    "code": "DUPLICATE_REQUEST",
    "details": "You have already sent a connection request to this user"
  }
}
```

### Response Error (404 Not Found)
```json
{
  "success": false,
  "message": "User not found",
  "error": {
    "code": "USER_NOT_FOUND",
    "details": "The user with ID 456 does not exist"
  }
}
```

---

## 2. Obtenir les Suggestions de Réseau

### Request
```http
GET https://yansnetapi.enlighteninnovation.com/api/network/suggestions/123
Authorization: Bearer YOUR_JWT_TOKEN
```

### Response Success (200 OK)
```json
[
  {
    "user": {
      "id": 456,
      "name": "John Doe",
      "email": "john@example.com",
      "username": "johndoe",
      "bio": "Software Engineer passionate about Flutter",
      "profilePictureUrl": "https://example.com/avatars/john.jpg",
      "isMentor": true
    },
    "mutualConnectionsCount": 5,
    "reason": "Works at the same company"
  },
  {
    "user": {
      "id": 789,
      "name": "Jane Smith",
      "email": "jane@example.com",
      "username": "janesmith",
      "bio": "UX Designer | Tech Enthusiast",
      "profilePictureUrl": "https://example.com/avatars/jane.jpg",
      "isMentor": false
    },
    "mutualConnectionsCount": 3,
    "reason": "Suggested for you"
  }
]
```

---

## 3. Obtenir les Statistiques du Réseau

### Request
```http
GET https://yansnetapi.enlighteninnovation.com/api/network/stats/123
Authorization: Bearer YOUR_JWT_TOKEN
```

### Response Success (200 OK)
```json
{
  "connectionsCount": 150,
  "contactsCount": 200,
  "channelsCount": 10
}
```

---

## 4. Accepter une Demande de Connexion

### Request
```http
POST https://yansnetapi.enlighteninnovation.com/api/connections/accept/789
Authorization: Bearer YOUR_JWT_TOKEN
```

### Response Success (200 OK)
```json
{
  "success": true,
  "message": "Connection request accepted",
  "data": {
    "connectionId": 789,
    "fromUserId": 456,
    "toUserId": 123,
    "status": "ACCEPTED",
    "acceptedAt": "2024-01-15T11:00:00Z"
  }
}
```

---

## 5. Rejeter une Demande de Connexion

### Request
```http
POST https://yansnetapi.enlighteninnovation.com/api/connections/reject/789
Authorization: Bearer YOUR_JWT_TOKEN
```

### Response Success (200 OK)
```json
{
  "success": true,
  "message": "Connection request rejected",
  "data": {
    "connectionId": 789,
    "status": "REJECTED",
    "rejectedAt": "2024-01-15T11:05:00Z"
  }
}
```

---

## 6. Obtenir les Demandes de Connexion en Attente

### Request
```http
GET https://yansnetapi.enlighteninnovation.com/api/connections/pending/123
Authorization: Bearer YOUR_JWT_TOKEN
```

### Response Success (200 OK)
```json
{
  "received": [
    {
      "connectionId": 790,
      "fromUser": {
        "id": 456,
        "name": "John Doe",
        "username": "johndoe",
        "profilePictureUrl": "https://example.com/avatars/john.jpg"
      },
      "createdAt": "2024-01-15T09:00:00Z"
    }
  ],
  "sent": [
    {
      "connectionId": 791,
      "toUser": {
        "id": 789,
        "name": "Jane Smith",
        "username": "janesmith",
        "profilePictureUrl": "https://example.com/avatars/jane.jpg"
      },
      "createdAt": "2024-01-15T10:30:00Z"
    }
  ]
}
```

---

## 7. Obtenir la Liste des Connexions

### Request
```http
GET https://yansnetapi.enlighteninnovation.com/api/connections/list/123
Authorization: Bearer YOUR_JWT_TOKEN
```

### Response Success (200 OK)
```json
{
  "connections": [
    {
      "connectionId": 789,
      "user": {
        "id": 456,
        "name": "John Doe",
        "username": "johndoe",
        "profilePictureUrl": "https://example.com/avatars/john.jpg",
        "bio": "Software Engineer"
      },
      "connectedAt": "2024-01-10T14:30:00Z"
    },
    {
      "connectionId": 790,
      "user": {
        "id": 789,
        "name": "Jane Smith",
        "username": "janesmith",
        "profilePictureUrl": "https://example.com/avatars/jane.jpg",
        "bio": "UX Designer"
      },
      "connectedAt": "2024-01-12T09:15:00Z"
    }
  ],
  "total": 150,
  "page": 1,
  "pageSize": 20
}
```

---

## Codes d'Erreur Communs

| Code HTTP | Signification | Action |
|-----------|---------------|--------|
| 200 | Success | Opération réussie |
| 201 | Created | Ressource créée avec succès |
| 400 | Bad Request | Vérifier les paramètres de la requête |
| 401 | Unauthorized | Token d'authentification invalide ou expiré |
| 403 | Forbidden | Accès refusé |
| 404 | Not Found | Ressource non trouvée |
| 409 | Conflict | Conflit (ex: demande déjà existante) |
| 500 | Internal Server Error | Erreur serveur |

---

## Headers Requis

Toutes les requêtes doivent inclure :

```http
Content-Type: application/json
Authorization: Bearer YOUR_JWT_TOKEN
```

---

## Gestion des Erreurs dans l'App

```dart
try {
  final success = await provider.connectUser(currentUserId, targetUserId);
  if (success) {
    // Show success message
  }
} catch (e) {
  // Handle different error types
  if (e.toString().contains('401')) {
    // Redirect to login
  } else if (e.toString().contains('404')) {
    // Show "User not found"
  } else {
    // Show generic error
  }
}
```

---

## Test avec cURL

### Envoyer une demande de connexion
```bash
curl -X POST https://yansnetapi.enlighteninnovation.com/api/connections/request \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "fromUserId": 123,
    "toUserId": 456
  }'
```

### Obtenir les suggestions
```bash
curl -X GET https://yansnetapi.enlighteninnovation.com/api/network/suggestions/123 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Obtenir les statistiques
```bash
curl -X GET https://yansnetapi.enlighteninnovation.com/api/network/stats/123 \
  -H "Authorization: Bearer YOUR_TOKEN"
```
