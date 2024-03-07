import 'package:flutter/material.dart';
import 'package:ourhome/routes/router.dart';

class CreateShareScreen extends StatelessWidget {
  const CreateShareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text(
            'Create share',
          ),
          onPressed: () {
            // TODO: create share

            // TODO: redirect to share pinboard
            AppRouter.router.go('/shares/q3wx3fdcvo8zw1q');
          },
        ),
      ),
    );
  }
}
