import 'package:flutter/material.dart';
import 'package:joblagbe/main.dart';

import '../theming/colors/_colors.dart';

AppBar dashboardAppbar(
  String title, {
  bool showBackButton = false,
  double? fontSize,
  List<Widget>? actions,
}) {
  return AppBar(
    // toolbarHeight: 100,
    leading: showBackButton
        ? IconButton(
            onPressed: () => navigatorKey.currentState!.pop(),
            icon: const Icon(Icons.arrow_back),
          )
        : null,
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
          fontSize: fontSize ?? 22,
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

    actions: actions ?? [],
  );
}
