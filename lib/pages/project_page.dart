import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/components/my_task.dart';
import 'package:notes_app/pages/project_form_page.dart';
import 'package:notes_app/pages/task_form_page.dart';
import '../services/firestore_projects.dart';
import 'package:flutter/material.dart';

class ProjectPage extends StatelessWidget {
  final String pID;
  final int i;

  ProjectPage({super.key, required this.pID, required this.i});

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
                builder: (context) => TaskFormPage(pID: pID, tID: null),
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
            height: 90,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: PopupMenuButton(
                    offset: const Offset(32, 32),
                    child: const Icon(
                      Icons.more_vert,
                      size: 28,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectFormPage(pID: pID),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 4),
                            Text("Editar"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          firestoreService.deleteProject(pID);
                          Navigator.pop(context);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 4),
                            Text("Eliminar"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: firestoreService.getProjectStream(pID),
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
              String ptitle = data['title'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    /*
                    PROJECT TITLE
                     */
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ptitle,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    /*
                    PROJECT DESCRIPTION
                     */
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['description'],
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    /*
                    DUE DATE AND PROGRESS PORCENTAGE
                     */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*
                        DUE DATE
                        */
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 212, 212, .5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 24),
                          child: Text(
                            data['date'].toDate().toString().split('.')[0].split(' ')[0],
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        /*
                        PROGESS PORCENTAGE
                         */
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 16),
                          child: Text(
                            '${data['progress']}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /*
                     PROGRESS BAR
                     */
                    Stack(
                      children: [
                        Container(
                          height: 12,
                          width: 420,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 4.2 * data['progress'],
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: firestoreService.getTasksStream(pID: pID),
                        builder: (context, snapshot) {
                          //  if we have data, get all the docs
                          if (snapshot.hasData) {
                            List projectsList = snapshot.data!.docs;

                            //display as a list
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: projectsList.length,
                              itemBuilder: (context, index) {
                                //get each individual doc
                                DocumentSnapshot document = projectsList[index];
                                String tID = document.id;

                                //get task from each doc
                                Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                                String title = data['title'];
                                String status = data['status'];
                                String tdate = data['date'].toDate().toString().split('.')[0].split(' ')[0];

                                //display as list title
                                return MyTask(
                                  ptitle: ptitle,
                                  text: title,
                                  status: status,
                                  pID: pID,
                                  tID: tID,
                                  tdate: tdate,
                                );
                              },
                            );
                          }

                          // if there is no data, return nothing
                          else {
                            return const Center(
                                child: Text("No hay proyectos..."));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
