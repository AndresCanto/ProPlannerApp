import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/projects_page.dart';
import '../pages/settings_page.dart';
import '../pages/tasks_page.dart';

class FramePage extends StatefulWidget {
  const FramePage({super.key});

  @override
  State<FramePage> createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final List _pages = [
    //const HomePage(),
    const ProjectsPage(),
    TasksPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        // Esto asegura que todos los ítems se muestren de manera correcta
        items: const <BottomNavigationBarItem>[
          /*BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tareas',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajsutes',
          ),
        ],
      ),
    );
  }
}
