import 'package:flutter/material.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/auth.dart';

class AppBar extends StatelessWidget {
  const AppBar(
      {super.key,
      required Text title,
      required MaterialAccentColor backgroundColor,
      required List<IconButton> actions});

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Text('Our Home'),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthState.of(context).logout();
              AppRouter.router.go('/auth/login');
            },
          ),
        ],
      );
}