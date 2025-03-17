import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onButtonPressed,
    required this.buttonColor,
  });

  final String title;
  final String content;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Prevents overflow
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              content,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: buttonText,
              onPressed: onButtonPressed,
              color: buttonColor,
              height: 40,
              fontSize: 14,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText,
  required VoidCallback onButtonPressed,
  required Color buttonColor,
}) {
  showDialog(
    context: context,
    builder: (context) => CustomDialog(
      title: title,
      content: content,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      buttonColor: buttonColor,
    ),
    barrierDismissible: false,
  );
}
