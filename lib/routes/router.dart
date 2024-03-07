import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ourhome/pages/not_found.dart';
import 'package:ourhome/pages/home.dart';
import 'package:ourhome/pages/auth/login.dart';
import 'package:ourhome/pages/shares/index.dart';
import 'package:ourhome/states/auth.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      bool isSignedIn = AuthState.of(context).isSignedIn;

      if (!isSignedIn && state.fullPath != '/auth/login') {
        return '/auth/login';
      }

      if (isSignedIn && state.fullPath == '/auth/login') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) async =>
            '/shares/q3wx3fdcvo8zw1q', // TODO: get user's last opened share
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/shares',
        builder: (context, state) => const SharesListScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const NotFoundScreen(),
          ),
          GoRoute(
            path: ':shareId',
            builder: (context, state) =>
                HomeScreen(shareId: state.pathParameters['shareId']!),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  static GoRouter get router => _router;
}
