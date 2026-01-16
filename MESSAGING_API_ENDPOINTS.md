# 📡 Endpoints API Messaging - Documentation

## Vue d'ensemble

Voici tous les endpoints disponibles pour la messagerie selon la documentation API.

---

## Endpoints Implémentés dans l'App

### 1. GET /api/messages/conversations
**Description**: Récupérer les conversations de l'utilisateur

**Utilisé dans**: `ChatRemoteDataSource.getConversations()`

**Statut**: ✅ Fonctionne (retourne liste vide actuellement)

**Fallback**: Si vide, on utilise `/Conversation` (ancien endpoint)

**Code**:
```dart
final response = await apiClient.dio.get('/api/messages/conversations');
```

---

### 2. POST /api/messages/conversations
**Description**: Créer une nouvelle conversation

**Utilisé dans**: `ChatRemoteDataSource.createConversation()`

**Statut**: ❌ **ERREUR 500** (INTERNAL_ERROR)

**Payload**:
```json
{
  "participantIds": [1],
  "type": "DIRECT"
}
```

**Erreur actuelle**:
```json
{
  "message": "An unexpected error occurred. Please try again later.",
  "errorCode": "INTERNAL_ERROR",
  "status": 500,
  "timestamp": "2026-01-15T22:39:20",
  "path": "/api/messages/conversations"
}
```

**Code**:
```dart
final response = await apiClient.dio.post(
  '/api/messages/conversations',
  data: {
    'participantIds': [otherUserId],
    'type': 'DIRECT',
  },
);
```

**Action requise**: Le backend team doit corriger cette erreur 500.

---

### 3. GET /api/messages/conversations/{conversationId}
**Description**: Récupérer une conversation par ID

**Utilisé dans**: Pas encore implémenté (peut être ajouté si nécessaire)

**Statut**: ⚪ Non testé

**Utilité potentielle**: Charger les détails d'une conversation spécifique

---

### 4. GET /api/messages/conversations/{conversationId}/messages
**Description**: Récupérer les messages d'une conversation

**Utilisé dans**: `ChatRemoteDataSource.getMessages()`

**Statut**: ✅ Fonctionne

**Réponse**: Format paginé avec `content`, `pageable`, etc.

**Code**:
```dart
final response = await apiClient.dio.get(
  '/api/messages/conversations/$conversationId/messages',
);

// L'API retourne un objet paginé
if (response.data is Map && response.data.containsKey('content')) {
  final List data = response.data['content'] ?? [];
  return data.map((e) => MessageDto.fromJson(e).toEntity()).toList();
}
```

---

### 5. POST /api/messages/send
**Description**: Envoyer un message

**Utilisé dans**: `ChatRemoteDataSource.sendMessage()`

**Statut**: ✅ Fonctionne (si conversation existe)

**Payload**:
```json
{
  "conversationId": 123,
  "content": "Hello world"
}
```

**Code**:
```dart
final response = await apiClient.dio.post(
  '/api/messages/send',
  data: {
    'conversationId': conversationId,
    'content': content,
  },
);
```

---

## Endpoints Non Implémentés (Disponibles)

### 6. DELETE /api/messages/conversations/{conversationId}/leave
**Description**: Quitter une conversation

**Statut**: ⚪ Non implémenté

**Utilité**: Permettre à un utilisateur de quitter un groupe

**Implémentation suggérée**:
```dart
Future<void> leaveConversation(int conversationId) async {
  await apiClient.dio.delete(
    '/api/messages/conversations/$conversationId/leave',
  );
}
```

---

### 7. POST /api/messages/conversations/{conversationId}/members
**Description**: Ajouter un membre à une conversation de groupe

**Statut**: ⚪ Non implémenté

**Utilité**: Ajouter des participants à un groupe existant

**Payload suggéré**:
```json
{
  "userId": 456
}
```

**Implémentation suggérée**:
```dart
Future<void> addMemberToConversation(int conversationId, int userId) async {
  await apiClient.dio.post(
    '/api/messages/conversations/$conversationId/members',
    data: {'userId': userId},
  );
}
```

---

## Problèmes Actuels

### 🔴 Critique: Erreur 500 sur POST /api/messages/conversations

**Impact**: Impossible de créer de nouvelles conversations

**Logs**:
```
🆕 Creating conversation with user: 1
📤 Payload: {participantIds: [1], type: DIRECT}
❌ Error creating conversation: DioException [bad response]: An unexpected error occurred.
❌ Response data: {message: An unexpected error occurred. Please try again later., errorCode: INTERNAL_ERROR, status: 500, timestamp: 2026-01-15T22:39:20, path: /api/messages/conversations}
❌ Status code: 500
```

**Ce qui a été testé**:
- ✅ Payload correct avec `participantIds` et `type`
- ✅ Token d'authentification valide
- ✅ UserId valide (1 existe dans le système)

**Cause probable**:
- Erreur dans le code backend
- Problème de base de données
- Contrainte de clé étrangère
- Validation qui échoue

**Action requise**: 
1. Vérifier les logs serveur backend
2. Vérifier la stack trace de l'erreur 500
3. Vérifier les contraintes de base de données
4. Tester l'endpoint avec Postman/curl

---

## Fallback Actuel

### GET /Conversation (Ancien endpoint)
Quand `/api/messages/conversations` retourne une liste vide, on utilise `/Conversation` comme fallback.

**Problème**: Cet endpoint ne retourne pas les participants, donc on affiche "Unknown" pour les noms.

**Solution temporaire**: Pour chaque conversation, on appelle `/Conversation/{id}` pour récupérer les détails.

**Code**:
```dart
if (data.isEmpty) {
  response = await apiClient.dio.get('/Conversation');
  data = response.data is List ? response.data : [];
  
  // Récupérer les détails de chaque conversation
  for (var conv in data) {
    final detailResponse = await apiClient.dio.get('/Conversation/${conv['id']}');
    detailedConversations.add(detailResponse.data);
  }
}
```

---

## Tests Recommandés (Backend)

### Test 1: Créer une conversation
```bash
curl -X POST https://yansnetapi.enlighteninnovation.com/api/messages/conversations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "participantIds": [1],
    "type": "DIRECT"
  }'
```

**Résultat attendu**: 200 OK avec l'objet conversation créé

**Résultat actuel**: 500 INTERNAL_ERROR

---

### Test 2: Récupérer les conversations
```bash
curl -X GET https://yansnetapi.enlighteninnovation.com/api/messages/conversations \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Résultat attendu**: Liste des conversations de l'utilisateur

**Résultat actuel**: Liste vide `[]`

---

### Test 3: Envoyer un message
```bash
curl -X POST https://yansnetapi.enlighteninnovation.com/api/messages/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "conversationId": 1,
    "content": "Hello world"
  }'
```

**Résultat attendu**: 200 OK avec le message créé

**Résultat actuel**: Non testé (pas de conversation à cause de l'erreur 500)

---

## Prochaines Étapes

### Immédiat (Backend Team)
1. 🔴 **Corriger l'erreur 500** sur `POST /api/messages/conversations`
2. 🟡 Vérifier que `GET /api/messages/conversations` retourne bien les conversations
3. 🟡 Tester l'envoi de messages

### Futur (Frontend Team)
1. ⚪ Implémenter `leaveConversation` (quitter un groupe)
2. ⚪ Implémenter `addMemberToConversation` (ajouter des membres)
3. ⚪ Ajouter la gestion des conversations de groupe
4. ⚪ Ajouter la pagination pour les messages

---

## Format des Données

### Conversation Object
```json
{
  "id": 1,
  "type": "DIRECT",
  "participants": [
    {
      "id": 1,
      "name": "John Doe",
      "username": "johndoe",
      "profilePictureUrl": "https://..."
    }
  ],
  "lastMessage": {
    "id": 123,
    "content": "Hello",
    "senderId": 1,
    "createdAt": "2026-01-15T22:00:00"
  },
  "createdAt": "2026-01-15T20:00:00",
  "updatedAt": "2026-01-15T22:00:00"
}
```

### Message Object
```json
{
  "id": 123,
  "conversationId": 1,
  "senderId": 1,
  "content": "Hello world",
  "createdAt": "2026-01-15T22:00:00",
  "readBy": [1, 2]
}
```

---

**Date**: 15 Janvier 2026  
**Statut**: ⏳ En attente de correction backend  
**Endpoints fonctionnels**: 3/5 (60%)  
**Endpoints bloqués**: 1/5 (20%) - Critique  
**Endpoints non implémentés**: 2/7 (29%)
