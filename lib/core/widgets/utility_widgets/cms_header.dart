import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class CmsHeader extends StatelessWidget {
  const CmsHeader({super.key});

  static const double headerHeight = 280;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CmsHeader.headerHeight,
      decoration: const BoxDecoration(color: GawTheme.secondaryTint),
      child: Row(
        children: [],
      ),
    );
  }
}
