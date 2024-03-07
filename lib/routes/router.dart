import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ourhome/pages/auth/register.dart';
import 'package:ourhome/pages/not_found.dart';
import 'package:ourhome/pages/auth/login.dart';
import 'package:ourhome/pages/shares/create.dart';
import 'package:ourhome/pages/shares/%5BsharesId%5D/finances.dart';
import 'package:ourhome/pages/shares/index.dart';
import 'package:ourhome/pages/shares/%5BsharesId%5D/settings/index.dart';
import 'package:ourhome/pages/shares/%5BsharesId%5D/index.dart';
import 'package:ourhome/states/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      bool isSignedIn = AuthState.of(context).isSignedIn;

      if (state.fullPath == null) {
        return null;
      }

      if (!isSignedIn && !state.fullPath!.startsWith('/auth')) {
        return '/auth/login';
      }

      if (isSignedIn && state.fullPath!.startsWith('/auth')) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
          path: '/',
          redirect: (_, __) async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            final lastOpenedShare = prefs.getString('lastOpenedShare');
            if (lastOpenedShare != null) {
              return '/shares/$lastOpenedShare';
            }

            return '/shares';
          }),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
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
            builder: (context, state) => const CreateShareScreen(),
          ),
          GoRoute(
              path: ':shareId',
              builder: (context, state) =>
                  ShareScreen(shareId: state.pathParameters['shareId']!),
              routes: [
                GoRoute(
                  path: 'finances',
                  builder: (context, state) => ShareFinancesScreen(
                      shareId: state.pathParameters['shareId']!),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => ShareSettingsScreen(
                      shareId: state.pathParameters['shareId']!),
                ),
              ]),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  static GoRouter get router => _router;
}
