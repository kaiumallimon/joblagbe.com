import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/constants/_assets.dart';
import '../../../../../../core/constants/_strings.dart';
import '../../../../../../core/theming/colors/_colors.dart';
import '../../../../../../core/utils/_sizer.dart';

class Hero2RightQuote extends StatelessWidget {
  const Hero2RightQuote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: SizedBox(
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              width: 200,
              AppAssets.star,
            ),
            Text(AppStrings.quote2Title,
                style: TextStyle(
                  fontSize: Sizer.getFontSize(context) * 1.5,
                  color: AppColors.black,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            Text(AppStrings.quote1,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: Sizer.getFontSize(context),
                  color: AppColors.black,
                )),
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 5,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(AppStrings.quote2Author,
                        style: TextStyle(
                          fontSize: Sizer.getFontSize(context),
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(AppStrings.quote2AuthorPosition,
                        style: TextStyle(
                          fontSize: Sizer.getFontSize(context),
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
                Icon(
                  Icons.account_circle,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
