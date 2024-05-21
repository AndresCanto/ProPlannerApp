import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //current logged un user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // get collection of projects
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // CREATE: add a new project
  Future<void> addProject(String project, String description, int progress, DateTime date) {
    return users.doc(currentUser!.email).collection('projects').add({
      'title': project,
      'description': description,
      'date': date,
      //'team': team,
      'progress': progress,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: get projects from database
  Stream<QuerySnapshot> getProjectsStream() {
    final projectsStream =
      users.doc(currentUser!.email).collection('projects').orderBy("timestamp", descending: true).snapshots();

    return projectsStream;
  }

  // READ: get a project from database
  Future<DocumentSnapshot<Map<String, dynamic>>> getProjectStream(String docID) {
    final projectStream =
    users.doc(currentUser!.email).collection('projects').doc(docID).get();

    return projectStream;
  }

  // UPDATE: update projects given a doc id
  Future<void> updateProject(String docID, String newProject, String description, int progress, DateTime date) {
    return users.doc(currentUser!.email).collection('projects').doc(docID).update({
      'title': newProject,
      'description': description,
      'date': date,
      //'team': team,
      'progress': progress,
      'timestamp':Timestamp.now(),
    });
  }

  // DELETE: delete projects given a doc id
  Future<void> deleteProject(String docID) {
    return users.doc(currentUser!.email).collection('projects').doc(docID).delete();
  }






  // CREATE: add a new task
  Future<void> addTask(String pID, String title, String description, String status, DateTime date) {
    return users.doc(currentUser!.email).collection('projects').doc(pID).collection('tasks').add({
      'title': title,
      'description': description,
      'date': date,
      //'team': team,
      'status': status,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: get tasks from a project
  Stream<QuerySnapshot> getTasksStream({required String pID}) {
    final tasksStream =
    users.doc(currentUser!.email).collection('projects').doc(pID).collection('tasks').orderBy("timestamp", descending: true).snapshots();

    return tasksStream;
  }

  // READ: get a task from database
  Future<DocumentSnapshot<Map<String, dynamic>>> getTaskStream(String pID, String tID) {
    final taskStream =
    users.doc(currentUser!.email).collection('projects').doc(pID).collection('tasks').doc(tID).get();

    return taskStream;
  }

  // UPDATE: update projects given a doc id
  Future<void> updateTask(String pID, String tID, String newTitle, String description, String status, DateTime date) {
    return users.doc(currentUser!.email).collection('projects').doc(pID).collection('tasks').doc(tID).update({
      'title': newTitle,
      'description': description,
      'date': date,
      //'team': team,
      'status': status,
      'timestamp':Timestamp.now(),
    });
  }

  // DELETE: delete projects given a doc id
  Future<void> deleteTask(String pID, String tID) {
    return users.doc(currentUser!.email).collection('projects').doc(pID).collection('tasks').doc(tID).delete();
  }
}