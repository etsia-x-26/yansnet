import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/app/app.dart';
import 'package:yansnet/app/router/routes.dart';
import 'package:yansnet/app/view/app_nav_page.dart';
import 'package:yansnet/counter/view/counter_page.dart';
import 'package:yansnet/publication/views/create_post_page.dart';
import 'package:yansnet/publication/views/home.dart';
import 'package:yansnet/conversation/views/messages_list_page.dart';
import 'package:yansnet/conversation/views/chat_conversation_page.dart';
import 'package:yansnet/conversation/views/group_chat_page.dart';
import 'package:yansnet/conversation/views/group_info_page.dart';
import 'package:yansnet/conversation/views/messages_empty_page.dart';
import 'package:yansnet/conversation/views/messages_no_connection_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: '/home',
      redirect: (context, state) {
        // TODO: implement redirection through authentication status
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
          builder: (ctx, state) => const SplashPage()
        ),
        GoRoute(
          name: 'homePage',
          path: AppRoutes.splashRoute,
          builder: (ctx, state) => const Home()
        ),
        GoRoute(
          name: 'createPostPage',
          path: AppRoutes.createPostPageRoute,
          builder: (ctx, state) => const CreatePostPage()
        ),

        // Messages routes
        GoRoute(
          name: "messages_list",
          path: "/messages",
          builder: (ctx, state) => const MessagesListPage(),
          routes: [
            GoRoute(
              name: "empty_messages",
              path: "empty",
              builder: (ctx, state) => const MessagesEmptyPage(),
            ),
            GoRoute(
              name: "connection_error",
              path: "error",
              builder: (ctx, state) => MessagesNoConnectionPage(),
            ),
          ],
        ),

        // Chat routes
        GoRoute(
          name: "chat_conversation",
          path: "/chat/:userName",
          builder: (ctx, state) {
            final userName = state.pathParameters['userName'] ?? 'Utilisateur';
            return ChatConversationPage(
              userName: userName,
              userAvatar: 'https://i.pravatar.cc/150?img=1',
              lastSeen: '25/06/2025',
            );
          },
        ),

        // Group routes
        GoRoute(
          name: "group_chat",
          path: "/group/:groupName",
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
              name: "group_info",
              path: "info",
              builder: (ctx, state) {
                final groupName = state.pathParameters['groupName'] ?? 'Groupe';
                return GroupInfoPage(
                  groupName: groupName,
                  groupAvatar: 'https://i.pravatar.cc/150?img=10',
                  memberCount: 41,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}