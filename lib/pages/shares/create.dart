import 'package:flutter/material.dart';
import '../../routes/router.dart';
import '../../routes/route_utils.dart';

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

            // TODO: redirect to share home
            AppRouter.router.go(PAGES.home.screenPath);
          },
        ),
      ),
    );
  }
}
