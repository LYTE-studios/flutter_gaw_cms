import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class BaseBannerItem extends StatelessWidget {
  final Widget child;

  const BaseBannerItem({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: GawTheme.clearBackground,
        boxShadow: const [
          Shadows.mainShadow,
        ],
      ),
      child: child,
    );
  }
}
