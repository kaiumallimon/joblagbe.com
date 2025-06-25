import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';

class HeroSection3 extends StatelessWidget {
  const HeroSection3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Sizer.getDynamicWidth(context),
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text(
                      'Gather Talented\nIndividuals from Around the World in\nOne Place.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.white,
                        fontSize: Sizer.getFontSize(context) * 3,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Wrap(
                  children: [
                    Text(
                      'Our platform is designed to connect talented individuals from all corners of the globe, creating a diverse and dynamic community where innovation thrives. Join us in building a global network of talent, where ideas flow freely and opportunities abound. Together, we can shape the future of work and unlock the potential of a truly global workforce.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.white.withOpacity(.5),
                        fontSize: Sizer.getFontSize(context),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/landing_corporate.jpg',
                      width: Sizer.getDynamicWidth(context),
                      fit: BoxFit.cover,
                    ),
                    FrostedCircleButton()
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FrostedCircleButton extends StatefulWidget {
  const FrostedCircleButton({super.key});

  @override
  State<FrostedCircleButton> createState() => _FrostedCircleButtonState();
}

class _FrostedCircleButtonState extends State<FrostedCircleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.go('/login');
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isHovered
                        ? AppColors.primary
                        : Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: _isHovered
                      ? const Icon(
                          Icons.open_in_new,
                          key: ValueKey('icon'),
                          color: AppColors.darkPrimary,
                          size: 25,
                        )
                      : const Text(
                          'Explore',
                          key: ValueKey('text'),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
