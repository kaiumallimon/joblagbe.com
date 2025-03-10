import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
        duration: Duration(milliseconds: 300),
        opacity: isHovered ? 0.5 : 1,
        child: GestureDetector(
          onTap: () {},
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              // decoration: TextDecoration.underline,
              // decorationColor: Colors.red,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

