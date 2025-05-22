import 'package:joblagbe/app/modules/admin/views/pages/_admin_add_categories_page.dart';
import 'package:joblagbe/app/modules/admin/views/pages/_admin_categories_page.dart';
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
  );

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
    builder: (context, state) => const AdminManageCourses(),
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
