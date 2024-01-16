import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class RouteDescription extends StatelessWidget {
  final String mainRoute;

  final String subRoute;

  const RouteDescription({
    super.key,
    required this.mainRoute,
    required this.subRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MainText(
          '$mainRoute / ',
          textStyleOverride: TextStyles.mainStyleTitle.copyWith(
            color: GawTheme.mainTintUnselectedText,
          ),
        ),
        MainText(
          subRoute,
          textStyleOverride:
              TextStyles.mainStyle.copyWith(color: GawTheme.mainTintText),
        ),
      ],
    );
  }
}
