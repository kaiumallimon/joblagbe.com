import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RecruiterWrapperController extends GetxController {
  RxList<Map<String, dynamic>> sideMenus = [
    {
      "title": "Home",
      "icon": Icons.home,
      "route": "/dashboard/recruiter/home",
    },
    {
      "title": "Jobs",
      "icon": Icons.work,
      "route": "/dashboard/recruiter/jobs",
    },
    // Add more menu items here if needed
  ].obs; // Make it observable if it needs to change dynamically

  var selectedMenuIndex = 0.obs;
  var hoveredMenuIndex = (-1).obs;

  void onHover(int index) {
    hoveredMenuIndex.value = index;
  }

  void syncMenuWithRoute(BuildContext context) {
    String currentRoute = GoRouter.of(context).state.path!;

    for (int i = 0; i < sideMenus.length; i++) {
      if (currentRoute == sideMenus[i]["route"]) {
        selectedMenuIndex.value = i;
        break;
      }
    }
  }
}
