import 'package:flutter/material.dart';

import '../theming/colors/_colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primary,
    this.textColor = AppColors.black,
    this.width = 200,
    this.height = 50,
    this.borderRadius = 8,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.isLoading = false,
    this.icon,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLoading;
  final Widget? icon;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
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
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isHovered ? widget.color.withOpacity(0.5) : widget.color,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Center(
            child: widget.isLoading
                ? CircularProgressIndicator(
                    color: widget.textColor,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) widget.icon!,
                      if (widget.icon != null) SizedBox(width: 8),
                      AnimatedDefaultTextStyle(
                        style: TextStyle(
                          color: isHovered
                              ? widget.textColor.withOpacity(0.5)
                              : widget.textColor,
                          fontSize: widget.fontSize,
                          fontWeight: widget.fontWeight,
                        ),
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          widget.text,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
