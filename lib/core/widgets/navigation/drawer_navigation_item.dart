import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class DrawerNavigationItem extends StatefulWidget {
  final String label;

  final String iconUrl;

  final bool active;

  final List<Widget>? subItems;

  final Function()? onTap;

  const DrawerNavigationItem({
    super.key,
    required this.label,
    required this.iconUrl,
    this.active = false,
    this.subItems,
    this.onTap,
  });

  @override
  State<DrawerNavigationItem> createState() => _DrawerNavigationItemState();
}

class _DrawerNavigationItemState extends State<DrawerNavigationItem>
    with TickerProviderStateMixin {
  bool hover = false;

  bool showSubItems = false;

  bool manual = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(BuildContext context) {
    showSubItems = manual ? showSubItems : widget.active;

    manual = false;

    double turns = showSubItems || hover ? 0.25 : 0;

    if (showSubItems) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return Column(
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          onTap: widget.onTap,
          onHover: (value) {
            setState(() {
              hover = value;
              manual = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(
              right:
                  PaddingSizes.extraBigPadding + PaddingSizes.extraSmallPadding,
              left:
                  PaddingSizes.extraBigPadding + PaddingSizes.extraSmallPadding,
            ),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: widget.active || hover
                    ? GawTheme.mainTint.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: PaddingSizes.extraMiniPadding,
                      left: PaddingSizes.bigPadding,
                      right: PaddingSizes.mainPadding,
                    ),
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: SvgIcon(
                        widget.iconUrl,
                        color: widget.active || hover
                            ? GawTheme.secondaryTint
                            : GawTheme.text,
                      ),
                    ),
                  ),
                  MainText(
                    widget.label,
                    color: widget.active || hover
                        ? GawTheme.secondaryTint
                        : GawTheme.text,
                  ),
                  const Spacer(),
                  Visibility(
                    visible: widget.subItems?.isNotEmpty ?? false,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          showSubItems = !showSubItems;
                          manual = true;
                        });
                        if (showSubItems) {
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(
                          PaddingSizes.mainPadding,
                        ),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: AnimatedRotation(
                            turns: turns,
                            duration: const Duration(
                              milliseconds: 200,
                            ),
                            child: SvgIcon(
                              PixelPerfectIcons.arrowRightMedium,
                              color: widget.active || hover
                                  ? GawTheme.secondaryTint
                                  : GawTheme.text,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axis: Axis.vertical,
          child: Column(
            children: widget.subItems ?? [],
          ),
        ),
      ],
    );
  }
}
