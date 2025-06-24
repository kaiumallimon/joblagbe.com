import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';

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
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'Explore',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppColors.black,
                            fontSize: Sizer.getFontSize(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ).frosted(
                          blur: 10.0,
                          frostColor: AppColors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
