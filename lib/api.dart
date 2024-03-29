import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final PocketBase _api;
  PocketBase get pb => _api;

  static const String url = 'https://ourhome.ju60.de';

  Api({required PocketBase api}) : _api = api;

  static Future<Api> load() async {
    final prefs = await SharedPreferences.getInstance();

    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    var api = PocketBase(url, authStore: store);
    return Api(api: api);
  }

  static Api of(BuildContext context) {
    var api = context.read<Api?>();
    if (api == null) {
      throw Exception('Api not found in context');
    }
    return api;
  }
}
