# Intégration des Chaînes (Channels) - Documentation

## Vue d'ensemble
L'intégration des chaînes permet de créer, consulter, suivre et ne plus suivre des chaînes.

## Endpoints API Utilisés

### 1. Gestion des Chaînes
**Note**: L'implémentation essaie automatiquement `/api/channel` puis `/channel` comme fallback.

- **POST** `/api/channel` ou `/channel` - Créer une chaîne
  ```json
  {
    "title": "Nom de la chaîne",
    "description": "Description de la chaîne"
  }
  ```

- **GET** `/api/channel/{id}` ou `/channel/{id}` - Récupérer une chaîne par ID

- **GET** `/api/channel` ou `/channel` - Récupérer toutes les chaînes

### 2. Follow/Unfollow
**Note**: L'implémentation essaie automatiquement `/api/channelFollow` puis `/channelFollow` comme fallback.

- **POST** `/api/channelFollow/follow/{channelId}/{followerId}` - Suivre une chaîne
- **DELETE** `/api/channelFollow/unfollow/{channelId}/{followerId}` - Ne plus suivre une chaîne

## Architecture Clean Architecture

### Domain Layer
- **Entity**: `Channel` - Entité de chaîne avec `id`, `title`, `description`, `totalFollowers`, `isFollowing`
- **Repository**: `ChannelRepository` - Interface pour les opérations sur les chaînes
- **Use Cases**: 
  - `GetChannelsUseCase` - Récupérer les chaînes
  - `CreateChannelUseCase` - Créer une chaîne

### Data Layer
- **Data Source**: `ChannelRemoteDataSource` - Gère les appels API
- **Model**: `ChannelDto` - Mapping JSON ↔ Entity
- **Repository**: `ChannelRepositoryImpl` - Implémentation du repository

### Presentation Layer
- **Provider**: `ChannelsProvider` - Gestion d'état avec ChangeNotifier
- **Screens**: 
  - `InstagramCreateChannelScreen` - Création de chaîne style Instagram
  - `ChannelDetailScreen` - Détails d'une chaîne (à créer)
  - `MessagesScreen` - Liste des chaînes dans l'onglet "Channels"

## Fonctionnalités Implémentées

### ✅ Création de Chaîne
- Interface Instagram-style avec photo de profil
- Champs: Nom, Description
- Options: Audience (Tout le monde, Abonnés uniquement, Privé)
- Paramètres: Afficher le nombre d'abonnés, Autoriser les commentaires

### ✅ Liste des Chaînes
- Affichage dans l'onglet "Channels" de Messages
- Icône # pour les chaînes
- Nom et nombre de membres

### ✅ Follow/Unfollow
- Méthodes dans `ChannelsProvider`:
  - `followChannel(channelId, followerId)`
  - `unfollowChannel(channelId, followerId)`
- Mise à jour automatique du compteur de followers
- Mise à jour de l'état `isFollowing`

### ✅ Chargement d'une Chaîne
- Méthode `loadChannel(channelId)` dans `ChannelsProvider`
- Stockage dans `_currentChannel`

## Structure des Données

### Channel Entity
```dart
class Channel {
  final int id;
  final String title;
  final String description;
  final int totalFollowers;
  final bool isFollowing;
}
```

### API Response Format
```json
{
  "id": 1,
  "title": "Flutter Developers",
  "description": "A channel for Flutter developers",
  "followersCount": 150,
  "isFollowing": true
}
```

## Utilisation

### 1. Créer une chaîne
```dart
final success = await context.read<ChannelsProvider>().createChannel(
  'Nom de la chaîne',
  'Description de la chaîne',
);
```

### 2. Charger les chaînes
```dart
await context.read<ChannelsProvider>().loadChannels();
final channels = context.watch<ChannelsProvider>().channels;
```

### 3. Suivre une chaîne
```dart
final currentUser = context.read<AuthProvider>().currentUser;
final success = await context.read<ChannelsProvider>().followChannel(
  channelId,
  currentUser!.id,
);
```

### 4. Ne plus suivre une chaîne
```dart
final currentUser = context.read<AuthProvider>().currentUser;
final success = await context.read<ChannelsProvider>().unfollowChannel(
  channelId,
  currentUser!.id,
);
```

### 5. Charger une chaîne spécifique
```dart
await context.read<ChannelsProvider>().loadChannel(channelId);
final channel = context.watch<ChannelsProvider>().currentChannel;
```

## Prochaines Étapes

### À Implémenter
1. **Écran de détails de chaîne** - Afficher les informations complètes
2. **Publications dans les chaînes** - Créer et afficher des posts
3. **Liste des abonnés** - Voir qui suit la chaîne
4. **Recherche de chaînes** - Trouver des chaînes par nom
5. **Catégories de chaînes** - Organiser par thème
6. **Notifications** - Alertes pour nouvelles publications
7. **Modération** - Gérer les membres et le contenu
8. **Statistiques** - Vues, engagement, croissance

### Améliorations UI/UX
- Animation de follow/unfollow
- Badge "Suivi" sur les chaînes suivies
- Suggestions de chaînes
- Chaînes tendances
- Prévisualisation des dernières publications

## Fichiers Modifiés

- ✅ `lib/features/channels/data/datasources/channel_remote_data_source.dart`
  - Ajout de `getChannel`, `followChannel`, `unfollowChannel`
  - Logs détaillés
  - Endpoints corrects (`/channel` au lieu de `/api/channels`)

- ✅ `lib/features/channels/domain/repositories/channel_repository.dart`
  - Ajout des méthodes follow/unfollow

- ✅ `lib/features/channels/data/repositories/channel_repository_impl.dart`
  - Implémentation des nouvelles méthodes

- ✅ `lib/features/channels/presentation/providers/channels_provider.dart`
  - Ajout de `followChannel`, `unfollowChannel`, `loadChannel`
  - Gestion de `_currentChannel`
  - Mise à jour automatique de l'état

- ✅ `lib/features/channels/domain/entities/channel_entity.dart`
  - Ajout du champ `isFollowing`

- ✅ `lib/features/channels/data/models/channel_dto.dart`
  - Ajout du champ `isFollowing`
  - Support de `followersCount` et `totalFollowers`

- ✅ `lib/screens/instagram_create_channel_screen.dart`
  - Interface Instagram-style complète

## Tests

Pour tester l'intégration:
1. Lancer l'application
2. Aller dans Messages → Onglet "Channels"
3. Cliquer sur le bouton ✏️ → "Créer un canal"
4. Remplir le formulaire et créer
5. La chaîne devrait apparaître dans la liste

## Notes Techniques

### Gestion du State
Les chaînes sont stockées dans `ChannelsProvider._channels` et la chaîne courante dans `_currentChannel`.

### Logs de Debug
Des logs `print()` sont ajoutés pour faciliter le debugging. À remplacer par un système de logging en production.

### Endpoints
Les endpoints utilisent `/channel` (sans `/api`) selon la documentation API fournie.

## Dépendances
- `provider` - Gestion d'état
- `google_fonts` - Police Plus Jakarta Sans
- `dio` - Client HTTP (via ApiClient)

## Statut
🔄 **En cours de test** - Implémentation de fallback pour les endpoints

### Changements Récents
- ✅ Ajout de fallback automatique entre `/api/channel` et `/channel`
- ✅ Tous les endpoints (GET, POST, DELETE) essaient d'abord `/api/channel` puis `/channel`
- ✅ Logs détaillés pour identifier quel endpoint fonctionne
- ✅ Même logique pour follow/unfollow: `/api/channelFollow` puis `/channelFollow`

### Problème Précédent
- `POST /channel` retournait `DioException [unknown]` avec response null
- Cause possible: endpoint incorrect (devrait être `/api/channel`)

### Solution Implémentée
Tous les endpoints de channels essaient maintenant deux variantes:
1. Avec préfixe `/api/` (standard pour les autres endpoints de l'app)
2. Sans préfixe `/api/` (fallback)

Les logs indiqueront quel endpoint a fonctionné pour ajuster la documentation.

**Date**: 15 Janvier 2026
