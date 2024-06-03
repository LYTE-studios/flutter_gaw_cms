import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/router.dart';
import 'package:flutter_gaw_cms/core/routing/sign_in_router.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:flutter_gaw_cms/secrets.dart';
import 'package:flutter_gaw_cms/sign_in/sign_in_screen.dart';
import 'package:flutter_gaw_cms/sign_in/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwebapp_reload_detector/flutterwebapp_reload_detector.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();

void main() async {
  // creates a zone
  // https://3192ba45a662172001c39b327f7fd052@o4506789659475968.ingest.sentry.io/4506853393104896
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize other stuff here...

    await EasyLocalization.ensureInitialized();

    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://30a4d7bb896f68710fafbe3cf5e3a489@o4506789659475968.ingest.sentry.io/4506852975378432';
      },
    );
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('nl'),
          Locale('fr'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const CodegenLoader(),
        child: const GawApp(),
      ),
    );
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

class GawApp extends StatelessWidget {
  const GawApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Configuration.clientSecret = apiSecret;
    Configuration.apiUrl = apiUrl;
    Configuration.googleApiUrl = googleApiUrl;
    Configuration.routesGoogleApiUrl = routesGoogleApiUrl;
    Configuration.googleApiKey = apiGoogleKey;

    WebAppReloadDetector.onReload(() {
      if (Configuration.accessToken != null &&
          Configuration.refreshToken != null) {
        mainRouter.beamToNamed(DashboardScreen.route);
      }
    });

    Configuration.onExpireSession = () {
      LocalStorageUtil.setTokens(null, null);

      mainRouter.beamToNamed(SignInScreen.route);
      signInRouter.beamToNamed(WelcomeScreen.route);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          duration: Duration(
            seconds: 1,
          ),
          backgroundColor: Colors.transparent,
          content: BasicSnackBar(
            title: 'Session expired!',
            description: 'Please log in if you wish to continue.',
          ),
        ),
      );
    };

    return ProviderScope(
      child: MaterialApp.router(
        scaffoldMessengerKey: scaffoldKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: fallbackTheme,
        routeInformationParser: BeamerParser(),
        routerDelegate: mainRouter,
      ),
    );
  }
}
