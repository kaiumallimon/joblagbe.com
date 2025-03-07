import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/constants/_assets.dart';
import '../../../../../../core/constants/_strings.dart';
import '../../../../../../core/theming/colors/_colors.dart';
import '../../../../../../core/utils/_sizer.dart';

class Hero2LeftQuote extends StatelessWidget {
  const Hero2LeftQuote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: SizedBox(
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              AppAssets.quote,
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 10),
            Text(AppStrings.quote1,
                style: TextStyle(
                  fontSize: Sizer.getFontSize(context),
                  color: AppColors.black,
                )),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 40,
                ),
                Text(AppStrings.quote1Author,
                    style: TextStyle(
                      fontSize: Sizer.getFontSize(context),
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

