import 'package:flutter/material.dart';
import 'package:ourhome/components/expense/card.dart';
import 'package:ourhome/components/note/card.dart';
import 'package:ourhome/states/app_state.dart';
import 'package:ourhome/types/post.dart';

class PinboardCard extends StatelessWidget {
  final Post post;

  const PinboardCard({Key? key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.type == 'expense') {
      return ExpenseCard.fromPost(post);
    }

    if (post.type == 'note') {
      return NoteCard.fromPost(post);
    }

    var appState = AppState.of(context);
    var author = appState.shareMembers
        ?.firstWhere((element) => element.id == post.authorId);

    return Card(
      child: ListTile(
        textColor: Colors.white,
        title: Text('${post.type} by ${author?.name ?? '---'} ${post.id}'),
        subtitle: Text(post.data.toString()),
      ),
    );
  }
}
