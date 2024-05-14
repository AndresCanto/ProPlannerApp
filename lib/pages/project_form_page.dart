import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/firestore_projects.dart';

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
              const SizedBox(height: 40),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: MyButton(
                      text: "Add",
                      onTap: () {
                        // add a new project
                        firestoreService.addProject(
                            titleController.text,
                            descriptionController.text,
                            int.parse(progressController.text));

                        // clear the text controller
                        titleController.clear();
                        descriptionController.clear();
                        progressController.clear();

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
                        progressController.clear();
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
