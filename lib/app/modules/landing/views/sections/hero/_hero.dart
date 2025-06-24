import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joblagbe/app/core/constants/_assets.dart';
import 'package:joblagbe/app/core/constants/_strings.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withOpacity(.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            width: Sizer.getDynamicWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                // stay connected
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(AppStrings.stayConnected,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.black,
                          fontSize: Sizer.getFontSize(context),
                          fontWeight: FontWeight.w500)),
                ),

                // unlock your potential
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Text(AppStrings.unlockPotential,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.black,
                                fontSize: Sizer.getFontSize(context) * 3,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 20,
                          children: [
                            Text(
                              AppStrings.heroDetails,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.black,
                                fontSize: Sizer.getFontSize(context),
                              ),
                              textAlign: TextAlign.start,
                            ),
                            CustomButton(
                                trailingIcon: Icon(
                                  CupertinoIcons.arrow_right,
                                  size: 20,
                                ),
                                borderRadius: 120,
                                text: 'Join now',
                                fontFamily: 'Poppins',
                                onPressed: () {
                                  context.go('/register');
                                }),
                          ],
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
