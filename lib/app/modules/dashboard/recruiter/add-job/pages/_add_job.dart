import 'package:flutter/material.dart';

class AddJobPage extends StatelessWidget {
  const AddJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
      ),
      body: Center(
        child: const Text('Add Job Page Content'),
      ),
    );
  }
}