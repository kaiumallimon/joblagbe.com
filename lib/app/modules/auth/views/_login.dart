import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/core/widgets/_app_logo.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:lottie/lottie.dart';

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
                  height: 400,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 2,
                      )),
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
                              text: "Login",
                              width: 300,
                              onPressed: () {})),

                      // SizedBox(height: 15),

                      // Center(
                      //   child: RecruiterLogin(),
                      // ),
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

// class RecruiterLogin extends StatelessWidget {
//   const RecruiterLogin({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Text('Login as Recruiter',
//         style: TextStyle(
//           fontSize: 15,
//           color: AppColors.darkPrimary,
//           fontWeight: FontWeight.w500,
//         ));
//   }
// }

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: isHovered ? 0.5 : 1,
        child: GestureDetector(
          onTap: () {},
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              // decoration: TextDecoration.underline,
              // decorationColor: Colors.red,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      required this.width,
      required this.height,
      required this.isPassword,
      this.keyboardType,
      this.controller,
      this.onChanged});

  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final double width;
  final double height;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: AppColors.darkPrimary.withOpacity(.2), width: 2),
          ),
        ),
      ),
    );
  }
}
