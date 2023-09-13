import 'package:flutter/material.dart';
import 'package:myhome/states/auth.dart';
import 'package:myhome/routes/router.dart';
import 'package:myhome/routes/route_utils.dart';

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
            var loggedIn =
                await AuthState.of(context).login(usernameOrEmail, password);
            if (loggedIn) {
              AppRouter.router.go(PAGES.home.screenPath);
            } else {
              // TODO: show error
            }
          },
        ),
      ),
    );
  }
}
