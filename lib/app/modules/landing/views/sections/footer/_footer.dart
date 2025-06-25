import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Sizer.getDynamicWidth(context),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SvgPicture.asset('assets/logo/Job-lagbe Logo.svg',
                //     width: 50, height: 50),
                // SizedBox(width: 10),
                Text(
                    '© ${DateTime.now().year} joblagbe.com All rights reserved.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.white,
                      fontSize: 16,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
