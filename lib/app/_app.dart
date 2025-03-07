import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/routes/_router.dart';
import 'package:joblagbe/app/core/theming/theme/_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'joblagbe',
      theme: AppTheme.theme(),
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
    );
  }
}