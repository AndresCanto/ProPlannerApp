import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  // get collection of projects
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
  // CREATE: add a new project
  Future<void> addTask(String task, String description, String author, int progress ) {
    return tasks.add({
      'title': task,
      'description': description,
      //'date': date,
      //'team': team,
      'autor': author,
      'progress': progress,
      'timestamp': Timestamp.now(),
    });
  }
  // READ: get projects from database
  Stream<QuerySnapshot> getTasksStream() {
    final tasksStream =
      tasks.orderBy("timestamp", descending: true).snapshots();

    return tasksStream;
  }

  // UPDATE: update projects given a doc id
  Future<void> updateTask(String docID, String newTask, String description, String author, int progress) {
    return tasks.doc(docID).update({
      'title': newTask,
      'description': description,
      //'date': date,
      //'team': team,
      'autor': author,
      'progress': progress,
      'timestamp':Timestamp.now(),
    });
  }

  // DELETE: delete projects given a doc id
  Future<void> deleteTask(String docID) {
    return tasks.doc(docID).delete();
  }
}