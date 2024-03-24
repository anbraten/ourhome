import 'package:flutter/material.dart';
import 'package:ourhome/types/post.dart';

class PostType {
  final String type;
  final IconData icon;
  final Color color;
  final String text;
  final Widget Function(Post post)? createCard;
  final Widget Function({required String shareId, required Key key})?
      createForm;

  PostType({
    required this.type,
    required this.icon,
    required this.color,
    required this.text,
    this.createCard,
    this.createForm,
  });
}
