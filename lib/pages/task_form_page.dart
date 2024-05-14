import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/firestore_projects.dart';

class TaskFormPage extends StatefulWidget {
  final String docID;

  TaskFormPage({super.key, required this.docID});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  //final TextEditingController dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: ListView(
            children: [
              const Text(
                "Nombre de la tarea",
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
                "Estatus",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "",
                obscureText: false,
                controller: statusController,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: MyButton(
                      text: "Add",
                      onTap: () {
                        // add a new project
                        firestoreService.addTask(
                            widget.docID,
                            titleController.text,
                            descriptionController.text,
                            statusController.text,
                        );

                        // clear the text controller
                        titleController.clear();
                        descriptionController.clear();
                        statusController.clear();

                        // close the box
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyButton(
                      text: "Canecel",
                      onTap: () {
                        titleController.clear();
                        descriptionController.clear();
                        statusController.clear();
                        //dueDateController.clear();

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
