import 'package:flutter/cupertino.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;

  const BaseDialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 360,
      decoration: BoxDecoration(
        color: GawTheme.clearBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
