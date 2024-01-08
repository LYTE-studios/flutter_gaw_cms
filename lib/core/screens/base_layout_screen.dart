import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:gaw_ui/gaw_ui.dart';

class BaseLayoutScreen extends StatelessWidget {
  final Widget child;

  const BaseLayoutScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GawTheme.background,
      body: Stack(
        children: [
          const CmsHeader(),
          child,
        ],
      ),
    );
  }
}
