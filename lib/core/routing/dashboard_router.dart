import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/not_found_screen.dart';
import 'package:flutter_gaw_cms/dashboard/pages/applications_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/customers_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/dashboard_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/dimona_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/exports_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/jobs_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/notifications_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/registrations_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/settings_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/statistics_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/tags_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/washers_page.dart';
import 'package:flutter_gaw_cms/jobs/presentation/application_review_screen.dart';
import 'package:gaw_ui/generated/locale_keys.g.dart';

Map<Pattern, Function(BuildContext, BeamState, Object?)> routes = {
  NotFoundScreen.route: (context, state, data) => notFoundBeamPage,
  CustomersPage.route: (context, state, data) => customersBeamPage,
  DashboardPage.route: (context, state, data) => dashboardPageBeamPage,
  WashersPage.route: (context, state, data) => washersBeamPage,
  DimonaPage.route: (context, state, data) => dimonasBeamPage,
  ApplicationsPage.route: (context, state, data) => applicationsBeamPage,
  RegistrationsPage.route: (context, state, data) => registrationsBeamPage,
  ExportsPage.route: (context, state, data) => exportsBeamPage,
  TagsPage.route: (context, state, data) => tagsBeamPage,
  ApplicationReviewScreen.route: (context, state, data) {
    final jobId = state.pathParameters[ApplicationReviewScreen.kJobId]
        ?.replaceFirst(':', '');
    if (jobId == null) {
      return notFoundBeamPage;
    }

    return BeamPage(
      title: LocaleKeys.applications.tr(),
      key: const ValueKey('applications-review'),
      type: BeamPageType.noTransition,
      child: ApplicationReviewScreen(
        jobId: jobId,
      ),
    );
  },
  JobsPage.route: (context, state, data) => jobsBeamPage,
  NotificationsPage.route: (context, state, data) => notificationsBeamPage,
  SettingsPage.route: (context, state, data) => settingsBeamPage,
  StatisticsPage.route: (context, state, data) => statisticsBeamPage,
};

BeamerDelegate dashboardRouter = BeamerDelegate(
  notFoundRedirectNamed: NotFoundScreen.route,
  initialPath: DashboardPage.route,
  locationBuilder: RoutesLocationBuilder(
    routes: routes,
  ),
);
