import 'dart:js';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/not_found_screen.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:flutter_gaw_cms/sign_in/sign_in_screen.dart';
import 'package:flutter_gaw_cms/splash/splash_screen.dart';

Map<Pattern, Function(BuildContext, BeamState, Object?)> routes = {
  NotFoundScreen.route: (context, state, data) => notFoundBeamPage,
  SplashScreen.route: (context, state, data) => splashBeamPage,
  DashboardScreen.route: (context, state, data) => dashboardBeamPage,
  SignInScreen.route: (context, state, data) => signInBeamPage,
};

BeamerDelegate mainRouter = BeamerDelegate(
  notFoundRedirectNamed: NotFoundScreen.route,
  locationBuilder: RoutesLocationBuilder(
    routes: routes,
  ),
);
