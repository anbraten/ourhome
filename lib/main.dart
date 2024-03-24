import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/common/theme.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/app_state.dart';
import 'package:ourhome/states/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      builder: (BuildContext c, __) {
        var api = c.read<Api?>();
        if (api == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return MultiProvider(
          providers: [
            FutureProvider(
              initialData: null,
              create: (_) => AuthState.load(api),
            ),
            FutureProvider(
              initialData: null,
              create: (_) async {
                var prefs = await SharedPreferences.getInstance();
                return AppState(api: api, prefs: prefs);
              },
            ),
          ],
          builder: (context, child) {
            var appState = context.read<AppState?>();
            var authState = context.read<AuthState?>();

            if (appState == null || authState == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return MaterialApp.router(
              routerConfig: AppRouter.router,
              title: 'Our home',
              debugShowCheckedModeBanner: false,
              theme: appTheme,
            );
          },
        );
      },
    );
  }
}
