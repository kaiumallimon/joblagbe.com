import 'package:flutter/material.dart';

import '../../../../../core/theming/colors/_colors.dart';

class RegisterButton extends StatefulWidget {
  const RegisterButton({super.key});

  @override
  State<RegisterButton> createState() => RegisterButtonState();
}

class RegisterButtonState extends State<RegisterButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 5),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) {
            setState(() {
              isHovered = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHovered = false;
            });
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isHovered ? 0.5 : 1,
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
