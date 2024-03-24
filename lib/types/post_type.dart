import 'package:flutter/material.dart';

class PostType {
  final String type;
  final IconData icon;
  final Color color;
  final String text;

  PostType({
    required this.type,
    // required this.card,
    required this.icon,
    required this.color,
    required this.text,
  });
}

List<PostType> postTypes = [
  PostType(
    type: "expense",
    icon: Icons.currency_exchange,
    color: Colors.purple[200]!,
    text: "Expense",
  ),
  PostType(
    type: "task",
    icon: Icons.task,
    color: Colors.blue[200]!,
    text: "Task",
  ),
  PostType(
    type: "note",
    icon: Icons.note,
    color: Colors.red[200]!,
    text: "Note",
  ),
  PostType(
    type: "poll",
    icon: Icons.poll,
    color: Colors.cyan[200]!,
    text: "Poll",
  ),
  PostType(
    type: "image",
    icon: Icons.image,
    color: Colors.orange[200]!,
    text: "Image",
  ),
  PostType(
    type: "shopping_list",
    icon: Icons.shopping_cart,
    color: Colors.teal[200]!,
    text: "Shopping list",
  ),
];
