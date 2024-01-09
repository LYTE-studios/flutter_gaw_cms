import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage jobsBeamPage = BeamPage(
  title: 'Jobs',
  key: ValueKey('jobs'),
  type: BeamPageType.noTransition,
  child: JobsPage(),
);

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  static const String route = '/dashboard/jobs';

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return const BaseLayoutScreen(
      child: Column(
        children: [
          GenericListView(
            title: 'Jobs',
            header: const SizedBox(),
            rows: [],
          )
        ],
      ),
    );
  }
}
