import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/pages/task_form_page.dart';
import '../components/my_card.dart';
import '../services/firestore_projects.dart';
import 'package:flutter/material.dart';

class ProjectPage extends StatelessWidget {
  final String docID;
  final int i;

  ProjectPage({super.key, required this.docID, required this.i});

  // firestore
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskFormPage(docID: docID),
              ),
            );
          },
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.blue),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Image.asset(
            'lib/images/project$i.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: const Center(
                  child: Text(
                "Detalles de proyecto",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              )),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 30,
                  ),
                  onPressed: () {
                    // Acción al presionar el icono
                  },
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: firestoreService.getProjectStream(docID),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Documento no encontrado'));
              }
              var data = snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 210),
                    Text(
                      data['title'],
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      data['description'],
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 212, 212, .5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(
                            data['timestamp'].toDate().toString().split('.')[0],
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(
                            '${data['progress']}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(
                          height: 10,
                          width: 420,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 10,
                          width: 4.2 * data['progress'],
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    //Text(docID),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestoreService.getTasksStream(pID:docID),
                      builder: (context, snapshot) {
                        //  if we have data, get all the docs
                        if (snapshot.hasData) {
                          List projectsList = snapshot.data!.docs;

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
                              String title = data['title'];
                              String description = data['description'];
                              String status = data['status'];
                              Timestamp date = data['timestamp'];

                              //display as list title
                              return Column(
                                children: [
                                  Text(projectsList.length.toString()),
                                  Text(title),
                                  Text(date.toDate().toString().split(' ')[0]),
                                  Text(status),
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
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
