import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage dashboardPageBeamPage = BeamPage(
  title: 'Dashboard',
  key: ValueKey('dashboard'),
  type: BeamPageType.noTransition,
  child: DashboardPage(),
);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const String route = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Column(
            children: [
              CmsHeader(),
            ],
          ),
          Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              Expanded(
                child: ScreenSheet(
                  child: GenericListView(
                    title: LocaleKeys.applications.tr(),
                    valueName: LocaleKeys.applications.tr().toLowerCase(),
                    showFooter: false,
                    rows: [],
                    header: const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
