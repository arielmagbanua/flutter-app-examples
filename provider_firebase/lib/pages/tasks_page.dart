import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_firebase/services/database_service.dart';
import 'package:provider_firebase/services/user_service.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () async {
              // sign out the user
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: databaseService.userTasks(userService.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // something went wrong therefore return a widget with an error message.
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.red),
              ),
            );
          }

          if (snapshot.hasData) {
            // create the list
            return _createTaskList(
              context,
              snapshot.data!.docs,
              databaseService.tasksReference,
            );
          }

          // display loading animation
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  /// Create the task list
  Widget _createTaskList(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> tasks,
    CollectionReference<Map<String, dynamic>> tasksReference,
  ) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        // get the task
        final task = tasks[index];
        final taskDoc = task.data();

        // get the deadline as timestamp
        final deadline = task['deadline'] as Timestamp;

        return Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // delete the doc
            tasksReference.doc(task.id).delete();

            // show a snack bar message to notify the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(task['title'] + ' is deleted!')),
            );
          },
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content:
                      const Text('Are you sure you wish to delete this task?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
          background: Container(color: Colors.red),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxListTile(
                key: ValueKey(task.id),
                subtitle: Text(
                  deadline.toDate().toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                title: Text(
                  task['title'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                value: taskDoc.containsKey('finished')
                    ? taskDoc['finished']
                    : false,
                onChanged: (bool? value) {
                  // prepare data update
                  var dataUpdate = <String, Object?>{'finished': value};

                  if (value!) {
                    // add finished_at date time
                    dataUpdate["finished_at"] = Timestamp.now();
                  } else {
                    // not yet done set it to null
                    dataUpdate["finished_at"] = null;
                  }

                  // update the task document
                  tasksReference.doc(task.id).set(
                        dataUpdate,
                        SetOptions(merge: true),
                      );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
