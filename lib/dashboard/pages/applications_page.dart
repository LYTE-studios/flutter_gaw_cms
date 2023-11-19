import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage applicationsBeamPage = BeamPage(
  title: 'Applications',
  key: ValueKey('applications'),
  type: BeamPageType.noTransition,
  child: ApplicationsPage(),
);

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  static const String route = '/washers/applications';

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GawTheme.background,
      body: Column(
        children: [],
      ),
    );
  }
}
