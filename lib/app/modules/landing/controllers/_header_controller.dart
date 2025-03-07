import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HeaderController extends GetxController {
  var menuItems = [
    'Home',
    'Jobs',
    'Blog',
    'Contact Us',
  ].obs;

  var hoverIndex = (-1).obs;

  // Add a reactive variable for selected index
  var selectedIndex = 0.obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   // Add the GoRouterObserver to observe route changes
  //   final router = GoRouter.of(Get.context!);
  //   router.routerDelegate.addListener(_onRouteChange);
  // }

  // @override
  // void onClose() {
  //   // Clean up the listener when the controller is disposed
  //   final router = GoRouter.of(Get.context!);
  //   router.routerDelegate.removeListener(_onRouteChange);
  //   super.onClose();
  // }

  // void _onRouteChange() {
  //   // Get current route and update the selectedIndex accordingly
  //   final currentRoute = GoRouter.of(Get.context!).state.name;

  //   print('Current route: $currentRoute');

  //   switch (currentRoute) {
  //     case '/':
  //       selectedIndex.value = 0;
  //       break;
  //     case '/categories':
  //       selectedIndex.value = 1;
  //       break;
  //     case '/jobs':
  //       selectedIndex.value = 2;
  //       break;
  //     case '/blog':
  //       selectedIndex.value = 3;
  //       break;
  //     case '/contact':
  //       selectedIndex.value = 4;
  //       break;
  //     default:
  //       selectedIndex.value = -1;
  //       break;
  //   }
  // }

  // @override
  // void onInit() {
  //   var currentRoute = GoRouter.of(Get.context!).state.name;
  //   print('Current route: $currentRoute');
  // }

  void onHover(int index) {
    hoverIndex.value = index;
  }

  void onPress(BuildContext context, int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/jobs');
        break;
      case 2:
        GoRouter.of(context).go('/blog');
        break;
      case 3:
        GoRouter.of(context).go('/contact');
        break;
      default:
        break;
    }
  }
}
