import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/app/app.dart';
import 'package:yansnet/app/router/routes.dart';
import 'package:yansnet/app/view/app_nav_page.dart';
import 'package:yansnet/authentication/cubit/authentication_cubit.dart';
import 'package:yansnet/authentication/views/login_page.dart';
import 'package:yansnet/authentication/views/register_page.dart';
import 'package:yansnet/conversation/views/chat_conversation_page.dart';
import 'package:yansnet/conversation/views/group_details_page.dart';
import 'package:yansnet/conversation/views/group_documents_page.dart';
import 'package:yansnet/conversation/views/group_important_messages_page.dart';
import 'package:yansnet/conversation/views/group_info_page.dart';
import 'package:yansnet/conversation/views/group_links_page.dart';
import 'package:yansnet/conversation/views/group_media_page.dart';
import 'package:yansnet/conversation/views/messages_empty_page.dart';
import 'package:yansnet/conversation/views/messages_list_page.dart';
import 'package:yansnet/conversation/views/messages_no_connection_page.dart';
// import 'package:yansnet/counter/view/counter_page.dart';
import 'package:yansnet/profile/view/sheet_parametre_profile.dart';
import 'package:yansnet/publication/views/create_post_page.dart';
import 'package:yansnet/subscription/views/another_profile_screen.dart';
import 'package:yansnet/subscription/views/create_channel_screen.dart';
import 'package:yansnet/subscription/views/create_group_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthenticationCubit authCubit) {
    // static GoRouter createRouter() {
    // final authNotifier = AuthChangeNotifier(authCubit);
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      // initialLocation: AppRoutes.authLoginRoute,
      initialLocation: AppRoutes.homeRoute,
      // refreshListenable: authNotifier,
      // redirect: (context, state) {
      //   final authState = authNotifier.state;
      //   final isAuthRoute = state.matchedLocation.startsWith('/auth');

      //   // Si l'utilisateur est connecté et essaie d'accéder aux pages d'auth
      //   if (authState is UserFetched && isAuthRoute) {
      //     return AppRoutes.homeRoute;
      //   }

      //   // Si l'utilisateur n'est pas connecté et
      //   // essaie d'accéder aux pages protégées
      //   if (authState is! UserFetched &&
      //       !isAuthRoute &&
      //       authState is! AuthLoading) {
      //     return AppRoutes.authLoginRoute;
      //   }

      //   // Si l'utilisateur est déconnecté
      //   if (authState is Logout) {
      //     return AppRoutes.authLoginRoute;
      //   }

      //   return null;
      // },
      routes: [
        GoRoute(
          name: 'home',
          path: AppRoutes.homeRoute,
          builder: (ctx, state) => const ApppNavigationPage(),
        ),
        GoRoute(
          name: 'splash',
          path: AppRoutes.splashRoute,
          builder: (ctx, state) => const SplashPage(),
        ),
        GoRoute(
          name: 'createPostPage',
          path: AppRoutes.createPostPageRoute,
          builder: (ctx, state) => const CreatePostPage(),
        ),
        GoRoute(
          name: 'register',
          path: AppRoutes.authRegisterRoute,
          builder: (ctx, state) => const RegisterPage(),
        ),
        GoRoute(
          name: 'login',
          path: AppRoutes.authLoginRoute,
          builder: (ctx, state) => const LoginPage(),
        ),

        // Messages routes
        GoRoute(
          name: 'messages_list',
          path: AppRoutes.messagesRoute,
          builder: (ctx, state) => const MessagesListPage(),
          routes: [
            GoRoute(
              name: 'empty_messages',
              path: AppRoutes.emptyMessagesRoute,
              builder: (ctx, state) => const MessagesEmptyPage(),
            ),
            GoRoute(
              name: 'connection_error',
              path: AppRoutes.connectionErrorRoute,
              builder: (ctx, state) => const MessagesNoConnectionPage(),
            ),
          ],
        ),

        // Chat routes
        GoRoute(
          name: 'chat_conversation',
          path: AppRoutes.chatConversationRoute,
          builder: (ctx, state) {
            final userName = state.pathParameters['userName'] ?? 'Utilisateur';
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final userAvatar = extra['userAvatar'] as String? ??
                'https://i.pravatar.cc/150?img=1';
            final lastSeen = extra['lastSeen'] as String? ?? '25/06/2025';
            return ChatConversationPage(
              userName: userName,
              userAvatar: userAvatar,
              lastSeen: lastSeen,
            );
          },
        ),

        // Group routes
        GoRoute(
          name: 'group_chat',
          path: '${AppRoutes.groupChatRoute}/:groupName',
          builder: (ctx, state) {
            // Décoder le nom du groupe depuis l'URL de manière sécurisée
            final encodedGroupName = state.pathParameters['groupName'] ?? 'Groupe';
            String groupName;
            try {
              groupName = Uri.decodeComponent(encodedGroupName);
            } catch (e) {
              // Si le décodage échoue (nom déjà décodé ou mal formé), utiliser tel quel
              groupName = encodedGroupName;
            }
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final groupAvatar = extra['groupAvatar'] as String? ??
                'https://i.pravatar.cc/150?img=10';
            final memberCount = extra['memberCount'] as int? ?? 41;
            final isUserAdmin = extra['isUserAdmin'] as bool? ?? false;
            return GroupInfoPage(
              groupName: groupName,
              groupAvatar: groupAvatar,
              memberCount: memberCount,
              isUserAdmin: isUserAdmin,
            );
          },
          routes: [
            GoRoute(
              name: 'group_info',
              path: AppRoutes.groupInfoRoute,
              builder: (ctx, state) {
                // Décoder le nom du groupe depuis l'URL de manière sécurisée
                final encodedGroupName = state.pathParameters['groupName'] ?? 'Groupe';
                String groupName;
                try {
                  groupName = Uri.decodeComponent(encodedGroupName);
                } catch (e) {
                  // Si le décodage échoue (nom déjà décodé ou mal formé), utiliser tel quel
                  groupName = encodedGroupName;
                }
                final extra = state.extra as Map<String, dynamic>? ?? {};
                final groupAvatar = extra['groupAvatar'] as String? ??
                    'https://i.pravatar.cc/150?img=10';
                final memberCount = extra['memberCount'] as int? ?? 41;
                final isUserAdmin = extra['isUserAdmin'] as bool? ?? false;
                return GroupDetailsPage(
                  groupName: groupName,
                  groupAvatar: groupAvatar,
                  memberCount: memberCount,
                  isUserAdmin: isUserAdmin,
                );
              },
              routes: [
                GoRoute(
                  name: 'group_media',
                  path: AppRoutes.groupMediaRoute,
                  builder: (ctx, state) {
                    final encodedGroupName = state.pathParameters['groupName'] ?? 'Groupe';
                    String groupName;
                    try {
                      groupName = Uri.decodeComponent(encodedGroupName);
                    } catch (e) {
                      groupName = encodedGroupName;
                    }
                    return GroupMediaPage(groupName: groupName);
                  },
                ),
                GoRoute(
                  name: 'group_links',
                  path: AppRoutes.groupLinksRoute,
                  builder: (ctx, state) {
                    final encodedGroupName = state.pathParameters['groupName'] ?? 'Groupe';
                    String groupName;
                    try {
                      groupName = Uri.decodeComponent(encodedGroupName);
                    } catch (e) {
                      groupName = encodedGroupName;
                    }
                    return GroupLinksPage(groupName: groupName);
                  },
                ),
                GoRoute(
                  name: 'group_documents',
                  path: AppRoutes.groupDocumentsRoute,
                  builder: (ctx, state) {
                    final encodedGroupName = state.pathParameters['groupName'] ?? 'Groupe';
                    String groupName;
                    try {
                      groupName = Uri.decodeComponent(encodedGroupName);
                    } catch (e) {
                      groupName = encodedGroupName;
                    }
                    return GroupDocumentsPage(groupName: groupName);
                  },
                ),
                GoRoute(
                  name: 'group_important_messages',
                  path: AppRoutes.groupImportantMessagesRoute,
                  builder: (ctx, state) {
                    final encodedGroupName = state.pathParameters['groupName'] ?? 'Groupe';
                    String groupName;
                    try {
                      groupName = Uri.decodeComponent(encodedGroupName);
                    } catch (e) {
                      groupName = encodedGroupName;
                    }
                    return GroupImportantMessagesPage(groupName: groupName);
                  },
                ),
              ],
            ),
            GoRoute(
              name: 'create_group',
              path: AppRoutes.createGroup,
              builder: (ctx, state) => const CreateGroupScreen(),
            ),
          ],
        ),
        // Profile Route
        GoRoute(
          name: 'profile',
          path: AppRoutes.profileRoute,
          builder: (ctx, state) {
            final username = state.pathParameters['username'] ?? '';
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final displayName = extra['displayName'] as String? ?? username;
            return AnotherProfilePage(
              username: username,
              displayName: displayName,
            );
          },
        ),
        GoRoute(
          name: 'create_channel',
          path: AppRoutes.createChannel,
          builder: (ctx, state) => const CreateChannelScreen(),
        ),
        GoRoute(
          name: 'settings',
          path: AppRoutes.settingsSheetRoute,
          builder: (ctx, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return SettingsSheetPage(
              userId: extra['userId'] as String? ?? '',
              username: extra['username'] as String? ?? 'Utilisateur',
            );
          },
        ),
      ],
    );
  }
}
