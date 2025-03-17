import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/_assets.dart';

class AppLogo extends StatefulWidget {
  const AppLogo({super.key, required this.onTap, this.color, this.path});
  final VoidCallback onTap;
  final Color? color;
  final String? path;

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> {
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
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: isHovered ? 0.5 : 1,
          child: SvgPicture.asset(
              widget.path != null ? widget.path! : AppAssets.logo,
              color: widget.color),
        ),
      ),
    );
  }
}
