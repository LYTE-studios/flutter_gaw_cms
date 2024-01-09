import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage statisticsBeamPage = BeamPage(
  title: 'Statistics',
  key: ValueKey('statistics'),
  type: BeamPageType.noTransition,
  child: StatisticsPage(),
);

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  static const String route = '/dashboard/home/statistics';

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
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
