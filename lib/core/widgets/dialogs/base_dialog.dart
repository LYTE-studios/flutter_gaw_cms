import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;

  final double height;
  final double width;

  final bool dismissable;

  final Widget? topChild;

  const BaseDialog({
    super.key,
    required this.child,
    this.height = 520,
    this.width = 860,
    this.dismissable = true,
    this.topChild,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                color: GawTheme.clearText,
              ),
              child: Padding(
                padding: !dismissable
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(
                        vertical: PaddingSizes.bigPadding,
                        horizontal: PaddingSizes.extraBigPadding,
                      ),
                child: child,
              ),
            ),
          ),
          Positioned(
            right: PaddingSizes.mainPadding,
            top: PaddingSizes.mainPadding,
            child: CloseButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          if (topChild != null)
            Positioned(
              right: PaddingSizes.mainPadding + 42,
              top: PaddingSizes.mainPadding,
              child: topChild!,
            ),
        ],
      ),
    );
  }
}
