import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/core/widgets/_custom_textfield.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/admin/controllers/_admin_add_category_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class AdminAddCategoriesPage extends StatelessWidget {
  const AdminAddCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final addCategoryController = Get.put(AdminAddCategoryController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Add Categories'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DynMouseScroll(builder: (context, controller, physics) {
          return SingleChildScrollView(
            controller: controller,
            physics: physics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To add a new category, fill in the form below'),
                const SizedBox(height: 20),
                Text(
                  'Category Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  width: double.infinity,
                  height: 50,
                  isPassword: false,
                  controller: addCategoryController.nameController,
                  hintText: 'Category Title',
                  prefixIcon: Icons.title,
                  labelText: 'Category Title',
                ),
                const SizedBox(height: 15),
                CustomDescriptionField(
                  controller: addCategoryController.descriptionController,
                  hintText: 'Description (Optional)',
                  labelText: 'Description (Optional)',
                  prefixIcon: Icons.description,
                  height: 200,
                  width: double.infinity,
                ),
                const SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    width: 400,
                    text: 'Add Category',
                    onPressed: () => addCategoryController.addCategory(),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
