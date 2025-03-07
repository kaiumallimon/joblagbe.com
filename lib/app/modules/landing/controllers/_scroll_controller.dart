import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollControllerX extends GetxController {
  ScrollController? scrollController = ScrollController();

  void attatchScrollController(ScrollController controller) {
    scrollController = controller;
    scrollController!.addListener(() {
      updateProgress();
    });
  }

  bool isScrolled() {
    if (scrollController!.hasClients) {
      return scrollController!.offset > 0;
    }
    return false;
  }

  var progress = (0.0).obs;

  void updateProgress() {
    if (scrollController == null) return;

    double maxScroll = scrollController!.position.maxScrollExtent;
    double currentScroll = scrollController!.position.pixels;

    progress.value = (currentScroll / maxScroll).clamp(0.0, 1.0);
  }

  void goToTop() {
    if (scrollController != null) {
      scrollController!.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
