import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/database_service.dart';
import '../services/user_service.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  // text input controllers for managing and controlling text inputs
  final _titleInputController = TextEditingController();
  final _descriptionInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                // one of the form field is invalid
                return;
              }

              // create the task object
              final task = <String, dynamic>{
                'title': _titleInputController.text,
                'description': _descriptionInputController.text,
                'finished': false,
                'owner': userService.currentUser!.uid,
              };

              // save the task
              await dbService.tasksReference.doc().set(task);

              // notify the task is added
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${_titleInputController.text} added')),
              );

              // close the add task page
              context.pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 16.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  helperText: 'The title of the task.',
                  border: OutlineInputBorder(),
                ),
                controller: _titleInputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // no title provided
                    return 'Please provide the title';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                minLines: 3,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  helperText: 'The description of the task.',
                  border: OutlineInputBorder(),
                ),
                controller: _descriptionInputController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
