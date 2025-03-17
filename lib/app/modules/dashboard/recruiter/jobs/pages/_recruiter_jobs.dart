import 'package:flutter/material.dart';

class RecruiterJobsPage extends StatelessWidget {
  const RecruiterJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruiter Jobs'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Recruiter Jobs Page!',
        ),
      ),
    );
  }
}