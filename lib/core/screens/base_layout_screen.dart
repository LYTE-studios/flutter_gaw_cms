import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:gaw_ui/gaw_ui.dart';

class BaseLayoutScreen extends StatelessWidget {
  final String mainRoute;

  final String subRoute;

  final Widget child;

  const BaseLayoutScreen({
    super.key,
    required this.child,
    required this.mainRoute,
    required this.subRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GawTheme.background,
      body: Stack(
        children: [
          CmsHeader(
            mainRoute: mainRoute,
            subRoute: subRoute,
          ),
          child,
        ],
      ),
    );
  }
}
