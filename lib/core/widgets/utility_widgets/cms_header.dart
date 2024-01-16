import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/route_description.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CmsHeader extends StatelessWidget {
  final String mainRoute;

  final String subRoute;

  final bool showWelcomeMessage;

  const CmsHeader({
    super.key,
    required this.mainRoute,
    required this.subRoute,
    this.showWelcomeMessage = false,
  });

  static const double headerHeight = 280;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CmsHeader.headerHeight,
      decoration: const BoxDecoration(color: GawTheme.secondaryTint),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: PaddingSizes.extraBigPadding + PaddingSizes.smallPadding,
                top: PaddingSizes.bigPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RouteDescription(
                    mainRoute: mainRoute,
                    subRoute: subRoute,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Visibility(
                    visible: showWelcomeMessage,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          'Welcome back, Stieg',
                          textStyleOverride: TextStyles.titleStyle.copyWith(
                            color: GawTheme.clearText,
                          ),
                        ),
                        MainText(
                          GawDateUtil.formatReadableDate(
                            DateTime.now(),
                          ),
                          textStyleOverride: TextStyles.mainStyle.copyWith(
                            color: GawTheme.mainTintUnselectedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 240,
          ),
        ],
      ),
    );
  }
}
