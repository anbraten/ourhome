import 'package:flutter/material.dart';
import 'package:ourhome/types/post_type.dart';
import 'package:ourhome/types/post.dart';

class AmountPerson {
  final String name;
  final double amount;

  AmountPerson({required this.name, required this.amount});

  factory AmountPerson.fromJson(Map<String, dynamic> json) {
    return AmountPerson(
      name: json['name'],
      amount: json['amount'],
    );
  }

  toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}

class Currency {
  final String code;
  final String name;

  Currency(this.code, this.name);

  amount(double amount) {
    if (name == 'EUR') {
      return "$amount €";
    }

    return "$amount $name";
  }
}

List<Currency> currencies = [
  Currency('EUR', '€ Euro'),
  Currency('USD', '\$ US Dollar'),
  Currency('GBP', '£ British Pound'),
];

class ExpenseData {
  final String title;
  final DateTime date;
  final String currency;
  final List<AmountPerson> paidBy;
  final List<AmountPerson> paidFor;

  ExpenseData({
    required this.title,
    required this.date,
    required this.currency,
    required this.paidBy,
    required this.paidFor,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      title: json['title'],
      date: DateTime.parse(json['date']),
      currency: json['currency'],
      paidBy: json['paidBy'].map((e) => AmountPerson.fromJson(e)).toList(),
      paidFor: json['paidFor'].map((e) => AmountPerson.fromJson(e)).toList(),
    );
  }

  toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'currency': currency,
      'paidBy': paidBy.map((e) => e.toJson()).toList(),
      'paidFor': paidFor.map((e) => e.toJson()).toList(),
    };
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
