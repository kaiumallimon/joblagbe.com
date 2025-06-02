import 'package:flutter/material.dart';
import 'package:joblagbe/app/data/models/_job_model.dart';
import 'package:joblagbe/app/modules/admin/views/pages/_admin_add_categories_page.dart';
import 'package:joblagbe/app/modules/admin/views/pages/_admin_categories_page.dart';
import 'package:joblagbe/app/modules/admin/views/pages/_admin_course_view_page.dart';
import 'package:joblagbe/app/data/models/_course_model.dart';
import 'package:joblagbe/app/modules/applicant/controllers/_applicant_jobs_application_controller.dart';
import 'package:joblagbe/app/modules/applicant/controllers/_applicant_wrapper_controller.dart';
import 'package:joblagbe/app/modules/applicant/views/pages/_applicant_course_view_page.dart';
import 'package:joblagbe/app/modules/applicant/views/pages/_applicant_courses_page.dart';
import 'package:joblagbe/app/modules/applicant/views/pages/_applicant_job_application_page.dart';
import 'package:joblagbe/app/routes/_routing_imports.dart';

class AppPages {
  // ✅ Landing Page
  static GoRoute landingPage = GoRoute(
    path: '/',
    builder: (context, state) => const LandingPage(),
  );

  // ✅ jobs page
  static GoRoute jobsPage = GoRoute(
    path: '/jobs',
    builder: (context, state) => const CategoriesPage(),
  );

  // ✅ login page
  static GoRoute loginPage =
      GoRoute(path: '/login', builder: (context, state) => const LoginPage());

  // ✅ register page
  static GoRoute registerPage = GoRoute(
      path: '/register', builder: (context, state) => const RegisterPage());

  // ✅ forgot password page
  static GoRoute forgotPasswordPage = GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage());

  // ✅ recruiter homepage
  static GoRoute recruiterHomePage = GoRoute(
    path: '/dashboard/recruiter/home',
    pageBuilder: (context, state) => RoutingEffects.buildFadeTransition(
      state,
      const RecruiterHome(),
    ),
  );

  // ✅ recruiter jobs page
  static GoRoute recruiterJobsPage = GoRoute(
      path: '/dashboard/recruiter/jobs',
      pageBuilder: (context, state) => RoutingEffects.buildFadeTransition(
            state,
            const RecruiterJobsPage(),
          ),
      routes: [
        GoRoute(
          path: "edit/:jobId",
          pageBuilder: (context, state) {
            final jobId = state.pathParameters['jobId']!;
            // Fetch job data using the jobId
            Get.put(RecruiterJobEditController(jobId: jobId), tag: jobId);

            return RoutingEffects.buildFadeTransition(
              state,
              RecruiterJobEditPage(
                jobId: jobId,
              ),
            );
          },
        )
      ]);

  // ✅ recruiter add job page
  static GoRoute recruiterAddJobPage = GoRoute(
    path: '/dashboard/recruiter/add-job',
    pageBuilder: (context, state) => RoutingEffects.buildFadeTransition(
      state,
      const AddJobPage(),
    ),
  );

  // ✅ recruiter applications page
  static GoRoute recruiterApplicationsPage = GoRoute(
    path: '/dashboard/recruiter/applications',
    pageBuilder: (context, state) => RoutingEffects.buildFadeTransition(
      state,
      const ApplicationsPage(),
    ),
  );

  // ✅ recruiter profile page
  static GoRoute recruiterProfilePage = GoRoute(
    path: '/dashboard/recruiter/profile',
    pageBuilder: (context, state) => RoutingEffects.buildFadeTransition(
      state,
      const RecruiterProfilePage(),
    ),
  );

  // ✅ applicant homepage
  static GoRoute applicantHomePage = GoRoute(
    path: '/dashboard/applicant/home',
    builder: (context, state) => const ApplicantHome(),
  );

  // ✅ applicant jobs page
  static GoRoute applicantJobsPage = GoRoute(
      path: '/dashboard/applicant/jobs',
      builder: (context, state) => const ApplicantJobs(),
      routes: [
        GoRoute(
          path: '/apply',
          builder: (context, state) {
            // Check if we have valid job data
            final controller = Get.find<ApplicantWrapperController>();
            if (state.extra == null) {
              controller.selectedMenuIndex.value = 1;
              return const Scaffold(
                body: Center(
                  child:
                      Text('No job selected. Please go back and select a job.'),
                ),
              );
            }

            try {
              final jobData = state.extra as JobModel;
              if (jobData.id == null || jobData.id!.isEmpty) {
                controller.selectedMenuIndex.value = 1;
                return const Scaffold(
                  body: Center(
                    child: Text(
                        'Invalid job data. Please go back and select a job.'),
                  ),
                );
              }

              // Initialize controller with the job data
              Get.put(
                ApplicantJobsApplicationController(currentJob: jobData),
                tag: jobData.id!,
              );

              return ApplicantJobApplicationPage(jobId: jobData.id!);
            } catch (e) {
              return const Scaffold(
                body: Center(
                  child: Text(
                      'Error loading job data. Please go back and try again.'),
                ),
              );
            }
          },
        )
      ]);
  // ✅ applicant courses page
  static GoRoute applicantCoursePage = GoRoute(
      path: '/dashboard/applicant/courses',
      builder: (context, state) {
        return const ApplicantCoursePage();
      },
      routes: [
        GoRoute(
          path: 'view/:courseId',
          builder: (context, state) {
            final courseId = state.pathParameters['courseId']!;
            return ApplicantCourseViewPageWithId(courseId: courseId);
          },
        ),
      ]);

  // ✅ applicant profile page
  static GoRoute applicantProfilePage = GoRoute(
    path: '/dashboard/applicant/profile',
    builder: (context, state) => const ApplicantProfilePage(),
  );

  // ✅ admin homepage
  static GoRoute adminHomePage = GoRoute(
    path: '/dashboard/admin/home',
    builder: (context, state) => const AdminHomePage(),
  );

  // ✅ admin courses page
  static GoRoute adminCoursesPage = GoRoute(
    path: '/dashboard/admin/courses',
    builder: (context, state) {
      // If there's a courseId in the state, show the course view
      if (state.extra != null) {
        final course = state.extra as Course?;
        if (course != null) {
          return AdminCourseViewPage(course: course);
        }
        // If we have a courseId but no course object, fetch it
        final courseId = state.uri.queryParameters['courseId'];
        if (courseId != null) {
          return AdminCourseViewPageWithId(courseId: courseId);
        }
      }
      // Otherwise show the courses list
      return const AdminManageCourses();
    },
  );

  // ✅ admin add course page
  static GoRoute adminAddCoursePage = GoRoute(
    path: '/dashboard/admin/add-course',
    builder: (context, state) => const AdminAddCourse(),
  );

  // ✅ admin add categories page
  static GoRoute adminAddCategoriesPage = GoRoute(
    path: '/dashboard/admin/add-categories',
    builder: (context, state) => const AdminAddCategoriesPage(),
  );

  // ✅ admin categories page
  static GoRoute adminCategoriesPage = GoRoute(
    path: '/dashboard/admin/categories',
    builder: (context, state) => const AdminCategoriesPage(),
  );
}
