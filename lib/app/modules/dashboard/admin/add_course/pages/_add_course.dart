import 'package:flutter/material.dart';

class AdminAddCourse extends StatelessWidget {
  const AdminAddCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
      ),
      body: const Center(
        child: Text('Add Course'),
      ),
    );
  }
}
