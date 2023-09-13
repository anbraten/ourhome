import 'package:flutter/widgets.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:myhome/api.dart';

class AuthState {
  RecordAuth? _user;
  get isSignedIn => _user != null;

  AuthState({RecordAuth? user}) : _user = user;

  static AuthState of(BuildContext context) {
    return context.read<AuthState>();
  }

  static Future<AuthState> load() async {
    if (pb.authStore.isValid) {
      var user = await pb.collection('users').authRefresh();
      return AuthState(user: user);
    }
    return Future.value(AuthState());
  }

  Future<bool> login(String email, String password) async {
    _user = await pb.collection('users').authWithPassword(email, password);

    return true;
  }

  Future<bool> register(String email, name, password) async {
    await pb.collection('users').create(body: {
      name: name,
      email: email,
      password: password,
    });

    return login(email, password);
  }
}
