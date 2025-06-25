import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/core/widgets/_scroll_progress_btn.dart';
import 'package:joblagbe/app/modules/landing/controllers/_landing_jobs_controller.dart';
import 'package:joblagbe/app/modules/landing/views/sections/footer/_footer.dart';
import 'package:joblagbe/app/modules/landing/views/sections/hero/_hero.dart';
import 'package:joblagbe/app/modules/landing/views/sections/hero/_hero_3.dart';
import 'package:joblagbe/app/modules/landing/views/sections/hero/_hero_4.dart';
import 'package:joblagbe/app/modules/landing/views/sections/hero/_hero_5.dart';
import 'package:joblagbe/app/modules/landing/views/sections/hero/_hero_6.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../controllers/_scroll_controller.dart';
import 'sections/hero/_hero2.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollControllerX scrollController = Get.find<ScrollControllerX>();
    Get.put(LandingJobsController());
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
                  HeroSection2(),
                  HeroSection3(),
                  HeroSection4(),
                  HeroSection5(),
                  HeroSection6(),
                  LandingFooter()
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
