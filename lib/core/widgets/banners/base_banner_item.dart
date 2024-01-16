import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

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
          Shadows.bottomSheetShadow,
        ],
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
