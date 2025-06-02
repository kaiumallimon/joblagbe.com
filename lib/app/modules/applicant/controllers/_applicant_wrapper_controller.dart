import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

class ApplicantWrapperController extends GetxController {
  RxList<Map<String, dynamic>> sideMenus = [
    {
      "title": "Home",
      "icon": Icons.home,
      "route": "/dashboard/applicant/home",
    },
    {
      "title": "Jobs",
      "icon": Icons.work,
      "route": "/dashboard/applicant/jobs",
    },

    {
      "title": "Courses",
      "icon": Icons.school,
      "route": "/dashboard/applicant/courses",
    },
    {
      "title": "Profile",
      "icon": Icons.person,
      "route": "/dashboard/applicant/profile",
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

  void showSavedInfo() async {
    var storage = GetStorage();

    var userInfo = storage.read('userInfo');

    if (userInfo != null) {
      print("User Info: $userInfo");
    } else {
      print("No user info found.");
    }
  }
}
