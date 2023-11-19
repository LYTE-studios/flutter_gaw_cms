import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/dashboard_router.dart';
import 'package:flutter_gaw_cms/core/widgets/base_screen.dart';
import 'package:flutter_gaw_cms/dashboard/pages/customers_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/dashboard_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/statistics_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/washers_page.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey();

const BeamPage dashboardBeamPage = BeamPage(
  title: 'Home',
  key: ValueKey('dashboard'),
  type: BeamPageType.noTransition,
  child: DashboardScreen(),
);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String route = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String route = DashboardPage.route;

  final Map<String, Widget> pages = {
    DashboardPage.route: const DashboardPage(),
    StatisticsPage.route: const StatisticsPage(),
    CustomersPage.route: const CustomersPage(),
    WashersPage.route: const WashersPage(),
  };

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      key: globalScaffoldKey,
      route: route,
      onChangeRoute: (String route) {
        dashboardRouter.beamToNamed(route);
        setState(() {
          this.route = route;
        });
      },
      child: MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: fallbackTheme,
        routeInformationParser: BeamerParser(),
        routerDelegate: dashboardRouter,
      ),
    );
  }
}
