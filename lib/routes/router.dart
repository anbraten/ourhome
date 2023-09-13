import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myhome/routes/route_utils.dart';
import 'package:myhome/pages/not_found.dart';
import 'package:myhome/pages/home.dart';
import 'package:myhome/pages/auth/login.dart';
import 'package:myhome/states/auth.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      bool isSignedIn = AuthState.of(context).isSignedIn;

      if (!isSignedIn && state.fullPath != PAGES.login.screenPath) {
        return PAGES.login.screenPath;
      }

      if (isSignedIn && state.fullPath == PAGES.login.screenPath) {
        return PAGES.home.screenPath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: PAGES.home.screenPath,
        name: PAGES.home.screenName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: PAGES.login.screenPath,
        name: PAGES.login.screenName,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  static GoRouter get router => _router;
}
