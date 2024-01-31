import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/sign_in_router.dart';
import 'package:flutter_gaw_cms/core/widgets/banners/cms_banner.dart';
import 'package:gaw_ui/gaw_ui.dart';

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
      backgroundColor: GawTheme.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Visibility(
              visible: MediaQuery.of(context).size.width > 960,
              child: const CmsBanner(),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                MaterialApp.router(
                  theme: fallbackTheme,
                  routeInformationParser: BeamerParser(),
                  routerDelegate: signInRouter,
                ),
                const Center(
                  child: SizedBox(
                    height: 550,
                    width: 420,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: MainLogoBig(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
