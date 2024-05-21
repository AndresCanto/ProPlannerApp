import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../helper/helper_function.dart';
import '../services/firestore_projects.dart';

class ProjectFormPage extends StatefulWidget {
  final String? pID;

  const ProjectFormPage({super.key, required this.pID});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController progressController = TextEditingController();

  DateTime _dateTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: ListView(
            children: [
              const Text(
                "Formulario de proyecto",
                style: TextStyle(fontSize: 35),
              ),
              const SizedBox(height: 10),
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
              const Row(
                children: [
                  Text(
                    "Progreso actual",
                    style: TextStyle(fontSize: 22),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, top: 4),
                    child: Text(
                      "(0-100)",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "",
                obscureText: false,
                controller: progressController,
              ),
              const SizedBox(height: 25),
              const Text(
                "Fecha limite",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 150,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(
                        right: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _dateTime.toString().split(' ')[0],
                        style: const TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _showDatePicker,
                    child: const Icon(
                      Icons.calendar_month,
                      size: 52,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: MyButton(
                      text: "Aceptar",
                      onTap: () {
                        if (titleController.text.trim().isNotEmpty &&
                            descriptionController.text.trim().isNotEmpty &&
                            progressController.text.trim().isNotEmpty) {
                          try {
                            // add a new project
                            if (widget.pID == null) {
                              firestoreService.addProject(
                                titleController.text.trim(),
                                descriptionController.text.trim(),
                                int.parse(progressController.text.trim()),
                                _dateTime,
                              );
                            }
                            // update existing project
                            else {
                              firestoreService.updateProject(
                                widget.pID.toString(),
                                titleController.text.trim(),
                                descriptionController.text.trim(),
                                int.parse(progressController.text.trim()),
                                _dateTime
                              );
                              Navigator.pop(context);
                            }

                            // clear the text controller
                            /*
                              titleController.clear();
                              descriptionController.clear();
                              progressController.clear();
                            */

                            // close the box

                            Navigator.pop(context);
                          } catch (e) {
                            displayMessageToUser(
                                'Error en tipo de dato', context);
                          }
                        } else {
                          displayMessageToUser(
                              'Ningun campo puede estar vacío', context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyButton(
                      text: "Cancelar",
                      onTap: () {
                        titleController.clear();
                        descriptionController.clear();
                        progressController.clear();

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
