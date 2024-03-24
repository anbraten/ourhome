import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/components/post/task/types.dart';
import 'package:ourhome/router.dart';
import 'package:ourhome/states/auth.dart';

class CreatePostTask extends StatefulWidget {
  final String shareId;
  const CreatePostTask({super.key, required this.shareId});

  @override
  State<CreatePostTask> createState() => _CreatePostTaskState();
}

class _CreatePostTaskState extends State<CreatePostTask> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final paidByController = TextEditingController();
  final paidForController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var authState = AuthState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Column(children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Message'),
                  controller: titleController,
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

                  TaskData taskData = TaskData(
                    assignedTo: authState.user!.id,
                    tasks: [
                      Task(
                        title: 'Task 1',
                        completed: false,
                      ),
                      Task(
                        title: 'Task 2',
                        completed: false,
                      ),
                      Task(
                        title: 'Task 3',
                        completed: false,
                      ),
                    ],
                  );

                  await Api.of(context).pb.collection('posts').create(body: {
                    'share': widget.shareId,
                    'author': authState.user?.id,
                    'type': 'task',
                    'data': taskData.toJson(),
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
