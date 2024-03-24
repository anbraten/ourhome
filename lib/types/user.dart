import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:pocketbase/pocketbase.dart';

class User {
  String id;
  String username;
  String email;
  String name;
  String? avatar;
  String? collectionId;
  String? paypalme;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    this.avatar,
    this.collectionId,
    this.paypalme,
  });

  get avatarUrl {
    if (avatar == null || avatar == "" || collectionId == null) {
      return null;
    }

    return "${Api.url}/api/files/$collectionId/$id/$avatar";
  }

  get avatarWidget {
    if (avatarUrl == null) {
      return const Icon(Icons.person, size: 50);
    }

    return Image.network(avatarUrl, width: 50, height: 50, fit: BoxFit.cover);
  }

  factory User.fromRecordModel(RecordModel model) {
    return User(
      id: model.id,
      username: model.getStringValue("username"),
      email: model.getStringValue("email"),
      name: model.getStringValue("name"),
      avatar: model.getStringValue("avatar"),
      paypalme: model.getStringValue("paypalme"),
      collectionId: model.collectionId,
    );
  }
}
