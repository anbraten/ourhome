import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/components/post/note/types.dart';
import 'package:ourhome/router.dart';
import 'package:ourhome/states/auth.dart';

class CreatePostNote extends StatefulWidget {
  final String shareId;
  const CreatePostNote({super.key, required this.shareId});

  @override
  State<CreatePostNote> createState() => _CreatePostNoteState();
}

class _CreatePostNoteState extends State<CreatePostNote> {
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
        title: const Text('Create Note'),
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

                  NoteData noteData = NoteData(
                    message: titleController.text,
                  );

                  await Api.of(context).pb.collection('posts').create(body: {
                    'share': widget.shareId,
                    'author': authState.user?.id,
                    'type': 'note',
                    'data': noteData.toJson(),
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
