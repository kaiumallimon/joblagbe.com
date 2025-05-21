import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/controllers/_recruiter_add_job_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../../../../../core/theming/colors/_colors.dart';
import '../../../../../core/widgets/_mcq_textfield.dart';

class AddJobPage2 extends StatelessWidget {
  const AddJobPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final addjobController = Get.put(AddJobController());

    return DynMouseScroll(builder: (context, controller, physics) {
      return ListView(
        controller: controller,
        physics: physics,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        children: [
          Row(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    addjobController.selectedPage.value = 1;
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
              Text(
                'Add MCQs for the Job',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black.withOpacity(.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: addjobController.mcqList.length,
                itemBuilder: (context, index) {
                  final mcq = addjobController.mcqList[index];
                  return Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Field
                          MCQTextfield(
                            controller: mcq.questionController,
                            hintText: 'Question No. ${index + 1}',
                          ),
                          SizedBox(height: 10),

                          // Options Fields
                          Row(
                            spacing: 10,
                            children: List.generate(4, (optionIndex) {
                              return Expanded(
                                child: MCQTextfield(
                                  controller:
                                      mcq.optionControllers[optionIndex],
                                  hintText: 'Option ${optionIndex + 1}',
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: 10),

                          // Correct Answer Dropdown
                          Obx(() => Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColors.black.withOpacity(.15),
                                      width: 2), // Blue border
                                ),
                                child: DropdownButton<int>(
                                  value: mcq.correctOption.value,
                                  items: List.generate(4, (i) {
                                    return DropdownMenuItem<int>(
                                      value: i,
                                      child: Text(
                                        'Option ${i + 1}',
                                      ),
                                    );
                                  }),
                                  onChanged: (val) {
                                    mcq.correctOption.value = val!;
                                  },
                                  underline:
                                      SizedBox(), // Removes default underline
                                  icon: Icon(
                                      Icons.arrow_drop_down), // Custom icon
                                  dropdownColor: Colors
                                      .white, // Background color of dropdown
                                ),
                              )),

                          // Remove Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  addjobController.removeMCQ(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),

          // buttons to add and clear MCQs with pass mark

          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pass Mark Textfield
              Obx(() => addjobController.mcqList.isNotEmpty
                  ? Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 15,
                          children: [
                            Text(
                              'Pass Mark: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Obx(() => MCQTextfield(
                                  width: 100,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (val) {
                                    int? newVal = int.tryParse(val);
                                    if (newVal != null &&
                                        newVal <=
                                            addjobController.mcqList.length) {
                                      addjobController.passMark.value = newVal;
                                    } else if (newVal != null) {
                                      addjobController.passMark.value =
                                          addjobController.mcqList.length;
                                    }
                                  },
                                  controller: TextEditingController(
                                    text: addjobController.passMark.value
                                        .toString(),
                                  ),
                                )),
                            Obx(() => Text(
                                '/ ${addjobController.mcqList.length}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    )
                  : SizedBox()),

              // Add MCQ Button
              Expanded(
                child: CustomButton(
                  height: 60,
                  text: 'Add MCQ',
                  onPressed: addjobController.addMCQ,
                  color: AppColors.secondary,
                  textColor: AppColors.black,
                ),
              ),

              // Clear All Button
              Expanded(
                child: CustomButton(
                  height: 60,
                  text: 'Clear All',
                  onPressed: addjobController.clearAllMCQ,
                  color: Colors.red,
                  textColor: AppColors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          // Post Job Button
          Obx(() {
            if (addjobController.mcqList.isEmpty) {
              return SizedBox.shrink();
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                  flex: 1,
                  child: Obx(() {
                    return CustomButton(
                      height: 60,
                      isLoading: addjobController.isLoading.value,
                      text: 'Post This Job',
                      onPressed: () {
                        addjobController.postJob(context);
                      },
                      color: AppColors.primary,
                      textColor: AppColors.black,
                    );
                  }),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox.shrink(),
                ),
              ],
            );
          }),
        ],
      );
    });
  }
}
