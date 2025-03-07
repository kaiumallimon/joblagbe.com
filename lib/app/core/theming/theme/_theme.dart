import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';

class AppTheme {
  static ThemeData theme() => ThemeData(
      fontFamily: 'Jost',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary));
}
