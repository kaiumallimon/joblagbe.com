import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    this.leadingIcon,
    this.trailingIcon,
    this.fontFamily = 'Inter',
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
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final String fontFamily;

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
            boxShadow: [
              BoxShadow(
                color: widget.textColor.withOpacity(0.2),
                blurRadius: 30,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? LoadingAnimationWidget.twoRotatingArc(
                    color: AppColors.white,
                    size: 20,
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.leadingIcon != null) widget.leadingIcon!,
                      if (widget.leadingIcon != null) SizedBox(width: 8),
                      AnimatedDefaultTextStyle(
                        style: TextStyle(
                            color: isHovered
                                ? widget.textColor.withOpacity(0.5)
                                : widget.textColor,
                            fontSize: widget.fontSize,
                            fontWeight: widget.fontWeight,
                            fontFamily: widget.fontFamily),
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          widget.text,
                        ),
                      ),
                      if (widget.trailingIcon != null) SizedBox(width: 8),
                      if (widget.trailingIcon != null) widget.trailingIcon!,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
