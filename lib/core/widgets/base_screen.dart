import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/menu_drawer.dart';
import 'package:gaw_ui/gaw_ui.dart';

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
          MenuDrawer(
            route: route,
            onChange: onChange,
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
                '© 2024 Get a Wash',
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
