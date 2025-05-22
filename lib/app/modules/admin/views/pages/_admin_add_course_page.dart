import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/core/widgets/_custom_textfield.dart';
import 'package:joblagbe/app/core/widgets/_dashboard_appbar.dart';
import 'package:joblagbe/app/modules/admin/controllers/_admin_add_course_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:joblagbe/app/data/models/_job_category_model.dart';

class AdminAddCourse extends StatelessWidget {
  const AdminAddCourse({super.key});

  @override
  Widget build(BuildContext context) {
    final addCourseController = Get.put(AdminAddCourseController());
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: dashboardAppbar('Add Course'),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: DynMouseScroll(builder: (context, controller, physics) {
          return SingleChildScrollView(
            controller: controller,
            physics: physics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'To add a course, you need to add a title, description, and thumbnail url and select a category then add corresponding lessons to the course.'),
                SizedBox(height: 20.0),
                Text(
                  'Course Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 20.0),
                CustomTextfield(
                    width: double.infinity,
                    height: 50,
                    isPassword: false,
                    controller: addCourseController.titleController,
                    hintText: 'Title',
                    labelText: 'Course Title',
                    prefixIcon: Icons.title),
                const SizedBox(height: 15.0),
                CustomDescriptionField(
                  width: double.infinity,
                  height: 200,
                  controller: addCourseController.descriptionController,
                  hintText: 'Description',
                  labelText: 'Course Description',
                  prefixIcon: Icons.description,
                ),
                const SizedBox(height: 15.0),
                CustomTextfield(
                    width: double.infinity,
                    height: 50,
                    isPassword: false,
                    controller: addCourseController.thumbnailUrlController,
                    hintText: 'Thumbnail URL',
                    labelText: 'Course Thumbnail URL',
                    prefixIcon: Icons.link),
                const SizedBox(height: 15.0),
                CustomTextfield(
                    width: double.infinity,
                    height: 50,
                    isPassword: false,
                    controller: addCourseController.tagsController,
                    hintText: 'Tags',
                    labelText: 'Course Tags',
                    prefixIcon: Icons.tag),
                const SizedBox(height: 15.0),

                // category
                Obx(() {
                  if (addCourseController.isLoading.value) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.darkBackground.withOpacity(.2),
                            width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (addCourseController.categories.isEmpty) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.darkBackground.withOpacity(.2),
                            width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('No categories available'),
                      ),
                    );
                  }

                  return Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.darkBackground.withOpacity(.2),
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<JobCategory>(
                        value: addCourseController.selectedCategory.value,
                        isExpanded: true,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        hint: Text('Select Category'),
                        items: addCourseController.categories
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name),
                                ))
                            .toList(),
                        onChanged: (JobCategory? value) {
                          if (value != null) {
                            addCourseController.selectedCategory.value = value;
                          }
                        },
                      ),
                    ),
                  );
                }),

                SizedBox(height: 20.0),

                Obx(() => Column(
                      children: [
                        ...addCourseController.lessonControllers
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final lesson = entry.value;
                          return Column(
                            spacing: 15,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lesson ${index + 1}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () =>
                                        addCourseController.removeLesson(index),
                                  ),
                                ],
                              ),
                              CustomTextfield(
                                width: double.infinity,
                                height: 50,
                                isPassword: false,
                                controller: lesson[0],
                                hintText: 'Lesson Title',
                                labelText: 'Lesson Title',
                                prefixIcon: Icons.title,
                              ),
                              CustomDescriptionField(
                                width: double.infinity,
                                height: 150,
                                controller: lesson[1],
                                hintText: 'Lesson Description',
                                labelText: 'Lesson Description',
                                prefixIcon: Icons.description,
                              ),
                              CustomTextfield(
                                width: double.infinity,
                                height: 50,
                                isPassword: false,
                                controller: lesson[2],
                                hintText: 'Lesson Video URL',
                                labelText: 'Lesson Video URL',
                                prefixIcon: Icons.link,
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 20,
                          children: [
                            CustomButton(
                              color: AppColors.secondary,
                              textColor: AppColors.black,
                              text: 'Add new lesson',
                              onPressed: () => addCourseController.addLesson(),
                            ),
                            SizedBox(width: 10),
                            Obx(() {
                              return CustomButton(
                                text: 'Create Course',
                                isLoading:
                                    addCourseController.isCreatingCourse.value,
                                onPressed: () async =>
                                    await addCourseController.createCourse(),
                              );
                            }),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}
