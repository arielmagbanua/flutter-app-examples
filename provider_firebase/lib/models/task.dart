import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String owner;
  final String title;
  final String? description;
  final bool finished;

  Task({
    required this.owner,
    required this.title,
    this.description,
    this.finished = false,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      owner: data['owner'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      finished: data['finished'] as bool,
    );
  }

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data as Map<String, dynamic>;

    return Task.fromMap(data);
  }
}

