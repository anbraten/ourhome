import 'package:flutter/material.dart';
import 'package:ourhome/components/post/expense/card.dart';
import 'package:ourhome/components/post/expense/create.dart';
import 'package:ourhome/components/post/note/card.dart';
import 'package:ourhome/components/post/note/create.dart';
import 'package:ourhome/components/post/task/card.dart';
import 'package:ourhome/types/post.dart';
import 'package:ourhome/types/post_type.dart';

List<PostType> postTypes = [
  PostType(
    type: "expense",
    icon: Icons.currency_exchange,
    color: Colors.purple[200]!,
    text: "Expense",
    createCard: (Post post) => ExpenseCard.fromPost(post),
    createForm: ({required Key key, required String shareId}) =>
        CreatePostExpense(key: key, shareId: shareId),
  ),
  PostType(
    type: "task",
    icon: Icons.task,
    color: Colors.blue[200]!,
    text: "Task",
    createCard: (Post post) => TaskCard.fromPost(post),
    createForm: ({required Key key, required String shareId}) =>
        CreatePostExpense(key: key, shareId: shareId),
  ),
  PostType(
    type: "note",
    icon: Icons.note,
    color: Colors.red[200]!,
    text: "Note",
    createCard: (Post post) => NoteCard.fromPost(post),
    createForm: ({required Key key, required String shareId}) =>
        CreatePostNote(key: key, shareId: shareId),
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
