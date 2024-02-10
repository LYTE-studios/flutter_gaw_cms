import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;

  final double height;
  final double width;

  const BaseDialog({
    super.key,
    required this.child,
    this.height = 520,
    this.width = 860,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: GawTheme.clearText,
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
