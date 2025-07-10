import 'package:flutter/material.dart'; // Added for Scaffold
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/app/app.dart';
import 'package:yansnet/app/router/routes.dart';
import 'package:yansnet/counter/view/counter_page.dart';
import 'package:yansnet/conversation/views/messages_list_page.dart';
import 'package:yansnet/conversation/views/chat_conversation_page.dart';
import 'package:yansnet/conversation/views/group_chat_page.dart';
import 'package:yansnet/conversation/views/group_info_page.dart';
import 'package:yansnet/conversation/views/messages_empty_page.dart';
import 'package:yansnet/conversation/views/messages_no_connection_page.dart';
// Temporarily commented due to URI error
// import 'package:yansnet/app/view/app_nav_page.dart'; // Check and correct path

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true, // Set to false in production
      initialLocation: '/group/X2026/info',
      redirect: (context, state) {
        // TODO: Implement redirection through authentication status
        // Example: return !isAuthenticated ? '/login' : null;
        return null;
      },
      routes: [
        // Home route from master (placeholder until AppNavigationPage is confirmed)
        GoRoute(
          name: "home",
          path: AppRoutes.homeRoute,
          builder: (ctx, state) {
            // Placeholder until correct class is available
            return const Center(child: Text('Home Page'));
            // Uncomment and correct once AppNavigationPage is defined
            // return const AppNavigationPage(); // Correct typo if needed
          },
        ),
        // Splash route from master (placeholder until SplashPage is defined)
        GoRoute(
          name: "splash",
          path: AppRoutes.splashRoute,
          builder: (ctx, state) {
            // Placeholder until correct class is available
            return const Center(child: Text('Splash Page'));
            // Uncomment and correct once SplashPage is defined
            // return const SplashPage();
          },
        ),
        // Messages routes from feature/conversation
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
        // Chat routes from feature/conversation
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
        // Group routes from feature/conversation
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