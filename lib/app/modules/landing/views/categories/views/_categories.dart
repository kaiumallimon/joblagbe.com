import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/core/widgets/_custom_button.dart';
import 'package:joblagbe/app/modules/landing/controllers/_scroll_controller.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import '../../../controllers/_category_controller.dart';
import 'package:flutter/cupertino.dart';
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final scrollController = Get.put(ScrollControllerX());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: Sizer.getDynamicWidth(context),
          child: DynMouseScroll(builder: (context, controller, physics) {
            scrollController.attatchScrollController(controller);
            return CustomScrollView(
              controller: controller,
              physics: physics,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Icon(Icons.home, size: 20),
                        ...categoryController
                            .getFullPath(context)
                            .map((path) => Text(
                                  "/$path",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    "Available Categories",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Obx(() {
                  if (categoryController.isCategoryLoading.value) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  } else if (categoryController.categories.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "No categories found",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: categoryController.categories
                              .map((category) => MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        categoryController
                                            .setSelectedCategory(category.name);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.darkPrimary
                                                .withOpacity(.3),
                                            width: 2,
                                          ),
                                        ),
                                        child: Text(
                                          category.name,
                                          style: TextStyle(
                                            fontSize:
                                                Sizer.getFontSize(context),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList()),
                    );
                  }
                }),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Obx(() {
                  if (categoryController.isJobsLoading.value) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  } else if (categoryController
                      .selectedCategory.value.isEmpty) {
                    return SliverFillRemaining(
                      child: SizedBox.shrink(),
                    );
                  } else if (categoryController.jobs.isEmpty) {
                    return SliverFillRemaining(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                            text: "Available Jobs in ",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: categoryController.selectedCategory.value,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "No jobs found at the moment",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                          text: "Available Jobs in ",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: categoryController.selectedCategory.value,
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),

                        // jobs in grid 2 per row
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 160),
                          itemCount: categoryController.jobs.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.darkPrimary.withOpacity(.3),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoryController.jobs[index].company,
                                    style: TextStyle(
                                      fontSize: Sizer.getFontSize(context),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    categoryController.jobs[index].title,
                                    style: TextStyle(
                                        fontSize:
                                            Sizer.getFontSize(context) * 1.5,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        height: 1.2),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Deadline: ${categoryController.jobs[index].deadline.day}/${categoryController.jobs[index].deadline.month}/${categoryController.jobs[index].deadline.year}",
                                        style: TextStyle(
                                          fontSize: Sizer.getFontSize(context),
                                          fontFamily: 'Inter',
                                          color: AppColors.darkPrimary
                                              .withOpacity(.5),
                                        ),
                                      ),

                                      // apply button
                                      CustomButton(
                                        text: "Apply now",
                                        onPressed: () {},
                                        trailingIcon: Icon(
                                          Icons.arrow_forward,
                                          color: AppColors.black,
                                        ),
                                        fontSize: Sizer.getFontSize(context),
                                        width: 170,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ));
                  }
                })
              ],
            );
          }),
        ),
      ),
    );
  }
}
