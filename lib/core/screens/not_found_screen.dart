import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage notFoundBeamPage = BeamPage(
  title: 'Not found',
  key: ValueKey('not-found'),
  type: BeamPageType.fadeTransition,
  child: NotFoundScreen(),
);

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  static const String route = '/dashboard/not/found';

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: GawTheme.mainTint,
      body: Center(
        child: SplashLogo(),
      ),
    );
  }
}
