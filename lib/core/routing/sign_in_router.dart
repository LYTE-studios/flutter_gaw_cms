import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/sign_in/forgot_password_screen.dart';
import 'package:flutter_gaw_cms/sign_in/password_reset_screen.dart';
import 'package:flutter_gaw_cms/sign_in/verify_code_screen.dart';
import 'package:flutter_gaw_cms/sign_in/welcome_screen.dart';

Map<Pattern, Function(BuildContext, BeamState, Object?)> routes = {
  WelcomeScreen.route: (context, state, data) => welcomeBeamPage,
  ForgotPasswordScreen.route: (context, state, data) => forgotPasswordBeamPage,
  VerifyCodeScreen.route: (context, state, data) =>
      verifyCodeBeamPage(data as String),
  PasswordResetScreen.route: (context, state, data) {
    final code = state.pathParameters['code'] ?? '';
    final token = state.pathParameters['token'] ?? '';
    return resetPasswordBeamPage(code, token);
  },
};

BeamerDelegate signInRouter = BeamerDelegate(
  notFoundRedirectNamed: WelcomeScreen.route,
  initialPath: WelcomeScreen.route,
  locationBuilder: RoutesLocationBuilder(
    routes: routes,
  ),
);
