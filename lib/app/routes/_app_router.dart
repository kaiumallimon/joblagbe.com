import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:joblagbe/app/modules/404/views/_404_notfound.dart';
import 'package:joblagbe/app/modules/auth/controllers/_login_controller.dart';
import 'package:joblagbe/app/modules/admin/views/pages/_admin_dashboard_layout_page.dart';
import 'package:joblagbe/app/modules/applicant/views/pages/_applicant_dashboard_layout_page.dart';
import 'package:joblagbe/app/modules/recruiter/views/pages/_recruiter_dashbord_layout_page.dart';
import 'package:joblagbe/app/modules/landing/views/_landing_layout.dart';
import 'package:joblagbe/app/routes/_app_pages.dart';
import 'package:joblagbe/app/routes/_routing_redirections.dart';
import 'package:joblagbe/main.dart';

class AppRouter {
  static GoRouter router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/landing',
      refreshListenable: Get.find<LoginController>().userRoleNotifier,
      routes: [
        AppPages.rootRedirect,
        // ✅ Landing page
        ShellRoute(
          builder: (context, state, child) => LandingLayout(child: child),
          routes: [AppPages.landingPage, AppPages.jobsPage],
        ),

        // ✅ Auth Routes (Public)
        AppPages.loginPage,
        AppPages.registerPage,
        AppPages.forgotPasswordPage,

        // ✅ Recruiter Dashboard (Protected)
        ShellRoute(
          builder: (context, state, child) =>
              RecruiterDashboardLayout(child: child),
          routes: [
            AppPages.recruiterHomePage,
            AppPages.recruiterJobsPage,
            AppPages.recruiterAddJobPage,
            AppPages.recruiterApplicationsPage,
            AppPages.recruiterProfilePage,
          ],
        ),

        // ✅ Applicant Dashboard (Protected)
        ShellRoute(
          builder: (context, state, child) =>
              ApplicantDashboardLayout(child: child),
          routes: [
            AppPages.applicantHomePage,
            AppPages.applicantJobsPage,
            AppPages.applicantCoursePage,
            AppPages.applicantProfilePage,
          ],
        ),

        // ✅ Admin Dashboard (Protected)
        ShellRoute(
          builder: (context, state, child) =>
              AdminDashboardLayout(child: child),
          routes: [
            AppPages.adminHomePage,
            AppPages.adminCoursesPage,
            AppPages.adminAddCoursePage,
            AppPages.adminCategoriesPage,
            AppPages.adminAddCategoriesPage,
          ],
        ),
      ],
      errorBuilder: (context, state) => PageNotFound(),
      redirect: (context, state) =>
          AppRoutingRedirections.appRedirection(context, state));
}
