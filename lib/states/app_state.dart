import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/types/share.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  Api api;
  SharedPreferences prefs;
  Share? share;

  AppState({required this.api, required this.prefs});

  setShare(RecordModel? record) {
    if (record == null) {
      share = null;
      prefs.remove('lastOpenedShare');
    } else {
      share = Share.fromRecordModel(record);
      prefs.setString('lastOpenedShare', share!.id);
    }

    notifyListeners();
  }

  Future<Share> loadShare(String shareId) async {
    if (share != null && share!.id == shareId) {
      return share!;
    }

    if (share != null) {
      api.pb.collection('shares').unsubscribe(share!.id);
    }

    var response = await api.pb.collection('shares').getOne(shareId);
    setShare(response);

    api.pb.collection('shares').subscribe(shareId, (e) {
      setShare(e.record);
    });

    return share!;
  }

  @override
  void dispose() {
    // loginInfo.removeListener(loginChange);
    super.dispose();
  }

  static AppState of(BuildContext context) {
    var appState = context.read<AppState?>();
    if (appState == null) {
      throw Exception('AppState not found in context');
    }
    return appState;
  }
}
