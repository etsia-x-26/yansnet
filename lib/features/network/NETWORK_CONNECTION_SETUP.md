# Network Connection Setup Guide

## Configuration du NetworkProvider avec la connexion persistante

### 1. Mise à jour de l'injection de dépendances

Dans votre fichier d'initialisation des providers (généralement `main.dart` ou un fichier de configuration DI), vous devez mettre à jour l'initialisation du `NetworkProvider` pour inclure le nouveau `SendConnectionRequestUseCase`.

#### Exemple avec Provider:

```dart
import 'package:provider/provider.dart';
import 'features/network/domain/usecases/send_connection_request_usecase.dart';
import 'features/network/domain/usecases/get_network_stats_usecase.dart';
import 'features/network/domain/usecases/get_network_suggestions_usecase.dart';
import 'features/network/data/repositories/network_repository_impl.dart';
import 'features/network/data/datasources/network_remote_data_source.dart';
import 'features/network/presentation/providers/network_provider.dart';
import 'core/network/api_client.dart';

// Dans votre méthode de configuration des providers
MultiProvider(
  providers: [
    // ... autres providers
    
    // Network Provider avec toutes les dépendances
    ChangeNotifierProvider<NetworkProvider>(
      create: (context) {
        final apiClient = context.read<ApiClient>();
        final remoteDataSource = NetworkRemoteDataSourceImpl(apiClient);
        final repository = NetworkRepositoryImpl(remoteDataSource);
        
        return NetworkProvider(
          getNetworkStatsUseCase: GetNetworkStatsUseCase(repository),
          getNetworkSuggestionsUseCase: GetNetworkSuggestionsUseCase(repository),
          sendConnectionRequestUseCase: SendConnectionRequestUseCase(repository),
        );
      },
    ),
  ],
  child: MyApp(),
)
```

### 2. Endpoints API requis

Assurez-vous que votre backend expose les endpoints suivants :

#### Envoyer une demande de connexion
```
POST /api/connections/request
Body: {
  "fromUserId": 123,
  "toUserId": 456
}
Response: 200 OK ou 201 Created
```

#### Accepter une demande de connexion
```
POST /api/connections/accept/{requestId}
Response: 200 OK
```

#### Rejeter une demande de connexion
```
POST /api/connections/reject/{requestId}
Response: 200 OK
```

#### Obtenir les suggestions de réseau
```
GET /api/network/suggestions/{userId}
Response: [
  {
    "user": {
      "id": 456,
      "name": "John Doe",
      "email": "john@example.com",
      "username": "johndoe",
      "profilePictureUrl": "https://...",
      "bio": "...",
      "isMentor": false
    },
    "mutualConnectionsCount": 5,
    "reason": "Suggested for you"
  }
]
```

#### Obtenir les statistiques du réseau
```
GET /api/network/stats/{userId}
Response: {
  "connectionsCount": 150,
  "contactsCount": 200,
  "channelsCount": 10
}
```

### 3. Utilisation dans l'interface

Le `NetworkScreen` utilise maintenant automatiquement la connexion persistante :

```dart
// Le bouton Connect appelle automatiquement l'API
ElevatedButton(
  onPressed: provider.isUserConnected(suggestion.user.id)
    ? null
    : () async {
        final currentUserId = context.read<AuthProvider>().currentUser?.id;
        final success = await provider.connectUser(
          currentUserId,
          suggestion.user.id,
        );
        // La connexion est maintenant persistée dans la base de données
      },
  child: Text(
    provider.isUserConnected(suggestion.user.id) 
      ? 'Connected' 
      : 'Connect'
  ),
)
```

### 4. Fonctionnalités implémentées

✅ **Connexion persistante** : Les connexions sont sauvegardées dans la base de données via l'API
✅ **État synchronisé** : Le provider garde en mémoire les utilisateurs connectés
✅ **Mise à jour automatique** : Les statistiques sont mises à jour après chaque connexion
✅ **Gestion d'erreurs** : Messages d'erreur clairs en cas de problème
✅ **Rechargement des données** : Les suggestions sont rechargées après une connexion réussie
✅ **UI réactive** : Le bouton change d'état immédiatement après la connexion

### 5. Gestion des erreurs

Le système gère automatiquement les erreurs suivantes :
- Utilisateur non connecté
- Échec de la requête réseau
- Erreurs serveur
- Timeout de connexion

Toutes les erreurs sont affichées via `DialogUtils.showError()` avec des messages clairs.

### 6. Tests

Pour tester la fonctionnalité :

1. Lancez votre application
2. Allez sur la page Network
3. Cliquez sur "Connect" pour un utilisateur suggéré
4. Vérifiez que :
   - Le bouton devient "Connected" et grisé
   - Un message de succès s'affiche
   - La connexion persiste après redémarrage de l'app
   - Les statistiques sont mises à jour

### 7. Prochaines étapes (optionnel)

Vous pouvez ajouter :
- Notifications push pour les nouvelles demandes de connexion
- Page de gestion des demandes en attente
- Possibilité de se déconnecter d'un utilisateur
- Filtres et recherche dans les suggestions
- Analytics sur les connexions
