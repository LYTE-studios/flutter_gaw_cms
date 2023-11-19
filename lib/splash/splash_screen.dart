import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/dashboard/dashboard_screen.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const BeamPage splashBeamPage = BeamPage(
  title: 'Loading...',
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
  @override
  void initState() {
    Future(() {
      Beamer.of(context).beamToNamed(
        DashboardScreen.route,
      );
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
