import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class LoadingSwitcher extends StatelessWidget {
  final bool loading;

  final Widget child;

  final Color? backgroundColor;

  const LoadingSwitcher({
    super.key,
    this.loading = true,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 200,
      ),
      child: loading
          ? Container(
              color: backgroundColor ?? GawTheme.background,
              child: const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: GawTheme.mainTint,
                  ),
                ),
              ),
            )
          : child,
    );
  }
}
