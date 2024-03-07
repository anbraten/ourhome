import 'package:flutter/widgets.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:ourhome/api.dart';

class AuthState {
  RecordAuth? _user;
  RecordModel? get user => _user?.record;
  bool get isSignedIn => _user != null;
  Api _api;

  AuthState({RecordAuth? user, required Api api})
      : _user = user,
        _api = api;

  static AuthState of(BuildContext context) {
    var authState = context.read<AuthState?>();
    if (authState == null) {
      throw Exception('AuthState not found in context');
    }
    return authState;
  }

  static Future<AuthState> load(Api api) async {
    if (api.pb.authStore.isValid) {
      var user = await api.pb.collection('users').authRefresh();
      return AuthState(user: user, api: api);
    }

    return Future.value(AuthState(api: api));
  }

  Future<bool> login(String email, String password) async {
    _user = await _api.pb.collection('users').authWithPassword(email, password);

    return true;
  }

  Future<bool> logout() async {
    _api.pb.authStore.clear();
    _user = null;
    return true;
  }

  Future<void> register(String email, name, password) async {
    await _api.pb.collection('users').create(body: {
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirm': password,
    });

    await _api.pb.collection('users').requestVerification(email);
  }
}
