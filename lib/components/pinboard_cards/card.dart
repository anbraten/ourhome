import 'package:flutter/material.dart';
import 'package:ourhome/components/expense/pinboard_card.dart';
import 'package:ourhome/types/post.dart';

class PinboardCard extends StatelessWidget {
  final Post post;

  const PinboardCard({Key? key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.type == 'expense') {
      return ExpenseCard.fromPost(post);
    }

    return Card(
      child: ListTile(
        textColor: Colors.white,
        title: Text('${post.type} by ${post.author} ${post.id}'),
        subtitle: Text(post.data.toString()),
      ),
    );
  }
}
