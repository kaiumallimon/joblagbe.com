import 'package:flutter/material.dart';

class AdminManageCourses extends StatelessWidget {
  const AdminManageCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Courses'),
      ),
      body: const Center(
        child: Text('Manage Courses'),
      ),
    );
  }
}
