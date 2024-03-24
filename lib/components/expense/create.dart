import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/app_state.dart';
import 'package:ourhome/states/auth.dart';

class CreatePostExpenseScreen extends StatefulWidget {
  final String shareId;
  const CreatePostExpenseScreen({super.key, required this.shareId});

  @override
  State<CreatePostExpenseScreen> createState() => _CreatePostExpenseState();
}

class _CreatePostExpenseState extends State<CreatePostExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final paidByController = TextEditingController();
  final paidForController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = AppState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Expense'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Column(children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: titleController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  controller: amountController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Currency'),
                  controller: currencyController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Paid by'),
                  controller: paidByController,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Paid for'),
                  controller: paidForController,
                ),
              ]),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  // TODO: run action for specific postType
                  var user = AuthState.of(context).user;
                  await Api.of(context).pb.collection('posts').create(body: {
                    'type': 'expense',
                    'share': widget.shareId,
                    'author': user?.id,
                    'data':
                        '{"title": "${titleController.text}", "date": "${DateTime.now().toIso8601String()}", "amount": ${amountController.text}, "currency": "${currencyController.text}", "paidBy": "${paidByController.text}", "paidFor": ["${paidForController.text}"]}',
                  });
                  AppRouter.router.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
