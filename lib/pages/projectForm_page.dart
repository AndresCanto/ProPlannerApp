import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/firestore.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController progressController = TextEditingController();

  late final String? docID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Cancelar',
              icon: Icon(
                Icons.cancel,
              )),
          BottomNavigationBarItem(
            label: "Guardar",
            icon: Icon(
              Icons.check_box,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: ListView(
            children: [
              const Text(
                "Nombre del proyecto",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "",
                obscureText: false,
                controller: titleController,
              ),
              const SizedBox(height: 25),
              const Text(
                "Descripción",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "",
                obscureText: false,
                controller: descriptionController,
              ),
              const SizedBox(height: 25),
              const Text(
                "Progreso actual (0-100)",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "",
                obscureText: false,
                controller: progressController,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: MyButton(
                  text: "Add",
                  onTap: () {
                    // add a new project
                    if (docID == null) {
                      firestoreService.addProject(
                          titleController.text, descriptionController.text, 0);
                    }
                    //update an existing note
                    else {
                      firestoreService.updateProject(docID!,
                          titleController.text, descriptionController.text, 0);
                    }

                    // clear the text controller
                    titleController.clear();
                    descriptionController.clear();
                    progressController.clear();

                    // close the box
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
