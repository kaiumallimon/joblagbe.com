import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joblagbe/app/core/constants/_assets.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';

import '../../../../../core/theming/colors/_colors.dart';
import 'parts/_hero2_left_quote.dart';
import 'parts/_hero2_right_quote.dart';

class HeroSection2 extends StatelessWidget {
  const HeroSection2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Sizer.getDynamicWidth(context),
            height: 600,
            child: Stack(
              children: [
                // shape
                Positioned(
                  bottom: 0,
                  left: (Sizer.getDynamicWidth(context) - 640) / 2,
                  child: Container(
                    width: 640,
                    height: 450,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(320),
                        topRight: Radius.circular(320),
                      ),
                    ),
                  ),
                ),

                // doodle
                Positioned(
                  bottom: 220,
                  left: (Sizer.getDynamicWidth(context) - 640) / 2.4,
                  child: SvgPicture.asset(AppAssets.doodle2,
                      width: 100, height: 200),
                ),

                // doodle right
                Positioned(
                  bottom: 120,
                  right: (Sizer.getDynamicWidth(context) - 640) / 2.1,
                  child: SvgPicture.asset(AppAssets.doodle3,
                      width: 100, height: 150),
                ),

                // doodle center
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(AppAssets.doodle1,
                      width: 100, height: 100),
                ),

                // person
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(
                    AppAssets.person,
                    width: 550,
                    height: 550,
                    fit: BoxFit.cover,
                  ),
                ),

                // quote left
                Hero2LeftQuote(),

                // quote right
                Hero2RightQuote()
              ],
            ),
          )
        ],
      ),
    );
  }
}
