import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joblagbe/app/core/theming/colors/_colors.dart';
import 'package:joblagbe/app/core/utils/_sizer.dart';

class HeroSection4 extends StatelessWidget {
  const HeroSection4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
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
                  'How It Works?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.black,
                    fontSize: Sizer.getFontSize(context) * 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Discover a wealth of career opportunities tailored to your position and expertise. Our platform connects you with a diverse range of job listings, ensuring you find the perfect fit for your skills and aspirations. Whether you\'re seeking remote work, freelance gigs, or full-time positions, we\'ve got you covered. Explore our extensive job database and take the next step in your career journey with confidence.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.black.withOpacity(.5),
                    fontSize: Sizer.getFontSize(context),
                  ),
                ),
                SizedBox(height: 40),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tutorialData.length,
                  itemBuilder: (context, index) {
                    final step = tutorialData.keys.elementAt(index);
                    final description = tutorialData[step]!;
                    return TutorialCard(step: step, description: description);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TutorialCard extends StatefulWidget {
  const TutorialCard({
    super.key,
    required this.step,
    required this.description,
  });

  final String step;
  final String description;

  @override
  State<TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<TutorialCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color:
              isHovered ? AppColors.primary.withOpacity(0.2) : AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.step,
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.black,
                fontSize: Sizer.getFontSize(context) * 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: Sizer.getDynamicWidth(context) * 0.5,
                  child: Wrap(
                    children: [
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.black.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    Icons.open_in_new,
                    color: AppColors.black.withOpacity(.5),
                    size: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final Map<String, String> tutorialData = {
  'Create Account':
      'Sign up quickly with your email or social accounts to get started. Creating an account gives you access to a world of job opportunities and personalized features.',
  'Complete Profile':
      'Add your experience, education, and skills to make your profile stand out. A complete profile increases your chances of being noticed by top employers.',
  'Browse Opportunities':
      'Explore a wide range of jobs tailored to your interests and expertise. Use filters and search tools to find the perfect match for your career goals.',
  'Apply for Jobs':
      'Apply to jobs you like with just a few clicks and submit your application instantly. Our platform makes the process simple and efficient for you.',
  'Track Applications':
      'Monitor your application status and receive instant updates on your progress. Stay organized and never miss important notifications from employers.',
  'Get Hired':
      'Accept job offers and start your new career journey with confidence. We support you through the onboarding process for a smooth transition.'
};
