import 'package:flutter/material.dart';
import 'package:ourhome/components/pinboard_cards/card.dart';

class PostType {
  final String type;
  final PinboardCard card;
  final IconData icon;
  final Color color;
  final String text;

  PostType({
    required this.type,
    required this.card,
    required this.icon,
    required this.color,
    required this.text,
  });
}
