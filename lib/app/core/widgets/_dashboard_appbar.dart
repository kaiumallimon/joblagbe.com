import 'package:flutter/material.dart';

import '../theming/colors/_colors.dart';

AppBar dashboardAppbar(String title) {
  return AppBar(
    toolbarHeight: 100,
    backgroundColor: AppColors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    title: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.darkPrimary,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
