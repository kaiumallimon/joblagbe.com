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
    {
      "title": "Add Job",
      "icon": Icons.add,
      "route": "/dashboard/recruiter/add-job",
    },
    {
      "title": "Applications",
      "icon": Icons.assignment,
      "route": "/dashboard/recruiter/applications",
    },
    {
      "title": "Profile",
      "icon": Icons.account_circle,
      "route": "/dashboard/recruiter/profile",
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
      final menuRoute = sideMenus[i]["route"] as String;
      if (currentRoute == menuRoute ||
          (menuRoute == "/dashboard/recruiter/applications" &&
              (currentRoute.startsWith("/dashboard/recruiter/applications") ||
                  currentRoute
                      .startsWith("/dashboard/recruiter/applicant-profile")))) {
        selectedMenuIndex.value = i;
        break;
      }
    }
  }
}
