import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AdminWrapperController extends GetxController {
  RxList<Map<String, dynamic>> sideMenus = [
    {
      "title": "Home",
      "icon": Icons.home,
      "route": "/dashboard/admin/home",
    },
    {
      "title": "Courses",
      "icon": Icons.work,
      "route": "/dashboard/admin/courses",
    },
    {
      "title": "Add Course",
      "icon": Icons.add,
      "route": "/dashboard/admin/add-course",
    },
    {
      "title": "Categories",
      "icon": Icons.category,
      "route": "/dashboard/admin/categories",
    },
    {
      "title": "Add Categories",
      "icon": Icons.add,
      "route": "/dashboard/admin/add-categories",
    },
    
    // {
    //   "title": "Applications",
    //   "icon": Icons.assignment,
    //   "route": "/dashboard/admin/applications",
    // },
    // {
    //   "title": "Profile",
    //   "icon": Icons.account_circle,
    //   "route": "/dashboard/admin/profile",
    // },

    // Add more menu items here if needed
  ].obs; // Make it observable if it needs to change dynamically

  var selectedMenuIndex = 0.obs;
  var hoveredMenuIndex = (-1).obs;

  void onHover(int index) {
    hoveredMenuIndex.value = index;
  }

  void syncMenuWithRoute(BuildContext context) {
    String currentRoute = GoRouter.of(context).state.path!;
    
    // Find the base route by removing any additional segments
    String baseRoute = currentRoute;
    if (currentRoute.contains('/view/')) {
      baseRoute = currentRoute.substring(0, currentRoute.indexOf('/view/'));
    }

    // Find the matching menu item
    for (int i = 0; i < sideMenus.length; i++) {
      if (baseRoute == sideMenus[i]["route"]) {
        selectedMenuIndex.value = i;
        break;
      }
    }
  }
}
