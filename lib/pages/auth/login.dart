import 'package:flutter/material.dart';
import 'package:ourhome/states/auth.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/routes/route_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text(
            'Login',
          ),
          onPressed: () async {
            var usernameOrEmail = 'anton@ju60.de'; // TODO: get from form
            var password = '12345678'; // TODO: get from form

            try {
              await AuthState.of(context).login(usernameOrEmail, password);
              AppRouter.router.go(PAGES.pinboard.screenPath);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
              ));
            }
          },
        ),
      ),
    );
  }
}
