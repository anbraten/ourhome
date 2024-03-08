import 'package:flutter/material.dart';
import 'package:ourhome/helpers/post_types.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/states/auth.dart';

class CreateEntry extends StatefulWidget {
  final String shareId;
  const CreateEntry({super.key, required this.shareId});

  @override
  State<CreateEntry> createState() => _CreateEntryState();
}

Column _createExpenseForm(
    String shareId, _selectedPostType, Function resetPostType, context) {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final paidByController = TextEditingController();
  final paidForController = TextEditingController();

  return Column(
    children: [
      const Text(
        'Add a new Expense',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
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
      Row(
        children: [
          IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                resetPostType();
              }),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                // TODO: run action for specific postType
                var user = AuthState.of(context).user;
                await Api.of(context).pb.collection('posts').create(body: {
                  'type': 'expense',
                  'share': shareId,
                  'author': user?.id,
                  'data':
                      '{"title": "${titleController.text}", "date": "${DateTime.now().toIso8601String()}", "amount": ${amountController.text}, "currency": "${currencyController.text}", "paidBy": "${paidByController.text}", "paidFor": ["${paidForController.text}"]}',
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: Colors.teal,
              ),
              child: const Text('Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          )
        ],
      ),
    ],
  );
}

class _CreateEntryState extends State<CreateEntry> {
  String? _selectedPostType;
  String? selectedCurrency;

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]),
                if (_selectedPostType == null) ...[
                  const Text(
                    'Select post type',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust the number of items per row
                      childAspectRatio: 1.0, // Makes the items square
                    ),
                    itemCount: postTypes.length,
                    itemBuilder: (context, index) {
                      var e = postTypes[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.green[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(e['icon'], size: 50, color: Colors.black),
                              const SizedBox(height: 10),
                              Text(e['text'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 16),),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedPostType = e['text'];
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
                if (_selectedPostType == "Expense")
                  _createExpenseForm(widget.shareId, _selectedPostType, () {
                    setState(() {
                      _selectedPostType = null;
                    });
                  }, context),
              ],
            ),
          ),
        ),
      );
}
