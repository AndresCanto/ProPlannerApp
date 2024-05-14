import 'package:flutter/material.dart';
import '../pages/project_form_page.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              // change to Tasks Form Page
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
          },
          child: const Icon(Icons.add, color: Colors.blue),
        ),
      ),
    );
  }
}