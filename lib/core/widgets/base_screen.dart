import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/drawer_navigation_item.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/drawer_navigation_sub_item.dart';
import 'package:flutter_gaw_cms/dashboard/pages/customers_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/dashboard_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/statistics_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/washers_page.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class BaseScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  final Widget child;

  final String route;

  final Function(String)? onChangeRoute;

  const BaseScreen({
    super.key,
    this.scaffoldKey,
    required this.child,
    this.route = '',
    this.onChangeRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CmsDrawer(
            onChange: (value) {
              onChangeRoute?.call(value);
            },
            route: route,
          ),
          Expanded(
            child: Container(
              color: GawTheme.background,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class CmsDrawer extends StatelessWidget {
  final String route;

  final Function(String)? onChange;

  const CmsDrawer({
    super.key,
    this.route = '',
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 278,
      decoration: const BoxDecoration(
        color: GawTheme.clearText,
        boxShadow: [
          Shadows.lightShadow,
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 124,
            decoration: const BoxDecoration(
              color: GawTheme.clearBackground,
              border: Border(
                bottom: Borders.mainSide,
              ),
            ),
            child: const Center(
              child: MainLogoBig(),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left:
                    PaddingSizes.extraBigPadding + PaddingSizes.mainPadding,
                    top: PaddingSizes.bigPadding,
                    bottom: PaddingSizes.smallPadding,
                  ),
                  child: MainText(
                    'MAIN',
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                DrawerNavigationItem(
                  label: 'Dashboard',
                  iconUrl: PixelPerfectIcons.doorMedium,
                  active: [DashboardPage.route, StatisticsPage.route]
                      .contains(route),
                  onTap: () {
                    onChange?.call(DashboardPage.route);
                  },
                  subItems: [
                    DrawerNavigationSubItem(
                      onTap: () {
                        onChange?.call(StatisticsPage.route);
                      },
                      label: 'Statistics',
                      active: route == StatisticsPage.route,
                    ),
                  ],
                ),
                const SizedBox(
                  height: PaddingSizes.smallPadding,
                ),
                DrawerNavigationItem(
                  label: 'Customers',
                  onTap: () {
                    onChange?.call(CustomersPage.route);
                  },
                  iconUrl: PixelPerfectIcons.personMedium,
                  active: CustomersPage.route == route,
                ),
                const SizedBox(
                  height: PaddingSizes.smallPadding,
                ),
                DrawerNavigationItem(
                  label: 'Washers',
                  iconUrl: PixelPerfectIcons.waterDripNormal,
                  onTap: () {
                    onChange?.call(WashersPage.route);
                  },
                  active: WashersPage.route == route,
                  subItems: const [
                    DrawerNavigationSubItem(
                      label: 'Applications',
                    ),
                  ],
                ),
                const SizedBox(
                  height: PaddingSizes.smallPadding,
                ),
              ],
            ),
          ),
          Container(
            height: 26,
            decoration: const BoxDecoration(
              color: GawTheme.clearBackground,
              border: Border(
                top: Borders.mainSide,
              ),
            ),
            child: Center(
              child: MainText(
                '© 2023 Get a Wash',
                textStyleOverride: TextStyles.mainStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
