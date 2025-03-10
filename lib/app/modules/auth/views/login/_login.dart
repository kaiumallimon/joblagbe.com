import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/core/widgets/_app_logo.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/widgets/_custom_textfield.dart';
import '../../controllers/_login_controller.dart';
import 'parts/_forgot_pass.dart';
import 'parts/_register_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  height: 475,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 2,
                      )),
                  child: Column(
                    children: [
                      LoginContainer(),
                      Expanded(
                        child: Obx(() {
                          int selectedLoginClient = Get.find<LoginController>()
                              .selectedLoginClient
                              .value;
                          return selectedLoginClient == 0
                              ? ApplicantLoginForm()
                              : RecruiterLoginForm();
                        }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

class ApplicantLoginForm extends StatelessWidget {
  const ApplicantLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // logo
          Center(child: AppLogo(onTap: () {})),

          // title
          Center(
            child: Text(
              'Login to your account',
              style: TextStyle(
                fontSize: Sizer.desktopRegularFontSize,
                fontWeight: FontWeight.normal,
                color: AppColors.darkPrimary,
              ),
            ),
          ),

          SizedBox(height: 20),

          // email textfield
          Center(
            child: CustomTextfield(
              hintText: 'Email',
              labelText: 'Email',
              prefixIcon: Icons.email_outlined,
              width: 300,
              height: 50,
              isPassword: false,
            ),
          ),

          SizedBox(height: 10),

          // password textfield
          Center(
            child: CustomTextfield(
              hintText: 'Password',
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
              width: 300,
              height: 50,
              isPassword: true,
            ),
          ),

          SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ForgotPassword(),
            ),
          ),

          SizedBox(height: 10),

          // login button
          Center(
              child: CustomButton(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  height: 45,
                  text: "Login as an applicant",
                  width: 300,
                  onPressed: () {})),

          SizedBox(height: 15),

          // register button
          Center(
            child: RegisterButton(),
          ),
        ],
      ),
    );
  }
}

class RecruiterLoginForm extends StatelessWidget {
  const RecruiterLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // logo
          Center(child: AppLogo(onTap: () {})),

          // title
          Center(
            child: Text(
              'Login to your account',
              style: TextStyle(
                fontSize: Sizer.desktopRegularFontSize,
                fontWeight: FontWeight.normal,
                color: AppColors.darkPrimary,
              ),
            ),
          ),

          SizedBox(height: 20),

          // email textfield
          Center(
            child: CustomTextfield(
              hintText: 'Email',
              labelText: 'Email',
              prefixIcon: Icons.email_outlined,
              width: 300,
              height: 50,
              isPassword: false,
            ),
          ),

          SizedBox(height: 10),

          // password textfield
          Center(
            child: CustomTextfield(
              hintText: 'Password',
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
              width: 300,
              height: 50,
              isPassword: true,
            ),
          ),

          SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ForgotPassword(),
            ),
          ),

          SizedBox(height: 10),

          // login button
          Center(
              child: CustomButton(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  height: 45,
                  text: "Login as a recruiter",
                  width: 300,
                  onPressed: () {})),

          SizedBox(height: 15),

          // register button
          Center(
            child: RegisterButton(),
          ),
        ],
      ),
    );
  }
}

class LoginContainer extends StatelessWidget {
  const LoginContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(
      LoginController(),
    );

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: SizedBox(
        width: 400,
        height: 50,
        child: Row(
          children: [
            Expanded(
                child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  controller.selectedLoginClient.value = 0;
                },
                child: Obx(() {
                  int selectedLoginClient =
                      controller.selectedLoginClient.value;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: selectedLoginClient == 0
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: selectedLoginClient == 0
                            ? Radius.circular(20)
                            : Radius.zero,
                        bottomRight: selectedLoginClient == 0
                            ? Radius.circular(20)
                            : Radius.zero,
                      ),
                    ),
                    child: Center(
                      child: Text('Applicant',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: AppColors.black,
                          )),
                    ),
                  );
                }),
              ),
            )),
            Expanded(
                child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  controller.selectedLoginClient.value = 1;
                },
                child: Obx(() {
                  int selectedLoginClient =
                      controller.selectedLoginClient.value;
                  return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          color: selectedLoginClient == 1
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: selectedLoginClient == 1
                                ? Radius.circular(20)
                                : Radius.zero,
                            bottomLeft: selectedLoginClient == 1
                                ? Radius.circular(20)
                                : Radius.zero,
                          )),
                      child: Center(
                          child: Text('Recruiter',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: AppColors.black,
                              ))));
                }),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
