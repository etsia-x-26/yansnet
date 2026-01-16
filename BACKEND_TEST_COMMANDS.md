# 🧪 Commandes de Test Backend

## Pour le Backend Team

Voici les commandes curl pour reproduire les erreurs 500.

---

## 1. Test Channels (Erreur 500)

### Créer une chaîne
```bash
curl -X POST https://yansnetapi.enlighteninnovation.com/api/channel \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "title": "Test Channel",
    "description": "Test description"
  }'
```

**Résultat actuel**:
```json
{
  "message": "An unexpected error occurred. Please try again later.",
  "errorCode": "INTERNAL_ERROR",
  "status": 500,
  "timestamp": "2026-01-15T23:03:43",
  "path": "/api/channel"
}
```

**Résultat attendu**:
```json
{
  "id": 1,
  "title": "Test Channel",
  "description": "Test description",
  "followersCount": 0,
  "createdAt": "2026-01-15T23:03:43"
}
```

---

### Lister les chaînes
```bash
curl -X GET https://yansnetapi.enlighteninnovation.com/api/channel \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**À tester après correction du POST**

---

## 2. Test Messaging (Erreur 500)

### Créer une conversation
```bash
curl -X POST https://yansnetapi.enlighteninnovation.com/api/messages/conversations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "participantIds": [1],
    "type": "DIRECT"
  }'
```

**Résultat actuel**:
```json
{
  "message": "An unexpected error occurred. Please try again later.",
  "errorCode": "INTERNAL_ERROR",
  "status": 500,
  "timestamp": "2026-01-15T22:39:20",
  "path": "/api/messages/conversations"
}
```

**Résultat attendu**:
```json
{
  "id": 1,
  "type": "DIRECT",
  "participants": [
    {
      "id": 1,
      "name": "John Doe",
      "username": "johndoe"
    }
  ],
  "createdAt": "2026-01-15T22:39:20"
}
```

---

### Lister les conversations
```bash
curl -X GET https://yansnetapi.enlighteninnovation.com/api/messages/conversations \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Résultat actuel**: `[]` (liste vide)

**Résultat attendu**: Liste des conversations de l'utilisateur

---

## 3. Obtenir un Token de Test

Si vous n'avez pas de token:

```bash
curl -X POST https://yansnetapi.enlighteninnovation.com/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

Utilisez le `accessToken` retourné dans les autres commandes.

---

## 4. Vérifier les Logs Serveur

### Pour Channels
```
Timestamp: 2026-01-15T23:03:43
Path: /api/channel
Method: POST
Payload: {"title": "YOUSS", "description": "OKK"}
```

### Pour Messaging
```
Timestamp: 2026-01-15T22:39:20
Path: /api/messages/conversations
Method: POST
Payload: {"participantIds": [1], "type": "DIRECT"}
```

**Chercher**:
- Stack trace
- Exception message
- SQL errors
- Validation errors

---

## 5. Tests Postman

Si vous préférez Postman:

### Collection Postman
```json
{
  "info": {
    "name": "YansNet API Tests",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Create Channel",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          },
          {
            "key": "Authorization",
            "value": "Bearer {{token}}"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"title\": \"Test Channel\",\n  \"description\": \"Test description\"\n}"
        },
        "url": {
          "raw": "https://yansnetapi.enlighteninnovation.com/api/channel",
          "protocol": "https",
          "host": ["yansnetapi", "enlighteninnovation", "com"],
          "path": ["api", "channel"]
        }
      }
    },
    {
      "name": "Create Conversation",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          },
          {
            "key": "Authorization",
            "value": "Bearer {{token}}"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"participantIds\": [1],\n  \"type\": \"DIRECT\"\n}"
        },
        "url": {
          "raw": "https://yansnetapi.enlighteninnovation.com/api/messages/conversations",
          "protocol": "https",
          "host": ["yansnetapi", "enlighteninnovation", "com"],
          "path": ["api", "messages", "conversations"]
        }
      }
    }
  ]
}
```

---

## 6. Checklist de Debug

### Pour chaque erreur 500:

- [ ] Vérifier les logs serveur
- [ ] Identifier la stack trace
- [ ] Vérifier la base de données
- [ ] Vérifier les contraintes
- [ ] Vérifier les validations
- [ ] Tester avec curl
- [ ] Tester avec Postman
- [ ] Corriger le bug
- [ ] Re-tester
- [ ] Déployer

---

## 7. Informations Utiles

### Base URL
```
https://yansnetapi.enlighteninnovation.com
```

### User ID de Test
```
User ID: 3 (utilisateur connecté dans les logs)
User ID: 1 (utilisateur cible pour les conversations)
```

### Timestamps des Erreurs
```
Channels: 2026-01-15T23:03:43
Messaging: 2026-01-15T22:39:20
```

---

## 8. Après Correction

### Tests à Refaire
1. ✅ Créer une chaîne
2. ✅ Lister les chaînes
3. ✅ Créer une conversation
4. ✅ Lister les conversations
5. ✅ Envoyer un message
6. ✅ Tester depuis l'app frontend

---

**Date**: 15 Janvier 2026  
**Priorité**: URGENT  
**Impact**: Bloque 2 fonctionnalités majeures
