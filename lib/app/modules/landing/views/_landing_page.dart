import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/core/widgets/_scroll_progress_btn.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../controllers/_scroll_controller.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollControllerX scrollController = Get.find<ScrollControllerX>();

    return Scaffold(
      body: SafeArea(
        child: DynMouseScroll(builder: (context, controller, physics) {
          scrollController.attatchScrollController(controller);
          return CustomScrollView(
            controller: controller,
            physics: physics,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    height: 500,
                    width: Sizer.getDynamicWidth(context),
                    color: Colors.white,
                  ),
                  Container(
                    height: 500,
                    width: Sizer.getDynamicWidth(context),
                    color: Colors.yellowAccent,
                  ),
                  Container(
                    height: 500,
                    width: Sizer.getDynamicWidth(context),
                    color: Colors.white,
                  ),
                  Container(
                    height: 500,
                    width: Sizer.getDynamicWidth(context),
                    color: Colors.green,
                  ),
                  Container(
                    height: 500,
                    width: Sizer.getDynamicWidth(context),
                    color: Colors.white,
                  ),
                  Container(
                    height: 500,
                    width: Sizer.getDynamicWidth(context),
                    color: Colors.red,
                  ),
                  Container(
                    height: 500,
                    width: Sizer.getDynamicWidth(context),
                    color: Colors.black38,
                  ),
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
