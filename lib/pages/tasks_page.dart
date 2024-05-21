import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/components/my_task.dart';
import '../services/firestore_projects.dart';

class TasksPage extends StatelessWidget {
  TasksPage({super.key});

  // firestore
  final FirestoreService firestoreService = FirestoreService();

  Future<List<Map<String, dynamic>>> _getAllTasks() async {
    QuerySnapshot projectsSnapshot = await firestoreService.getProjectsStream().first;

    // Create a list of project data including the project ID and title
    List<Map<String, dynamic>> projects = projectsSnapshot.docs.map((doc) {
      return {
        'pID': doc.id,
        'ptitle': doc['title'],
      };
    }).toList();

    List<QuerySnapshot> taskSnapshots = await Future.wait(
      projectsSnapshot.docs.map((project) {
        String pID = project.id;
        return firestoreService.getTasksStream(pID: pID).first;
      }).toList(),
    );

    List<Map<String, dynamic>> allTasks = [];
    for (int i = 0; i < taskSnapshots.length; i++) {
      var snapshot = taskSnapshots[i];
      var project = projects[i];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> taskData = doc.data() as Map<String, dynamic>;
        taskData['pID'] = project['pID'];
        taskData['ptitle'] = project['ptitle']; // Add project title to the task data
        taskData['tID'] = doc.id; // Add task ID to the task data
        //taskData['date'] = taskData['date']; // Ensure date is added
        allTasks.add(taskData);
      }
    }

    allTasks.sort((a, b) {
      DateTime dateA = (a['date'] as Timestamp).toDate();
      DateTime dateB = (b['date'] as Timestamp).toDate();
      return dateA.compareTo(dateB);
    });

    return allTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: Text("Todas las tareas por fecha", style: TextStyle(fontSize: 26),)),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getAllTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay tareas..."));
          } else {
            List<Map<String, dynamic>> tasks = snapshot.data!;
            return GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> task = tasks[index];
                String tID = task['tID'];
                String pID = task['pID'];
                String title = task['title'];
                String ptitle = task['ptitle'];
                String status = task['status'];
                String tdate = task['date'].toDate().toString().split('.')[0].split(' ')[0];

                return MyTask(
                  text: title,
                  status: status,
                  pID: pID,
                  tID: tID, // You can modify this if you need tID
                  ptitle: ptitle, // You can modify this if you need ptitle
                  tdate: tdate,
                );
              },
            );
          }
        },
      ),
    );
  }
}
