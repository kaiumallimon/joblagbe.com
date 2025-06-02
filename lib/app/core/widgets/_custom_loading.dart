import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/main.dart';

Future<void> customDialog(
  String title,
  String message,
) async {
  final context = navigatorKey.currentContext;
  if (context != null && context.mounted) {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shadowColor: AppColors.black.withOpacity(.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: title == 'Error' ? Colors.red : AppColors.darkPrimary,
              ),
        ),
        content: SelectableText(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ).frosted(
        blur: 15,
        borderRadius: BorderRadius.circular(10),
        frostColor: AppColors.white.withOpacity(.1),
        frostOpacity: .5,
      ),
    );
  }
}

Future<void> showCustomLoadingDialog() async {
  final context = navigatorKey.currentContext;
  if (context == null || !context.mounted) return;

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(.2),
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.darkPrimary,
            ),
          ),
        ),
      ).frosted(
        blur: 15,
        borderRadius: BorderRadius.circular(10),
        frostColor: AppColors.white.withOpacity(.1),
        frostOpacity: .5,
      );
    },
  );
}

Future<void> closeCustomLoadingDialog() async {
  final context = navigatorKey.currentContext;
  if (context != null && context.mounted) {
    Navigator.of(context).pop();
  }
}

Future<void> showConfirmationDialog(
  String message,
  VoidCallback onConfirm,
) async {
  final context = navigatorKey.currentContext;
  if (context != null && context.mounted) {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shadowColor: AppColors.black.withOpacity(.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Confirmation',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkPrimary,
              ),
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(
              'Confirm',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ).frosted(
        blur: 15,
        borderRadius: BorderRadius.circular(10),
        frostColor: AppColors.white.withOpacity(.1),
        frostOpacity: .5,
      ),
    );
  }
}
