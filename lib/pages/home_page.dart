import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_projects.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/components/my_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  onTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        // recent projects
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getProjectsStream(),
          builder: (context, snapshot) {
            //  if we have data, get all the docs
            if (snapshot.hasData) {
              List projectsList = snapshot.data!.docs;

              int i = 1;
              //display as a list
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                itemCount: 1,
                itemBuilder: (context, index) {
                  //get each individual doc
                  DocumentSnapshot document = projectsList[index];
                  String docID = document.id;

                  //get note from each doc
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String projectTitle = data['title'];
                  Timestamp date = data['timestamp'];
                  int progress = data['progress'];

                  if (i > 3) i = 1;
                  //display as list title
                  return MyCard(
                    i: i++,
                    text: projectTitle,
                    dueDate: date.toDate().toString().split(' ')[0],
                    progress: progress,
                    docID: docID,
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

        // recent tasks

      ),
    );
  }
}
