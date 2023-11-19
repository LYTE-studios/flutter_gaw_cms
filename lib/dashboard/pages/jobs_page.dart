import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage jobsBeamPage = BeamPage(
  title: 'Jobs',
  key: ValueKey('jobs'),
  type: BeamPageType.noTransition,
  child: JobsPage(),
);

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  static const String route = '/jobs';

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
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
