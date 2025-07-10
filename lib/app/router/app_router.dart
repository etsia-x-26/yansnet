import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:yansnet/app/app.dart';
import 'package:yansnet/app/router/routes.dart';
import 'package:yansnet/app/view/app_nav_page.dart';
import 'package:yansnet/counter/view/counter_page.dart';
import 'package:yansnet/feat_publication/views/create_post_page.dart';
import 'package:yansnet/feat_publication/views/home.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(){
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: AppRoutes.homeRoute,
      redirect: (context, state){
        //TODO (camcoder):implement redirection throught authentication status
        return null;
      },
      //TODO(camcoder): consume the auth bloc provider later !!!
      // refreshListenable: ,
      routes: [
        GoRoute(
          name: 'home',
          path: AppRoutes.homeRoute,
          builder: (ctx, state) => const ApppNavigationPage()
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
        )
      ]
    );
  }

}