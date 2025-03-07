import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/modules/landing/controllers/_scroll_controller.dart';
import '../../../../../core/widgets/_app_logo.dart';
import '../../../../../core/widgets/_custom_button.dart';
import '../../../controllers/_header_controller.dart';
import 'parts/_menu.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final headerController = Get.put(HeaderController());
    final scrollController = Get.put(ScrollControllerX());

    return Obx(() {
      return ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: scrollController.progress.value != 0 ? 10 : 0,
              sigmaY: scrollController.progress.value != 0 ? 10 : 0),
          child: AnimatedContainer(
            height: 80,
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: scrollController.progress.value != 0
                  ? Colors.black.withOpacity(0.05)
                  : AppColors.primary.withOpacity(0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Sizer.getDynamicWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // logo
                      AppLogo(onTap: () {
                        GoRouter.of(context).push('/');
                      }),

                      // menu
                      HeaderMenu(headerController: headerController),

                      // login
                      CustomButton(
                        text: 'Login',
                        onPressed: () {},
                        borderRadius: 120,
                        width: 120,
                        height: 45,
                        leadingIcon: Icon(
                          Icons.account_circle_outlined,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
