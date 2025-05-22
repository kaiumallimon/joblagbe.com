import 'package:flutter/material.dart';

import '../theming/colors/_colors.dart';

AppBar dashboardAppbar(String title) {
  return AppBar(
    // toolbarHeight: 100,
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
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(1.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.darkPrimary.withOpacity(0.1),
              width: 1.0,
            ),
          ),
        ),
      ),
    ),
  );
}
