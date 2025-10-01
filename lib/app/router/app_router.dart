import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/app/app.dart';
import 'package:yansnet/app/router/routes.dart';
import 'package:yansnet/app/view/app_nav_page.dart';
import 'package:yansnet/conversation/views/chat_conversation_page.dart';
import 'package:yansnet/conversation/views/group_chat_page.dart';
import 'package:yansnet/conversation/views/group_info_page.dart';
import 'package:yansnet/conversation/views/messages_empty_page.dart';
import 'package:yansnet/conversation/views/messages_list_page.dart';
import 'package:yansnet/conversation/views/messages_no_connection_page.dart';
import 'package:yansnet/profile/view/sheet_parametre_profile.dart';
import 'package:yansnet/publication/views/create_post_page.dart';
import 'package:yansnet/subscription/views/another_profile_screen.dart';
import 'package:yansnet/subscription/views/create_channel_screen.dart';
import 'package:yansnet/subscription/views/create_group_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: '/',
      redirect: (context, state) {
        return null;
      },
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
          path: AppRoutes.groupChatRoute,
          builder: (ctx, state) {
            final groupName = state.pathParameters['groupName'] ?? 'Groupe';
            return GroupChatPage(
              groupName: groupName,
              groupAvatar: 'https://i.pravatar.cc/150?img=10',
              memberCount: 41,
            );
          },
          routes: [
            GoRoute(
              name: 'group_info',
              path: AppRoutes.groupInfoRoute,
              builder: (ctx, state) {
                final groupName = state.pathParameters['groupName'] ?? 'Groupe';
                return GroupInfoPage(
                  groupName: groupName,
                  groupAvatar: 'https://i.pravatar.cc/150?img=10',
                  memberCount: 41,
                );
              },
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
