import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_formatter.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';
import 'package:joblagbe/app/modules/landing/controllers/_landing_jobs_controller.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';
import 'package:transparent_image/transparent_image.dart';

class HeroSection5 extends StatelessWidget {
  const HeroSection5({super.key});

  @override
  Widget build(BuildContext context) {
    final landingJobsController = Get.find<LandingJobsController>();

    return Container(
      color: AppColors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Sizer.getDynamicWidth(context),
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Newest Jobs',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.white,
                    fontSize: Sizer.getFontSize(context) * 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Our platform is designed to connect talented individuals from all corners of the globe, creating a diverse and dynamic community where innovation thrives. Join us in building a global network of talent, where ideas flow freely and opportunities abound. Together, we can shape the future of work and unlock the potential of a truly global workforce.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.white.withOpacity(.5),
                    fontSize: Sizer.getFontSize(context),
                  ),
                ),
                SizedBox(height: 40),
                Obx(() {
                  if (landingJobsController.isLoading.value) {
                    return Center(child: CupertinoActivityIndicator());
                  } else if (landingJobsController.recentlyAddedJobs.value ==
                          null ||
                      landingJobsController.recentlyAddedJobs.value!.isEmpty) {
                    return Center(
                        child: Text('No jobs available at the moment.'));
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // childAspectRatio: 3,
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 25,
                          mainAxisExtent: 190),
                      itemCount:
                          landingJobsController.recentlyAddedJobs.value!.length,
                      itemBuilder: (context, index) {
                        final job = landingJobsController
                            .recentlyAddedJobs.value![index];
                        return Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.darkPrimary,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInImage(
                                    placeholder: MemoryImage(kTransparentImage),
                                    image: NetworkImage(job.companyLogoUrl),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    fadeInDuration:
                                        const Duration(milliseconds: 500),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${job.company}, ${job.location}",
                                        style: TextStyle(
                                          fontSize:
                                              Sizer.getFontSize(context) - 2,
                                          fontFamily: 'Inter',
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        job.title,
                                        style: TextStyle(
                                          fontSize:
                                              Sizer.getFontSize(context) * 1.2,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        DateTimeFormatter().getJobPostedTime(
                                          job.createdAt?.toDate() ??
                                              DateTime.now(),
                                        ),
                                        style: TextStyle(
                                          fontSize:
                                              Sizer.getFontSize(context) - 2,
                                          fontFamily: 'Inter',
                                          color:
                                              AppColors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                job.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Sizer.getFontSize(context) - 2,
                                  fontFamily: 'Inter',
                                  color: AppColors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
