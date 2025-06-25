import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';

class HeroSection6 extends StatelessWidget {
  const HeroSection6({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withOpacity(.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/logo/Job-lagbe Logo.svg',
                    width: 120, height: 120),
                Text('Find Your Ideal Job Among\nThousands of Opportunities',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.black,
                      fontSize: Sizer.getFontSize(context) * 2,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 30),
                CustomButton(
                  text: 'Try now',
                  fontFamily: 'Poppins',
                  onPressed: () {
                    context.go('/login');
                  },
                  borderRadius: 50,
                  height: 45,
                  width: 150,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
