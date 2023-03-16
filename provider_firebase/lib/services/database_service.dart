import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference<Map<String, dynamic>> get tasksReference =>
      FirebaseFirestore.instance.collection('tasks');

  Stream<QuerySnapshot<Map<String, dynamic>>> userTasks(String userId) {
    return tasksReference.where('owner', isEqualTo: userId).snapshots();
  }

}
