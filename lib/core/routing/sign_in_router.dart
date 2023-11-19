import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/sign_in/welcome_screen.dart';

Map<Pattern, Function(BuildContext, BeamState, Object?)> routes = {
  WelcomeScreen.route: (context, state, data) => welcomeBeamPage,
};

BeamerDelegate signInRouter = BeamerDelegate(
  notFoundRedirectNamed: WelcomeScreen.route,
  initialPath: WelcomeScreen.route,
  locationBuilder: RoutesLocationBuilder(
    routes: routes,
  ),
);
