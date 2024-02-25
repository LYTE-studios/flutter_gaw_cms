import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/confirm_logout_dialog.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/drawer_navigation_item.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/drawer_navigation_sub_item.dart';
import 'package:flutter_gaw_cms/dashboard/pages/applications_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/dashboard_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/jobs_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/notifications_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/registrations_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/settings_page.dart';
import 'package:flutter_gaw_cms/dashboard/pages/statistics_page.dart';
import 'package:gaw_ui/gaw_ui.dart';

import '../../../dashboard/pages/customers_page.dart';
import '../../../dashboard/pages/washers_page.dart';

typedef OnChangeRoute = Function(String)?;

class MenuDrawer extends StatelessWidget {
  final String route;

  final OnChangeRoute onChange;

  const MenuDrawer({
    super.key,
    required this.route,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: PaddingSizes.extraBigPadding + PaddingSizes.mainPadding,
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
            active: [DashboardPage.route, StatisticsPage.route].contains(route),
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
            active:
                [WashersPage.route, RegistrationsPage.route].contains(route),
            subItems: [
              DrawerNavigationSubItem(
                onTap: () {
                  onChange?.call(RegistrationsPage.route);
                },
                label: 'Registrations',
                active: route == RegistrationsPage.route,
              ),
            ],
          ),
          const SizedBox(
            height: PaddingSizes.smallPadding,
          ),
          DrawerNavigationItem(
            label: 'Jobs',
            onTap: () {
              onChange?.call(JobsPage.route);
            },
            iconUrl: PixelPerfectIcons.workMedium,
            active: [JobsPage.route, ApplicationsPage.route].contains(route),
            subItems: [
              DrawerNavigationSubItem(
                onTap: () {
                  onChange?.call(ApplicationsPage.route);
                },
                label: 'Applications',
                active: route == ApplicationsPage.route,
              ),
            ],
          ),
          const SizedBox(
            height: PaddingSizes.smallPadding,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: PaddingSizes.extraBigPadding + PaddingSizes.mainPadding,
              top: PaddingSizes.bigPadding,
              bottom: PaddingSizes.smallPadding,
            ),
            child: MainText(
              'SETTINGS',
              textStyleOverride: TextStyles.mainStyle.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: PaddingSizes.smallPadding,
          ),
          DrawerNavigationItem(
            label: 'Notifications',
            onTap: () {
              onChange?.call(NotificationsPage.route);
            },
            iconUrl: PixelPerfectIcons.bellMedium,
            active: NotificationsPage.route == route,
          ),
          const SizedBox(
            height: PaddingSizes.smallPadding,
          ),
          DrawerNavigationItem(
            label: 'Settings',
            onTap: () {
              onChange?.call(SettingsPage.route);
            },
            iconUrl: PixelPerfectIcons.settingsNormal,
            active: SettingsPage.route == route,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: PaddingSizes.extraBigPadding + PaddingSizes.mainPadding,
              top: PaddingSizes.bigPadding,
              bottom: PaddingSizes.smallPadding,
            ),
            child: MainText(
              'ACCOUNT',
              textStyleOverride: TextStyles.mainStyle.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: PaddingSizes.smallPadding,
          ),
          DrawerNavigationItem(
            label: 'Logout',
            hoverColor: GawTheme.error,
            iconUrl: PixelPerfectIcons.logoutMedium,
            onTap: () {
              DialogUtil.show(
                dialog: const ConfirmLogoutDialog(),
                context: context,
              );
            },
            active: false,
          ),
        ],
      ),
    );
  }
}
