# Intégration de la Messagerie - Documentation

## Vue d'ensemble
L'intégration de la messagerie permet d'envoyer et de recevoir des messages en temps réel en utilisant les endpoints REST API du backend.

## Endpoints API Utilisés

### 1. Conversations
- **GET** `/api/messages/conversations` - Récupérer toutes les conversations de l'utilisateur
- **POST** `/api/messages/conversations` - Créer une nouvelle conversation
  ```json
  {
    "participantIds": [userId1, userId2, ...]
  }
  ```
- **GET** `/api/messages/conversations/{conversationId}` - Récupérer une conversation par ID

### 2. Messages
- **GET** `/api/messages/conversations/{conversationId}/messages` - Récupérer tous les messages d'une conversation
- **POST** `/api/messages/send` - Envoyer un message
  ```json
  {
    "conversationId": 123,
    "content": "Votre message ici"
  }
  ```

### 3. Gestion de Groupe
- **POST** `/api/messages/conversations/{conversationId}/members` - Ajouter un membre au groupe
- **DELETE** `/api/messages/conversations/{conversationId}/leave` - Quitter une conversation

## Architecture Clean Architecture

### Domain Layer
- **Entities**: `Message`, `Conversation`
- **Use Cases**:
    - `GetConversationsUseCase` - Récupérer les conversations
    - `GetMessagesUseCase` - Récupérer les messages
    - `SendMessageUseCase` - Envoyer un message
    - `StartChatUseCase` - Démarrer une nouvelle conversation

### Data Layer
- **Data Sources**: `ChatRemoteDataSource` - Gère les appels API
- **Models**: `MessageDto`, `ConversationDto` - Mapping JSON ↔ Entity
- **Repository**: `ChatRepositoryImpl` - Implémentation du repository

### Presentation Layer
- **Provider**: `ChatProvider` - Gestion d'état avec ChangeNotifier
- **Screens**:
    - `InstagramChatScreen` - Interface de chat 1-to-1 et groupe
    - `InstagramNewMessageScreen` - Recherche et sélection d'utilisateurs
    - `InstagramGroupSelectionScreen` - Création de groupe
    - `MessagesScreen` - Liste des conversations

## Fonctionnalités Implémentées

### ✅ Messagerie 1-to-1
- Démarrage automatique d'une conversation lors de la sélection d'un utilisateur
- Envoi et réception de messages
- Affichage des messages avec distinction expéditeur/destinataire
- Scroll automatique vers le dernier message

### ✅ Interface Style Instagram
- Barre de recherche "À: Rechercher"
- Options rapides (Discussion de groupe, Créer un canal, Discussions IA)
- Liste de suggestions d'utilisateurs
- Badge "Connecté" pour les utilisateurs connectés
- Design moderne avec bulles de messages

### ✅ Création de Groupes
- Sélection multiple d'utilisateurs avec checkboxes carrées
- Nom de groupe facultatif
- Interface style Instagram

### ✅ Création de Canaux
- Interface Instagram-style avec photo de profil
- Options d'audience (Tout le monde, Abonnés uniquement, Privé)
- Paramètres de visibilité et commentaires

## Utilisation

### 1. Ouvrir une conversation existante
```dart
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => InstagramChatScreen(
recipientUser: user,
conversationId: conversationId,
isGroup: false,
),
),
);
```

### 2. Démarrer une nouvelle conversation
```dart
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => InstagramChatScreen(
recipientUser: user,
isGroup: false,
),
),
);
```

### 3. Créer un groupe
```dart
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => InstagramChatScreen(
recipientUser: firstUser,
isGroup: true,
groupName: 'Mon Groupe',
groupMembers: [user1, user2, user3],
),
),
);
```

## Gestion d'État avec ChatProvider

### Méthodes Principales
- `loadConversations()` - Charge toutes les conversations
- `loadMessages(conversationId)` - Charge les messages d'une conversation
- `sendMessage(conversationId, content)` - Envoie un message
- `startChat(otherUserId)` - Démarre une nouvelle conversation
- `getMessages(conversationId)` - Récupère les messages en cache

### Exemple d'utilisation
```dart
// Dans un widget
final chatProvider = context.watch<ChatProvider>();
final messages = chatProvider.getMessages(conversationId);

// Envoyer un message
await context.read<ChatProvider>().sendMessage(conversationId, 'Hello!');
```

## Structure des Données

### Message Entity
```dart
class Message {
  final int id;
  final int conversationId;
  final String content;
  final int senderId;
  final DateTime createdAt;
  final bool isRead;
}
```

### Conversation Entity
```dart
class Conversation {
  final int id;
  final List<User> participants;
  final Message? lastMessage;
  final int unreadCount;
}
```

## Prochaines Étapes

### À Implémenter
1. **WebSocket pour temps réel** - Réception instantanée des messages
2. **Indicateurs de lecture** - Marquer les messages comme lus
3. **Indicateur de frappe** - "X est en train d'écrire..."
4. **Envoi de médias** - Photos, vidéos, fichiers
5. **Messages vocaux** - Enregistrement et lecture
6. **Réactions aux messages** - Emojis, likes
7. **Réponses aux messages** - Thread de conversation
8. **Suppression de messages** - Pour soi ou pour tous
9. **Recherche dans les messages** - Recherche de contenu
10. **Notifications push** - Alertes de nouveaux messages

### Améliorations UI/UX
- Animation d'envoi de message
- Prévisualisation des liens
- Avatars de groupe personnalisés
- Statut en ligne/hors ligne
- Dernière connexion
- Confirmation de lecture (double check)

## Notes Techniques

### Gestion du Cache
Les messages sont mis en cache dans `ChatProvider._messages` (Map<int, List<Message>>)
pour éviter les rechargements inutiles.

### Scroll Automatique
Le `ScrollController` est utilisé pour scroller automatiquement vers le bas
lors de l'envoi ou de la réception de nouveaux messages.

### Initialisation de Conversation
Si aucun `conversationId` n'est fourni, l'écran appelle automatiquement
`startChat()` pour créer une nouvelle conversation.

### Logs de Debug
Des logs `print()` sont ajoutés dans `ChatRemoteDataSource` pour faciliter
le debugging des appels API. À remplacer par un système de logging en production.

## Dépendances
- `provider` - Gestion d'état
- `google_fonts` - Police Plus Jakarta Sans
- `dio` - Client HTTP (via ApiClient)
- `shared_preferences` - Persistance locale (pour les connexions)

## Fichiers Modifiés
- ✅ `lib/screens/instagram_chat_screen.dart` - Interface de chat avec API
- ✅ `lib/screens/instagram_new_message_screen.dart` - Recherche et nouveau message
- ✅ `lib/screens/instagram_group_selection_screen.dart` - Création de groupe
- ✅ `lib/screens/instagram_create_channel_screen.dart` - Création de canal
- ✅ `lib/screens/messages_screen.dart` - Liste des conversations
- ✅ `lib/features/chat/data/datasources/chat_remote_data_source.dart` - Endpoints API
- ✅ `lib/features/chat/presentation/providers/chat_provider.dart` - Gestion d'état

## Tests
Pour tester l'intégration:
1. Lancer l'application
2. Aller dans l'onglet Messages
3. Cliquer sur le bouton ✏️ (nouveau message)
4. Rechercher un utilisateur
5. Cliquer sur l'utilisateur pour ouvrir le chat
6. Envoyer un message
7. Vérifier que le message apparaît dans la conversation

## Troubleshooting

### Les messages ne s'affichent pas
- Vérifier que `conversationId` est correct
- Vérifier les logs de l'API dans la console
- Vérifier que l'utilisateur est authentifié

### Erreur lors de l'envoi
- Vérifier le format du payload dans `sendMessage`
- Vérifier que le backend accepte le format JSON
- Vérifier les logs de `ChatRemoteDataSource`

### Conversation ne se crée pas
- Vérifier que `participantIds` est un tableau
- Vérifier que l'utilisateur cible existe
- Vérifier les permissions backend
