import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/app/app.dart';
import 'package:yansnet/app/router/auth_change_notifier.dart';
import 'package:yansnet/app/router/routes.dart';
import 'package:yansnet/app/view/app_nav_page.dart';
import 'package:yansnet/authentication/cubit/authentication_cubit.dart';
import 'package:yansnet/authentication/cubit/auth_state.dart';
import 'package:yansnet/authentication/views/login_page.dart';
import 'package:yansnet/authentication/views/register_page.dart';
import 'package:yansnet/counter/view/counter_page.dart';
import 'package:yansnet/conversation/views/messages_list_page.dart';
import 'package:yansnet/conversation/views/chat_conversation_page.dart';
import 'package:yansnet/conversation/views/group_chat_page.dart';
import 'package:yansnet/conversation/views/group_info_page.dart';
import 'package:yansnet/conversation/views/messages_empty_page.dart';
import 'package:yansnet/conversation/views/messages_no_connection_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthenticationCubit authCubit) {
    final authNotifier = AuthChangeNotifier(authCubit);
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      // initialLocation: AppRoutes.authLoginRoute,
      initialLocation: AppRoutes.homeRoute,
      refreshListenable: authNotifier,
      redirect: (context, state) {
        // final authState = authNotifier.state;
        // final isAuthRoute = state.matchedLocation.startsWith('/auth');
        //
        // // Si l'utilisateur est connecté et essaie d'accéder aux pages d'auth
        // if (authState is UserFetched && isAuthRoute) {
        //   return AppRoutes.homeRoute;
        // }
        //
        // // Si l'utilisateur n'est pas connecté et essaie d'accéder aux pages protégées
        // if (authState is! UserFetched && !isAuthRoute && authState is! AuthLoading) {
        //   return AppRoutes.authLoginRoute;
        // }
        //
        // // Si l'utilisateur est déconnecté
        // if (authState is Logout) {
        //   return AppRoutes.authLoginRoute;
        // }
        
        return null;
      },
      routes: [
        GoRoute(
          name: "home",
          path: AppRoutes.homeRoute,
          builder: (ctx, state) => const ApppNavigationPage(),
        ),
        GoRoute(
          name: "splash",
          path: AppRoutes.splashRoute,
          builder: (ctx, state) => const SplashPage()
        ),
        GoRoute(
          name: "register",
          path: AppRoutes.authRegisterRoute,
          builder: (ctx, state) => const RegisterPage(),
        ),
        GoRoute(
          name: "login",
          path: AppRoutes.authLoginRoute,
          builder: (ctx, state) => const LoginPage(),
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

        // Group routess
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