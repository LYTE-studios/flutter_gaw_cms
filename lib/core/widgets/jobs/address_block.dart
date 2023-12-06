import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class AddressBlock extends StatelessWidget {
  final String label;

  const AddressBlock({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(
        PaddingSizes.smallPadding,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingSizes.smallPadding,
        vertical: PaddingSizes.extraSmallPadding,
      ),
      decoration: BoxDecoration(
        color: GawTheme.mainTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MainText(
        label,
        color: GawTheme.clearBackground,
      ),
    );
  }
}
