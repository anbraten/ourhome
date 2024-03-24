import 'package:flutter/material.dart';
import 'package:ourhome/components/post/expense/types.dart';
import 'package:ourhome/components/post/types.dart';
import 'package:ourhome/types/post.dart';

class ExpenseCard extends StatelessWidget {
  final Post post;
  final ExpenseData expenseData;

  const ExpenseCard({super.key, required this.post, required this.expenseData});

  factory ExpenseCard.fromPost(Post post) {
    return ExpenseCard(
      post: post,
      expenseData: ExpenseData.fromJson(post.data),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currency = currencies
        .firstWhere((element) => element.code == expenseData.currency);
    return Card(
      color: postTypes.firstWhere((element) => element.type == post.type).color,
      child: ListTile(
        textColor: Colors.white,
        title: Text(
            '${expenseData.title} (${currency.amount(expenseData.paidBy.first.amount)})'),
        subtitle: Text(expenseData.paidBy.join(', ')),
      ),
    );
  }
}
