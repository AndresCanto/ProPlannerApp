import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/pages/task_form_page.dart';
import '../services/firestore_projects.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  final String pID;
  final String tID;
  final String titulo;

  TaskPage({
    super.key,
    required this.pID,
    required this.tID,
    required this.titulo,
  });

  // firestore
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Detalles de tarea",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
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
                        builder: (context) => TaskFormPage(
                          pID: pID,
                          tID: tID,
                        ),
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
                    firestoreService.deleteTask(pID, tID);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder(
          future: firestoreService.getTaskStream(pID, tID),
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*
                  ICON
                   */
                  const SizedBox(height: 28),
                  Icon(
                    Icons.list_alt,
                    size: 140,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  /*
                  TASK TITLE
                   */
                  const SizedBox(height: 28),
                  const Text("tarea"),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['title'],
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /*
                  PROJECT TITLE
                  */
                  const SizedBox(height: 24),
                  const Text("proyecto"),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /*
                  PROJECT DESCRIPTION
                   */

                  const SizedBox(height: 36),
                  const Text("descripción"),
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

                  /*
                  DUE DATE
                  */
                  const SizedBox(height: 36),
                  const Text("fecha limite"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 212, 212, .5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        child: Text(
                          data['date']
                              .toDate()
                              .toString()
                              .split('.')[0]
                              .split(' ')[0],
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /*
                  PROGRESS BAR
                  */
                  const SizedBox(height: 36),
                  const Text("Estatus"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        child: Text(
                          data['status'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
