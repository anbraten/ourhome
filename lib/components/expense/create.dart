import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/components/expense/types.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/app_state.dart';
import 'package:ourhome/states/auth.dart';
import 'package:ourhome/types/user.dart';

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
    var authState = AuthState.of(context);

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
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<Currency>(
                  decoration: const InputDecoration(labelText: 'Currency'),
                  items: currencies
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  value: currencies.first,
                  onChanged: (value) {
                    currencyController.text = value!.code;
                  },
                ),
                DropdownButtonFormField<User>(
                  decoration: const InputDecoration(labelText: 'Paid by'),
                  items: (appState.shareMembers ?? [])
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  value: appState.shareMembers?.firstWhere(
                      (element) => element.id == authState.user?.id),
                  onChanged: (value) {
                    paidByController.text = value!.id;
                  },
                ),
                DropdownMenu<User>(
                  label: const Text('Paid for'),
                  expandedInsets: const EdgeInsets.symmetric(vertical: 5.0),
                  controller: paidForController,
                  inputDecorationTheme: const InputDecorationTheme(
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  dropdownMenuEntries: (appState.shareMembers ?? [])
                      .map((e) => DropdownMenuEntry(
                            value: e,
                            label: e.name,
                          ))
                      .toList(),
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

                  ExpenseData expenseData = ExpenseData(
                    title: titleController.text,
                    date: DateTime.now(),
                    currency: currencyController.text,
                    paidBy: [],
                    paidFor: [],
                  );

                  await Api.of(context).pb.collection('posts').create(body: {
                    'share': widget.shareId,
                    'author': authState.user?.id,
                    'type': 'expense',
                    'data': expenseData.toJson(),
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
