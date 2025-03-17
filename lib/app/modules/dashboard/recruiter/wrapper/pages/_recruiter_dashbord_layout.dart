import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/widgets/_app_logo.dart';
import 'package:joblagbe/app/modules/dashboard/recruiter/controllers/_wrapper_controller.dart';

class RecruiterDashboardLayout extends StatelessWidget {
  const RecruiterDashboardLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecruiterWrapperController());
    // Sync sidebar with current URL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.syncMenuWithRoute(context);
    });

    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          // side menu
          Container(
            width: 250,
            decoration: BoxDecoration(color: AppColors.darkPrimary),
            child: Column(
              children: [
                AppLogo(
                  onTap: () {
                    (context).go('/dashboard/recruiter/home');
                  },
                  color: AppColors.white,
                ),

                const SizedBox(
                  height: 50,
                ),

                // side menu items

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.sideMenus.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      final menuItem = controller.sideMenus[index];
                      final isSelected =
                          controller.selectedMenuIndex.value == index;
                      return MouseRegion(
                        onEnter: (_) {
                          controller.onHover(index);
                        },
                        onExit: (_) {
                          controller.onHover(-1);
                        },
                        cursor: SystemMouseCursors.click,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: controller.hoveredMenuIndex.value == index
                              ? 0.5
                              : 1,
                          child: GestureDetector(
                            onTap: () {
                              // change the selected index
                              controller.selectedMenuIndex.value = index;

                              // navigate to the selected route
                              final selectedRoute = menuItem["route"];
                              if (selectedRoute != null) {
                                (context).go(selectedRoute);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 13,
                                bottom: 13,
                                left: 20,
                                right: 20,
                              ),
                              margin: EdgeInsets.only(left: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    menuItem["icon"],
                                    color: isSelected
                                        ? AppColors.darkPrimary
                                        : AppColors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    menuItem["title"],
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.darkPrimary
                                          : AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                )
              ],
            ),
          ),

          // content area
          Expanded(
            child: child,
          ),
        ],
      )),
    );
  }
}
