import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;

  const BaseDialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 520,
        width: 860,
        decoration: BoxDecoration(
          color: GawTheme.clearBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: PaddingSizes.bigPadding,
            horizontal: PaddingSizes.extraBigPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
