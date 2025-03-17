import 'package:flutter/material.dart';

class RecruiterDashboard extends StatelessWidget {
  const RecruiterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruiter Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Recruiter Dashboard!',
        ),
      ),
    );
  }
}