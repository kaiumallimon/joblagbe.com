import 'package:get/get.dart';

class HeaderController extends GetxController {
  var menuItems = [
    'Home',
    'About Us',
    'Categories',
    'Jobs',
    'Blog',
    'Contact Us',
  ].obs;

  var hoverIndex = (-1).obs;

  void onHover(int index) {
    hoverIndex.value = index;
  }

  void onPress(int index) {
    print('Pressed: ${menuItems[index]}');
  }
}
