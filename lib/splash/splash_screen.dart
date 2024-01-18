import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/router.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:flutter_gaw_cms/secrets.dart';
import 'package:flutter_gaw_cms/sign_in/sign_in_screen.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const BeamPage splashBeamPage = BeamPage(
  title: 'Get a Wash',
  key: ValueKey('splash'),
  type: BeamPageType.noTransition,
  child: SplashScreen(),
);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const String route = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void _goToWelcome() {
    mainRouter.beamToReplacementNamed(SignInScreen.route);
  }

  void _goToDashboard() {
    AuthenticationApi.testConnection().then((success) {
      if (success) {
        mainRouter.beamToNamed(DashboardScreen.route);
      }
    }).catchError((error) {
      ExceptionHandler.show(Exception('Auth failed'));
      mainRouter.beamToReplacementNamed(SignInScreen.route);
    });
  }

  Future<void> getTokens() async {
    final tokens = await LocalStorageUtil.getTokens();

    String? token = tokens[LocalStorageUtil.kToken];

    String? refreshToken = tokens[LocalStorageUtil.kRefreshToken];

    if (token == null || refreshToken == null) {
      _goToWelcome();
      return;
    }

    Configuration.accessToken = token;
    Configuration.refreshToken = refreshToken;

    await LocalStorageUtil.setTokens(token, refreshToken);

    _goToDashboard();
  }

  @override
  void initState() {
    Configuration.clientSecret = apiSecret;
    Configuration.apiUrl = apiUrl;

    if (Configuration.accessToken != null &&
        Configuration.refreshToken != null) {
      _goToDashboard();
      return;
    }

    Future(() {
      getTokens();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: GawTheme.background,
      body: Center(
        child: CircularProgressIndicator(
          color: GawTheme.mainTint,
        ),
      ),
    );
  }
}
