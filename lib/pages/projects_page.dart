import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';
import '../pages/projectForm_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController progressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
          },
          child: const Icon(Icons.add, color: Colors.blue),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getProjectsStream(),
          builder: (context, snapshot) {
            //  if we have data, get all the docs
            if (snapshot.hasData) {
              List projectsList = snapshot.data!.docs;
        
              //display as a list
              return ListView.builder(
                itemCount: projectsList.length,
                itemBuilder: (context, index) {
                  //get each individual doc
                  DocumentSnapshot document = projectsList[index];
                  String docID = document.id;
        
                  //get note from each doc
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String projectTitle = data['title'];
                  String projectDescription = data['description'];
        
                  //display as list title
                  return ListTile(
        
                    title: Text(
                      projectTitle,
                      style: const TextStyle(fontSize: 30),
                    ),
                    subtitle: Text(
                      projectDescription,
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  );
                },
              );
            }
        
            // if there is no data, return nothing
            else {
              return const Text("No hay proyectos...");
            }
          },
        ),
      ),
    );
  }
}
