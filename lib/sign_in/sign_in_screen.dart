import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/sign_in_router.dart';
import 'package:flutter_gaw_cms/core/widgets/banners/cms_banner.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage signInBeamPage = BeamPage(
  title: 'Sign in',
  key: ValueKey('sign-in'),
  type: BeamPageType.noTransition,
  child: SignInScreen(),
);

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String route = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CmsBanner(),
          Expanded(
            child: MaterialApp.router(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: fallbackTheme,
              routeInformationParser: BeamerParser(),
              routerDelegate: signInRouter,
            ),
          ),
        ],
      ),
    );
  }
}
