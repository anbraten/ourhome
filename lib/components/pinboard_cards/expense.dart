import 'package:flutter/material.dart';
import 'package:ourhome/components/pinboard_cards/post.dart';
import 'package:ourhome/components/post_type.dart';

class ExpenseData {
  final String title;
  final int amount;
  final DateTime date;
  final String currency;
  final String paidBy;
  final List<String> paidFor;

  ExpenseData({
    required this.title,
    required this.amount,
    required this.date,
    required this.currency,
    required this.paidBy,
    required this.paidFor,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      currency: json['currency'],
      paidBy: json['paidBy'],
      paidFor: json['paidFor'].cast<String>(),
    );
  }
}

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

  _getMoneyString() {
    if (expenseData.currency == 'EUR') {
      return "${expenseData.amount}€";
    }

    return "${expenseData.amount} ${expenseData.currency}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${expenseData.title} (${_getMoneyString()})'),
        subtitle: Text(expenseData.paidBy),
      ),
    );
  }
}

// class Expense extends PostType {
//   Expense()
//       : super(
//           type: 'expense',
//           card: ExpenseCard.fromPost,
//           icon: Icons.attach_money,
//           color: Colors.greenAccent,
//           text: 'Expense',
//         );
// }
