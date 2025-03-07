import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/core/widgets/_scroll_progress_btn.dart';
import 'package:joblagbe/app/modules/landing/views/sections/hero/_hero.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../controllers/_scroll_controller.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollControllerX scrollController = Get.find<ScrollControllerX>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DynMouseScroll(builder: (context, controller, physics) {
          scrollController.attatchScrollController(controller);
          return CustomScrollView(
            controller: controller,
            physics: physics,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  HeroSection(),
                  Placeholder(),
                  Placeholder(),
                  Placeholder(),
                  Placeholder(),
                ]),
              ),
            ],
          );
        }),
      ),
      floatingActionButton:
          CustomScrollPositionIndicatorButton(controller: scrollController),
    );
  }
}
