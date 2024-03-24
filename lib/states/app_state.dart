import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/types/share.dart';
import 'package:ourhome/types/user.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  Api api;
  SharedPreferences prefs;
  Share? share;
  List<User>? shareMembers;

  AppState({required this.api, required this.prefs});

  setShare(RecordModel? record) {
    if (record == null) {
      share = null;
      prefs.remove('lastOpenedShare');
    } else {}
  }

  Future<Share> loadShare(String shareId) async {
    if (share != null && share!.id == shareId) {
      return share!;
    }

    if (share != null) {
      api.pb.collection('shares').unsubscribe(share!.id);
    }

    var response = await api.pb.collection('shares').getOne(shareId);
    var _share = Share.fromRecordModel(response);
    shareMembers = (await Future.wait(
            _share.members.map((e) => api.pb.collection("users").getOne(e))))
        .map((e) => User.fromRecordModel(e))
        .toList();

    prefs.setString('lastOpenedShare', _share.id);
    share = _share;

    notifyListeners();

    return share!;
  }

  static AppState of(BuildContext context) {
    var appState = context.read<AppState?>();
    if (appState == null) {
      throw Exception('AppState not found in context');
    }
    return appState;
  }
}
