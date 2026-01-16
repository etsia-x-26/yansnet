# 🐛 Guide de Debug - Erreur de Connexion Network

## 🚨 Problème Identifié

Vous avez une erreur **500 (Internal Server Error)** quand vous cliquez sur "Connect". Cela signifie que votre backend a un problème.

---

## 🔍 Étapes de Debug

### 1. Vérifier les Logs de l'Application

Après avoir ajouté les logs de debug, relancez l'application et essayez de vous connecter. Vous devriez voir dans la console :

```
🔗 CONNECTION REQUEST DEBUG
📤 Endpoint: /api/connections/request
👤 From User ID: 123
👥 To User ID: 456
⏰ Timestamp: 2024-01-15 10:30:00
──────────────────────────────────────────────────

❌ ERROR DEBUG
🔧 Operation: sendConnectionRequest
💥 Error: DioException [bad response]: Une erreur interne est survenue
📍 Stack Trace: ...
⏰ Timestamp: 2024-01-15 10:30:00
──────────────────────────────────────────────────
```

### 2. Vérifier l'Endpoint Backend

L'erreur indique que l'endpoint `/api/connections/request` existe mais retourne une erreur 500.

#### Test avec cURL :

```bash
curl -X POST https://yansnetapi.enlighteninnovation.com/api/connections/request \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "fromUserId": 123,
    "toUserId": 456
  }'
```

### 3. Problèmes Possibles du Backend

#### A. Endpoint non implémenté
```json
{
  "error": "Endpoint not found",
  "message": "/api/connections/request does not exist"
}
```

#### B. Base de données non configurée
```json
{
  "error": "Database error",
  "message": "Table 'connections' doesn't exist"
}
```

#### C. Validation des données
```json
{
  "error": "Validation error",
  "message": "fromUserId and toUserId are required"
}
```

#### D. Token d'authentification
```json
{
  "error": "Authentication error",
  "message": "Invalid or expired token"
}
```

---

## 🛠️ Solutions Possibles

### Solution 1 : Vérifier le Backend

1. **Connectez-vous à votre backend**
2. **Vérifiez les logs du serveur** pour voir l'erreur exacte
3. **Assurez-vous que l'endpoint existe** :

```java
// Exemple Spring Boot
@PostMapping("/api/connections/request")
public ResponseEntity<?> sendConnectionRequest(@RequestBody ConnectionRequest request) {
    // Votre logique ici
}
```

### Solution 2 : Utiliser un Endpoint Alternatif

Si l'endpoint `/api/connections/request` n'existe pas, essayons d'autres endpoints possibles :

```dart
// Dans network_remote_data_source.dart
@override
Future<bool> sendConnectionRequest(int fromUserId, int toUserId) async {
  final possibleEndpoints = [
    '/api/connections/request',
    '/api/connection/request',
    '/api/users/connect',
    '/api/network/connect',
    '/api/follow', // Si c'est un système de follow
  ];

  for (final endpoint in possibleEndpoints) {
    try {
      final response = await apiClient.dio.post(
        endpoint,
        data: {'fromUserId': fromUserId, 'toUserId': toUserId},
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Working endpoint found: $endpoint');
        return true;
      }
    } catch (e) {
      print('❌ Failed endpoint: $endpoint - $e');
      continue;
    }
  }
  
  throw Exception('No working endpoint found for connection request');
}
```

### Solution 3 : Mode Mock (Temporaire)

En attendant que le backend soit fixé, vous pouvez utiliser un mode mock :

```dart
@override
Future<bool> sendConnectionRequest(int fromUserId, int toUserId) async {
  // Mode mock pour les tests
  if (const bool.fromEnvironment('MOCK_MODE', defaultValue: false)) {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
  
  // Code normal...
}
```

---

## 🧪 Tests Recommandés

### Test 1 : Vérifier l'API avec Postman

1. Ouvrez Postman
2. Créez une requête POST vers `https://yansnetapi.enlighteninnovation.com/api/connections/request`
3. Ajoutez les headers :
   ```
   Content-Type: application/json
   Authorization: Bearer YOUR_TOKEN
   ```
4. Ajoutez le body :
   ```json
   {
     "fromUserId": 123,
     "toUserId": 456
   }
   ```
5. Envoyez la requête et regardez la réponse

### Test 2 : Vérifier les Autres Endpoints

Testez si ces endpoints existent :
- `GET /api/users` (pour voir si l'API fonctionne)
- `GET /api/network/stats/123` (pour voir si le module network existe)
- `POST /api/auth/login` (pour voir si l'auth fonctionne)

### Test 3 : Vérifier le Token

```bash
# Décoder votre JWT token
echo "YOUR_TOKEN" | base64 -d
```

---

## 📋 Checklist de Debug

- [ ] Les logs de debug s'affichent dans la console
- [ ] L'endpoint `/api/connections/request` existe sur le backend
- [ ] Le backend retourne une réponse (même si c'est une erreur)
- [ ] Le token JWT est valide et non expiré
- [ ] Les paramètres `fromUserId` et `toUserId` sont corrects
- [ ] La base de données est accessible
- [ ] Les tables nécessaires existent

---

## 🔧 Code de Debug Temporaire

Ajoutez ce code temporaire dans votre `NetworkProvider` pour plus d'informations :

```dart
Future<bool> connectUser(int fromUserId, int toUserId) async {
  try {
    print('🔍 DEBUG: Attempting to connect user $fromUserId to $toUserId');
    print('🔍 DEBUG: Current user: ${context.read<AuthProvider>().currentUser}');
    print('🔍 DEBUG: Auth token exists: ${context.read<AuthProvider>().token != null}');
    
    final success = await sendConnectionRequestUseCase(fromUserId, toUserId);
    
    print('🔍 DEBUG: Connection result: $success');
    return success;
  } catch (e, stackTrace) {
    print('🔍 DEBUG: Connection error: $e');
    print('🔍 DEBUG: Stack trace: $stackTrace');
    rethrow;
  }
}
```

---

## 📞 Prochaines Étapes

1. **Relancez l'application** avec les nouveaux logs
2. **Essayez de vous connecter** et regardez la console
3. **Testez l'API avec Postman** pour identifier le problème exact
4. **Vérifiez les logs du backend** si vous y avez accès
5. **Contactez l'équipe backend** avec les détails de l'erreur

---

## 💡 Message d'Erreur Amélioré

Maintenant, au lieu de voir juste "Une erreur interne est survenue", vous verrez des messages plus précis comme :

- ✅ "Server error: The backend encountered an internal error. Please check if the endpoint /api/connections/request exists and is properly configured."
- ✅ "Endpoint not found: /api/connections/request does not exist on the server."
- ✅ "Authentication error: Please check your login token."
- ✅ "Bad request: Invalid user IDs or request format."

---

**Relancez l'application et essayez à nouveau. Les nouveaux logs vous donneront plus d'informations sur le problème exact ! 🚀**