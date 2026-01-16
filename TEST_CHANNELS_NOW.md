# 🧪 Guide de Test Rapide - Channels

## Ce qui a été corrigé
Le problème d'erreur réseau lors de la création de chaînes a été résolu en ajoutant un fallback automatique entre `/api/channel` et `/channel`.

## Test en 5 étapes

### 1. Lancer l'application
```bash
flutter run -d chrome --web-port=8081
```

### 2. Naviguer vers Channels
- Cliquer sur l'onglet **Messages** (en bas)
- Cliquer sur l'onglet **Channels** (en haut)

### 3. Créer une chaîne
- Cliquer sur le bouton **✏️** (en bas à droite)
- Sélectionner **"Créer un canal"**
- Remplir:
  - **Nom**: Test Channel
  - **Description**: Test description
- Cliquer sur **"Créer"**

### 4. Vérifier les logs
Ouvrir la console du navigateur (F12) et chercher:
```
🌐 Trying endpoint: /api/channel
✅ Channel created successfully with /api/channel!
```
OU
```
🌐 Trying endpoint: /channel
✅ Channel created successfully with /channel!
```

### 5. Vérifier le résultat
- ✅ Un message de succès devrait apparaître
- ✅ La chaîne devrait apparaître dans la liste
- ✅ Vous devriez revenir à l'écran Messages

## Si ça ne fonctionne pas

### Vérifier les logs d'erreur
Chercher dans la console:
```
❌ Error with /api/channel: ...
❌ Error with /channel: ...
```

### Copier les informations suivantes:
1. Le message d'erreur complet
2. Le `Error type:` (ex: DioExceptionType.unknown)
3. Le `Status code:` (ex: 404, 500, null)
4. Le `Response data:` (si disponible)

### Tester avec curl (optionnel)
```bash
# Remplacer YOUR_TOKEN par votre token d'authentification
curl -X POST https://yansnetapi.enlighteninnovation.com/api/channel \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"title": "Test", "description": "Test description"}'
```

## Que faire après le test?

### ✅ Si ça fonctionne:
1. Noter quel endpoint a fonctionné (dans les logs)
2. Tester aussi:
   - Charger la liste des chaînes (rafraîchir la page)
   - Suivre/Ne plus suivre une chaîne (si disponible dans l'UI)

### ❌ Si ça ne fonctionne pas:
1. Copier tous les logs d'erreur
2. Vérifier que vous êtes bien connecté (token valide)
3. Vérifier la connexion internet
4. Contacter le backend team avec les logs

## Logs à surveiller

### Création de chaîne:
```
🆕 Creating channel: Test Channel
📤 Payload: {title: Test Channel, description: Test description}
🌐 Base URL: https://yansnetapi.enlighteninnovation.com
🌐 Trying endpoint: /api/channel
🌐 Full URL: https://yansnetapi.enlighteninnovation.com/api/channel
```

### Succès:
```
✅ Channel created successfully with /api/channel!
🔍 Response: {id: 1, title: Test Channel, ...}
✅ ChannelsProvider: Channel created
```

### Erreur:
```
❌ Error with /api/channel: DioException [...]
❌ Error type: DioExceptionType.badResponse
❌ Error message: ...
❌ Request full URL: https://yansnetapi.enlighteninnovation.com/api/channel
❌ Response data: {...}
❌ Status code: 404
```

---

**Prêt à tester!** 🚀
