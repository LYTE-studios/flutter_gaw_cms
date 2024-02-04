import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/router.dart';
import 'package:flutter_gaw_cms/core/routing/sign_in_router.dart';
import 'package:flutter_gaw_cms/secrets.dart';
import 'package:flutter_gaw_cms/sign_in/sign_in_screen.dart';
import 'package:flutter_gaw_cms/sign_in/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:themed/themed.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('nl'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: const GawApp(),
    ),
  );
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
      child: Themed(
        child: MaterialApp.router(
          scaffoldMessengerKey: scaffoldKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: fallbackTheme,
          routeInformationParser: BeamerParser(),
          routerDelegate: mainRouter,
        ),
      ),
    );
  }
}
