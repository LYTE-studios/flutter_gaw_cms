import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CmsAvatar extends StatelessWidget {
  final String initials;

  const CmsAvatar({
    super.key,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GawTheme.darkBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: MainText(
        initials,
        textStyleOverride: TextStyles.titleStyle.copyWith(
          color: GawTheme.clearBackground,
        ),
      ),
    );
  }
}
