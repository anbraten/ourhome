import 'package:flutter/material.dart';
import 'package:ourhome/routes/route_utils.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/auth.dart';

class PinboardScreen extends StatelessWidget {
  const PinboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () async {
              await AuthState.of(context).logout();
              AppRouter.router.go(PAGES.login.screenPath);
            },
            child: const Text(
              'Logout',
            ),
          ),
        ),
        floatingActionButton: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        ));
  }
}
