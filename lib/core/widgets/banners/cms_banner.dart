import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/banners/base_banner_item.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CmsBanner extends StatelessWidget {
  const CmsBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      constraints: const BoxConstraints(
        minWidth: 480,
      ),
      decoration: const BoxDecoration(
        color: GawTheme.mainTint,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: -91,
            left: -180,
            child: SizedBox(
              height: 720,
              width: 540,
              child: MainLogoSmall(
                fit: BoxFit.fitHeight,
                color: GawTheme.secondaryTint.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 720,
              ),
              height: height,
              child: _HoveringItems(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 56,
              child: Center(
                child: MainText(
                  '© ${DateTime.now().year} GET-A-WASH',
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    fontSize: 12,
                    color: GawTheme.clearText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoveringItems extends StatefulWidget {
  const _HoveringItems();

  @override
  State<_HoveringItems> createState() => _HoveringItemsState();
}

class _HoveringItemsState extends State<_HoveringItems> {
  double x1 = 0;
  double y1 = 0;

  double x2 = 0;
  double y2 = 0;

  double x3 = 0;
  double y3 = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: (MediaQuery.of(context).size.width / 20) - y1,
            left: (MediaQuery.of(context).size.width / 6) - x1,
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 10,
              width: MediaQuery.of(context).size.width / 9,
              child: LayoutBuilder(builder: (context, constraints) {
                return MouseRegion(
                  cursor: MouseCursor.uncontrolled,
                  onExit: (_) {
                    setState(() {
                      x1 = 0;
                      y1 = 0;
                    });
                  },
                  onHover: (PointerHoverEvent event) {
                    setState(() {
                      x1 = event.localPosition.dx - (constraints.maxWidth / 2);
                      y1 = event.localPosition.dy - (constraints.maxHeight / 2);
                    });
                  },
                  child: const BaseBannerItem(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: PaddingSizes.mainPadding,
                      ),
                      child: SvgImage(
                        'assets/images/banner/banner_item_1.svg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: (MediaQuery.of(context).size.width / 6) - y2,
            left: (MediaQuery.of(context).size.width / 8) - x2,
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 9,
              width: MediaQuery.of(context).size.width / 6,
              child: LayoutBuilder(builder: (context, constraints) {
                return MouseRegion(
                  cursor: MouseCursor.uncontrolled,
                  onExit: (_) {
                    setState(() {
                      x2 = 0;
                      y2 = 0;
                    });
                  },
                  onHover: (PointerHoverEvent event) {
                    setState(() {
                      x2 = event.localPosition.dx - (constraints.maxWidth / 2);
                      y2 = event.localPosition.dy - (constraints.maxHeight / 2);
                    });
                  },
                  child: const BaseBannerItem(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: PaddingSizes.bigPadding,
                      ),
                      child: SvgImage(
                        'assets/images/banner/banner_item_3.svg',
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: (MediaQuery.of(context).size.width / 8) - y3,
            left: (MediaQuery.of(context).size.width / 4) - x3,
            child: MouseRegion(
              child: SizedBox(
                height: MediaQuery.of(context).size.width / 10,
                width: MediaQuery.of(context).size.width / 10,
                child: LayoutBuilder(builder: (context, constraints) {
                  return MouseRegion(
                    cursor: MouseCursor.uncontrolled,
                    onExit: (_) {
                      setState(() {
                        x3 = 0;
                        y3 = 0;
                      });
                    },
                    onHover: (PointerHoverEvent event) {
                      setState(() {
                        x3 =
                            event.localPosition.dx - (constraints.maxWidth / 2);
                        y3 = event.localPosition.dy -
                            (constraints.maxHeight / 2);
                      });
                    },
                    child: const BaseBannerItem(
                      child: Padding(
                        padding: EdgeInsets.all(
                          PaddingSizes.mainPadding,
                        ),
                        child: SvgImage(
                          'assets/images/banner/banner_item_2.svg',
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      );
    });
  }
}
