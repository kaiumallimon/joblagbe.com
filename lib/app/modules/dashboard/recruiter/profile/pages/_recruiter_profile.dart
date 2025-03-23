import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/profile/controllers/_recruiter_profile_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../../../../../core/widgets/_dashboard_appbar.dart';

class RecruiterProfilePage extends StatelessWidget {
  const RecruiterProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecruiterProfileController());
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Profile & Settings'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          // top profile section
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 20,
                  children: [
                    // profile picture
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.darkPrimary),
                    ),

                    // name & email
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(
                            'Kaium Al Limon',
                            style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                height: 1.2),
                          ),
                          Text('kalimon291@gmail.com',
                              style: TextStyle(
                                color: AppColors.darkBackground,
                                fontSize: 16,
                              )),
                        ])
                  ],
                ),
                CustomButton(text: "Edit", onPressed: () {})
              ],
            ),
          ),

          // body section
          Expanded(
              child: DynMouseScroll(builder: (context, controller, physics) {
            return ListView(
              controller: controller,
              physics: physics,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: CustomProfileTextBox(
                        isEditable: false,
                        hintText: 'Enter your name',
                        label: 'Name',
                        text: 'Kaium Al Limon',
                      ),
                    ),
                    Expanded(
                      child: CustomProfileTextBox(
                        isEditable: false,
                        hintText: 'Enter your email',
                        label: 'Email',
                        text: 'kalimon291@gmail.com',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                        child: CustomGenderSelector(
                      isEditable: false,
                      hintText: 'Gender',
                    )),
                    Expanded(
                      child: CustomDobSelector(
                        isEditable: false,
                        hintText: 'Date of Birth',
                        initialDate: DateTime(2000, 1, 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: CustomProfileTextBox(
                        isEditable: false,
                        hintText: 'Enter your phone number',
                        label: 'Phone Number',
                        text: '+880 1234567890',
                      ),
                    ),
                    Expanded(
                      child: CustomProfileTextBox(
                        isEditable: false,
                        hintText: 'Enter your company name',
                        label: 'Company Name',
                        text: 'Google Inc.',
                      ),
                    ),
                  ],
                ),
              ],
            );
          }))
        ],
      ),
    );
  }
}

class CustomDobSelector extends StatelessWidget {
  const CustomDobSelector({
    super.key,
    required this.isEditable,
    required this.hintText,
    this.initialDate,
  });

  final bool isEditable;
  final String hintText;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    final RecruiterProfileController controller = Get.find();

    return Obx(() {
      return TextFormField(
        controller: TextEditingController(
          text: controller.selectedDob.value != null
              ? DateFormat('yyyy-MM-dd').format(controller.selectedDob.value!)
              : '',
        ),
        readOnly: true,
        onTap: isEditable
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDob.value ??
                      initialDate ??
                      DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  controller.selectedDob.value = pickedDate;
                }
              }
            : null,
        decoration: InputDecoration(
          labelText: hintText,
          filled: !isEditable,
          fillColor: isEditable
              ? Colors.transparent
              : AppColors.black.withOpacity(.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.black.withOpacity(.2), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: AppColors.black.withOpacity(.2), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle:
              TextStyle(color: isEditable ? AppColors.black : Colors.grey),
        ),
      );
    });
  }
}

class CustomGenderSelector extends StatelessWidget {
  const CustomGenderSelector({
    super.key,
    required this.isEditable,
    required this.hintText,
  });

  final bool isEditable;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final RecruiterProfileController controller = Get.find();

    return Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedGender.value,
          decoration: InputDecoration(
            labelText: hintText,
            filled: !isEditable,
            fillColor: isEditable
                ? Colors.transparent
                : AppColors.black.withOpacity(.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.black.withOpacity(.15), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.black.withOpacity(.15), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: isEditable ? AppColors.black.withOpacity(.5) : Colors.grey,
          ),
          isExpanded: true,
          onChanged: isEditable
              ? (String? newValue) {
                  if (newValue != null) {
                    controller.selectedGender.value = newValue;
                  }
                }
              : null, // Disables dropdown if not editable
          items: controller.genders.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(
                gender,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ));
  }
}

class CustomProfileTextBox extends StatelessWidget {
  const CustomProfileTextBox(
      {super.key,
      this.text,
      this.label,
      required this.isEditable,
      this.controller,
      this.height = 50,
      required this.hintText,
      this.width = double.infinity,
      this.keyboardType});

  final String? text;
  final String? label;
  final bool isEditable;
  final TextEditingController? controller;
  final double height;
  final double width;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        readOnly: !isEditable,
        initialValue: text,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            suffixIcon: text == null
                ? Icon(
                    Icons.error,
                    color: Colors.red,
                  )
                : null,
            labelText: label,
            filled: !isEditable,
            fillColor: AppColors.black.withOpacity(.05),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.black.withOpacity(.2), width: 2)),
            labelStyle:
                TextStyle(color: isEditable ? AppColors.black : Colors.grey),
            border: InputBorder.none),
      ),
    );
  }
}
