import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/my_card.dart';
import '../services/firestore_projects.dart';
import '../pages/project_form_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) =>
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProjectFormPage(pID: null)),
                );
              },
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.blue),
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getProjectsStream(),
          builder: (context, snapshot) {
            //  if we have data, get all the docs
            if (snapshot.hasData) {
              List projectsList = snapshot.data!.docs;

              int i = 1;
              //display as a list
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                    vertical: 50, horizontal: 50),
                itemCount: projectsList.length,
                itemBuilder: (context, index) {
                  //get each individual doc
                  DocumentSnapshot document = projectsList[index];
                  String docID = document.id;

                  //get note from each doc
                  Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
                  String projectTitle = data['title'];
                  Timestamp date = data['date'];
                  int progress = data['progress'];


                  if(i>3) i=1;
                  //display as list title
                  return Column(
                    children: [
                      MyCard(
                        i: i++,
                        text: projectTitle,
                        dueDate: date.toDate().toString().split(' ')[0],
                        progress: progress,
                        docID: docID,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                },
              );
            }

            // if there is no data, return nothing
            else {
              return const Center(child: Text("No hay proyectos..."));
            }
          },
        ),
      ),
    );
  }
}
