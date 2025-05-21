import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/_custom_button.dart';
import '../../../../core/widgets/_custom_textfield.dart';
import '../../controllers/_register_controller.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
    required this.registerController,
    required this.theme,
  });

  final RegisterController registerController;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Create an account',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        CustomTextfield(
          width: 300,
          height: 50,
          isPassword: false,
          prefixIcon: Icons.person,
          hintText: "Enter your full name",
          labelText: "Name",
          controller: registerController.nameController,
        ),
        const SizedBox(height: 15),
        CustomTextfield(
          width: 300,
          height: 50,
          isPassword: false,
          prefixIcon: Icons.email,
          hintText: "Enter your email",
          labelText: "Email",
          controller: registerController.emailController,
        ),
        const SizedBox(height: 15),
        CustomTextfield(
          width: 300,
          height: 50,
          isPassword: true,
          prefixIcon: Icons.lock,
          hintText: "Enter your password",
          labelText: "Password",
          controller: registerController.passwordController,
        ),
        const SizedBox(height: 20),
        Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme.onSurface.withOpacity(.15),
                  width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 300,
            height: 60,
            child: Center(
              child: DropdownButtonFormField<String>(
                elevation: 0,
                focusColor: Colors.transparent,
                value:
                    registerController.selectedRole.value.isNotEmpty
                        ? registerController.selectedRole.value
                        : null, // Prevents null error
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Register as",
                  labelStyle: TextStyle(color: theme.primary),
                ),
                items: registerController.roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    registerController.selectedRole.value =
                        newValue;
                  }
                },
                isExpanded: true, // Prevents overflow issues
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        CustomButton(
          text: "Register",
          onPressed: () {
            registerController.register(context);
          },
          width: 300,
          height: 50,
        )
      ],
    );
  }
}
