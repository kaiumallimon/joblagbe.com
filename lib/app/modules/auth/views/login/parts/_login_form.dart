import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theming/colors/_colors.dart';
import '../../../../../core/utils/_sizer.dart';
import '../../../../../core/widgets/_app_logo.dart';
import '../../../../../core/widgets/_custom_button.dart';
import '../../../../../core/widgets/_custom_textfield.dart';
import '../../../controllers/_login_controller.dart';
import '_forgot_pass.dart';
import '_register_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
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
              controller: Get.find<LoginController>().emailController,
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
              controller: Get.find<LoginController>().passwordController,
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
                  text: "Login",
                  width: 300,
                  onPressed: () {
                    Get.find<LoginController>().login(context);
                  })),

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
