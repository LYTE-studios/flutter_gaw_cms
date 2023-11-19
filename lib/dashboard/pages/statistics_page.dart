import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage statisticsBeamPage = BeamPage(
  title: 'Statistics',
  key: ValueKey('statistics'),
  type: BeamPageType.noTransition,
  child: StatisticsPage(),
);

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  static const String route = '/dashboard/statistics';

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
