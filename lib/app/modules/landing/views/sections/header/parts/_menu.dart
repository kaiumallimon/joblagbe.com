import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/theming/colors/_colors.dart';
import '../../../../controllers/_header_controller.dart';

class HeaderMenu extends StatelessWidget {
  const HeaderMenu({
    super.key,
    required this.headerController,
  });

  final HeaderController headerController;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: headerController.menuItems
          .map((item) => MouseRegion(
                onEnter: (event) {
                  headerController
                      .onHover(headerController.menuItems.indexOf(item));
                },
                onExit: (event) {
                  headerController.onHover(-1);
                },
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    headerController.onPress(
                        context, headerController.menuItems.indexOf(item));
                  },
                  child: Obx(() {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                            color: headerController.selectedIndex.value ==
                                    headerController.menuItems.indexOf(item)
                                ? AppColors.primary
                                : headerController.hoverIndex.value ==
                                        headerController.menuItems.indexOf(item)
                                    ? AppColors.primary
                                    : Colors.transparent,
                            width: 2),
                      )),
                      child: Text(
                        item,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    );
                  }),
                ),
              ))
          .toList(),
    );
  }
}
