import 'package:flutter/material.dart';
import 'package:ourhome/routes/router.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not found'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              AppRouter.router.go('/');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Not found'),
      ),
    );
  }
}
