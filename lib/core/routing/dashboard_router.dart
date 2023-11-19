import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/not_found_screen.dart';
import 'package:flutter_gaw_cms/dashboard/pages/customers_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/dashboard_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/statistics_page.dart';

Map<Pattern, Function(BuildContext, BeamState, Object?)> routes = {
  NotFoundScreen.route: (context, state, data) => notFoundBeamPage,
  CustomersPage.route: (context, state, data) => customersBeamPage,
  DashboardPage.route: (context, state, data) => dashboardPageBeamPage,
  StatisticsPage.route: (context, state, data) => statisticsBeamPage,
};

BeamerDelegate dashboardRouter = BeamerDelegate(
  notFoundRedirectNamed: NotFoundScreen.route,
  locationBuilder: RoutesLocationBuilder(
    routes: routes,
  ),
);
