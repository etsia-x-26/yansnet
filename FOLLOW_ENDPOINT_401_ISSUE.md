# Problème 401 avec l'endpoint Follow

## Diagnostic
L'endpoint `POST /follow/{followerId}/{followedId}` retourne une **erreur 401 Unauthorized**.

### Test Swagger
- URL: `https://yansnetapi.enlighteninnovation.com/follow/2/3`
- Méthode: POST
- Résultat: **401 Unauthorized**
- Headers: `www-authenticate: Bearer`

## Cause Probable
L'endpoint nécessite une authentification Bearer token, mais:
1. Le token n'est pas fourni dans Swagger (besoin de cliquer sur "Authorize" 🔒)
2. Ou le token fourni n'a pas les permissions nécessaires
3. Ou il y a un bug backend qui rejette les tokens valides

## Solution pour Tester dans Swagger

### Étape 1: S'authentifier dans Swagger
1. Allez sur Swagger UI: https://yansnetapi.enlighteninnovation.com/swagger-ui/index.html
2. Cherchez l'endpoint de login (probablement `/auth/login` ou `/api/auth/login`)
3. Exécutez le login avec vos credentials (etie20)
4. Copiez le `accessToken` de la réponse

### Étape 2: Autoriser Swagger
1. Cliquez sur le bouton "Authorize" 🔒 en haut à droite
2. Entrez: `Bearer {votre_token}` (remplacez {votre_token} par le token copié)
3. Cliquez sur "Authorize"

### Étape 3: Retester Follow
1. Retournez à `POST /follow/{followerId}/{followedId}`
2. Entrez followerId=2, followedId=3
3. Cliquez sur "Execute"
4. Vérifiez si ça retourne 200 ou toujours 401

## Solution pour Flutter

Si le test Swagger fonctionne après authentification, alors le problème Flutter est que:
- Le token n'est pas correctement envoyé
- Le token a expiré

### Vérification du Token
Ajoutez ces logs pour vérifier:

\`\`\`dart
final token = await _storage.read(key: 'auth_token');
print('🔑 Token exists: ${token != null}');
print('🔑 Token length: ${token?.length}');
print('🔑 Token preview: ${token?.substring(0, min(20, token.length ?? 0))}...');
\`\`\`

## Si le problème persiste

### Option 1: Contacter l'équipe Backend
Signaler que l'endpoint `/follow/{followerId}/{followedId}` retourne 401 même avec un token valide.

### Option 2: Vérifier les permissions
Peut-être que l'endpoint nécessite un rôle spécial (ADMIN, MODERATOR, etc.)

### Option 3: Utiliser un endpoint alternatif
Vérifier s'il existe un autre endpoint pour follow:
- `POST /api/follow/{followerId}/{followedId}`
- `POST /connections/request`
- `POST /users/{userId}/follow/{targetUserId}`

## Logs à Partager
Pour diagnostiquer, partagez:
1. Les logs de l'app qui montrent `🔗 Trying to follow:`
2. Le token (premiers 20 caractères seulement)
3. Le résultat du test Swagger après authentification
