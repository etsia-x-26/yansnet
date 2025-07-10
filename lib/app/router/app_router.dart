import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/app/router/routes.dart';
import 'package:yansnet/app/view/app_nav_page.dart';
import 'package:yansnet/app/view/splash_page.dart';
import 'package:yansnet/conversation/views/messages_list_page.dart';
import 'package:yansnet/conversation/views/chat_conversation_page.dart';
import 'package:yansnet/conversation/views/group_chat_page.dart';
import 'package:yansnet/conversation/views/group_info_page.dart';
import 'package:yansnet/conversation/views/messages_empty_page.dart';
import 'package:yansnet/conversation/views/messages_no_connection_page.dart';
import 'package:yansnet/counter/view/counter_page.dart'; // Facultatif si tu l’utilises

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: '/group/X2026/info',
      redirect: (context, state) {
        return null; // Ajoute ici la redirection après login si besoin
      },
      routes: [
        GoRoute(
          name: "home",
          path: AppRoutes.homeRoute,
          builder: (ctx, state) => const AppNavigationPage(),
        ),
        GoRoute(
          name: "splash",
          path: AppRoutes.splashRoute,
          builder: (ctx, state) => const SplashPage(),
        ),
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
              builder: (ctx, state) => const MessagesNoConnectionPage(),
            ),
          ],
        ),
        GoRoute(
          name: "chat_conversation",
          path: "/chat/:userName",
          builder: (ctx, state) {
            final userName = state.pathParameters['userName'];
            if (userName == null) {
              return const Scaffold(body: Center(child: Text('Invalid user')));
            }
            return ChatConversationPage(
              userName: userName,
              userAvatar: 'https://i.pravatar.cc/150?img=1',
              lastSeen: '25/06/2025',
            );
          },
        ),
        GoRoute(
          name: "group_chat",
          path: "/group/:groupName",
          builder: (ctx, state) {
            final groupName = state.pathParameters['groupName'];
            if (groupName == null) {
              return const Scaffold(body: Center(child: Text('Invalid group')));
            }
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
                final groupName = state.pathParameters['groupName'];
                if (groupName == null) {
                  return const Scaffold(body: Center(child: Text('Invalid group')));
                }
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
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Page not found: ${state.error}')),
      ),
    );
  }
}
