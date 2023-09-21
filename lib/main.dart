import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (_) => Api.load(),
      initialData: null,
      child: Consumer<Api?>(
        builder: (context, api, child) {
          if (api == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return FutureProvider(
            initialData: null,
            create: (_) => AuthState.load(api),
            child: Consumer<AuthState?>(
              builder: (context, authState, child) {
                if (authState == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return MaterialApp.router(
                  routerConfig: AppRouter.router,
                  title: 'Our home',
                  debugShowCheckedModeBanner: false,
                  // theme: ThemeData(
                  //   primarySwatch: Colors.blue,
                  //   scaffoldBackgroundColor: Colors.grey.shade200,
                  // ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
