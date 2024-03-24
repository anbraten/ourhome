import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/auth.dart';

class CreateShareScreen extends StatefulWidget {
  const CreateShareScreen({super.key});

  @override
  State<CreateShareScreen> createState() => _CreateShareState();
}

class _CreateShareState extends State<CreateShareScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Share'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name for the share';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Center(
                  child: ElevatedButton(
                    child: const Text(
                      'Create',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      try {
                        final resp = await Api.of(context)
                            .pb
                            .collection('shares')
                            .create(body: {
                          'name': nameController.text,
                          'members': [AuthState.of(context).user!.id],
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Share successfully created.')),
                        );

                        AppRouter.router.go("/shares/${resp.id}");
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
