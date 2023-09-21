import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ourhome/routes/route_utils.dart';
import 'package:ourhome/pages/not_found.dart';
import 'package:ourhome/pages/home.dart';
import 'package:ourhome/pages/auth/login.dart';
import 'package:ourhome/states/auth.dart';

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
        return PAGES.pinboard.screenPath;
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (
          BuildContext context,
          GoRouterState state,
          Widget child,
        ) {
          if (state.fullPath == PAGES.login.screenPath) {
            return child;
          }

          return child;
        },
        routes: [
          GoRoute(
            path: PAGES.pinboard.screenPath,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: PAGES.login.screenPath,
            builder: (context, state) => const LoginScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  static GoRouter get router => _router;
}
