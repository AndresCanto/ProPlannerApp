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
        child: Column(
          children: [
            // recent projects
            Expanded(
              child: SizedBox(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getProjectsStream(),
                  builder: (context, snapshot) {
                    //  if we have data, get all the docs
                    if (snapshot.hasData) {
                      List projectsList = snapshot.data!.docs;
                
                      int i = 1;
                      int iCount = 0;

                      if (projectsList.isEmpty) iCount = projectsList.length;
                      if (projectsList.isNotEmpty) iCount = 1;
                      //display as a list
                      return ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                        itemCount: iCount,
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
            ),
            const SizedBox(height: 40),
            // recent tasks
            Expanded(
              child: SizedBox(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getProjectsStream(),
                  builder: (context, snapshot) {
                    //  if we have data, get all the docs
                    if (snapshot.hasData) {
                      List projectsList = snapshot.data!.docs;

                      int i = 1;
                      int iC = 0;

                      if (projectsList.isEmpty) iC = projectsList.length;
                      if (projectsList.isNotEmpty) iC = 2;

                      //display as a list
                      return ListView.builder(
                        padding:
                        const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                        itemCount: iC,
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
                          return Column(
                            children: [
                              Text(projectTitle),
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
            ),
          ],
        ),
      ),
    );
  }
}
