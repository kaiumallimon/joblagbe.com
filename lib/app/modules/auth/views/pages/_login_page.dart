import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/_login_controller.dart';
import '../widgets/_login_page_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Center(
        child: SizedBox(
          width: Sizer.getDynamicWidth(context),
          child: Stack(
            // fit: StackFit.expand,
            children: [
              // background container
              Center(
                child: LottieBuilder.asset(
                  'assets/lottie/moving-circle.json',
                  repeat: true,
                  width: 700,
                  height: 750,
                  fit: BoxFit.cover,
                ),
              ),

              Center(
                child: LottieBuilder.asset(
                  'assets/lottie/moving-circle.json',
                  repeat: true,
                  width: 700,
                  height: 750,
                  fit: BoxFit.cover,
                ),
              ),

              // foreground container
              Center(
                child: Container(
                  width: 400,
                  height: 430,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 2,
                      )),
                  child: LoginForm(),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

