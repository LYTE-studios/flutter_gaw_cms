import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:flutter_gaw_cms/splash/splash_screen.dart';

Map<Pattern, Function(BuildContext, BeamState, Object?)> routes = {
  SplashScreen.route: (context, state, data) => splashBeamPage,
  DashboardScreen.route: (context, state, data) => dashboardBeamPage,
};

BeamerDelegate router = BeamerDelegate(
  notFoundRedirectNamed: '/',
  locationBuilder: RoutesLocationBuilder(
    routes: routes,
  ),
);
