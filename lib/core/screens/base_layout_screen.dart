import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:gaw_ui/gaw_ui.dart';

class BaseLayoutScreen extends StatelessWidget {
  final String mainRoute;

  final String subRoute;

  final Widget child;

  final Widget? actionWidget;

  final bool showWelcomeMessage;

  final double? bannerHeightOverride;

  final double extraActionButtonPadding;

  const BaseLayoutScreen({
    super.key,
    required this.child,
    required this.mainRoute,
    required this.subRoute,
    this.actionWidget,
    this.showWelcomeMessage = false,
    this.bannerHeightOverride,
    this.extraActionButtonPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GawTheme.background,
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            CmsHeader(
              heightOverride: bannerHeightOverride,
              mainRoute: mainRoute,
              subRoute: subRoute,
              showWelcomeMessage: showWelcomeMessage,
            ),
            child,
            Positioned(
              top: (bannerHeightOverride ?? CmsHeader.headerHeight) -
                  56 -
                  extraActionButtonPadding,
              right: 0,
              child: actionWidget == null
                  ? const SizedBox()
                  : SizedBox(
                      height: constraints.maxHeight -
                          (bannerHeightOverride ?? CmsHeader.headerHeight) +
                          56,
                      child: actionWidget!,
                    ),
            ),
          ],
        );
      }),
    );
  }
}
