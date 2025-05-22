import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dashboardAppbar('Admin Home'),
      body: const Center(
        child: Text('Admin Home'),
      ),
    );
  }
}