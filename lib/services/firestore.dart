import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  // get collection of projects
  final CollectionReference projects = FirebaseFirestore.instance.collection('projects');
  // CREATE: add a new project
  Future<void> addProject(String project, String description, int progress) {
    return projects.add({
      'title': project,
      'description': description,
      //'date': date,
      //'team': team,
      'progress': progress,
      'timestamp': Timestamp.now(),
    });
  }
  // READ: get projects from database
  Stream<QuerySnapshot> getProjectsStream() {
    final projectsStream =
      projects.orderBy("timestamp", descending: true).snapshots();

    return projectsStream;
  }

  // UPDATE: update projects given a doc id
  Future<void> updateProject(String docID, String newProject, String description, int progress) {
    return projects.doc(docID).update({
      'title': newProject,
      'description': description,
      //'date': date,
      //'team': team,
      'progress': progress,
      'timestamp':Timestamp.now(),
    });
  }

  // DELETE: delete projects given a doc id
  Future<void> deleteProject(String docID) {
    return projects.doc(docID).delete();
  }
}