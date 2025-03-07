import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import '../../../../../core/widgets/_app_logo.dart';
import '../../../../../core/widgets/_custom_button.dart';
import '../../../controllers/_header_controller.dart';
import 'parts/_menu.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final headerController = Get.put(HeaderController());

    return SliverAppBar(
      floating: true,
      automaticallyImplyLeading: false,
      leading: null,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 100,
      flexibleSpace: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(.2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      borderRadius: 100,
                      width: 120,
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
