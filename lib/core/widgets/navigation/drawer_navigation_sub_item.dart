import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class DrawerNavigationSubItem extends StatefulWidget {
  final String label;

  final bool active;

  final Function()? onTap;

  const DrawerNavigationSubItem({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  State<DrawerNavigationSubItem> createState() =>
      _DrawerNavigationSubItemState();
}

class _DrawerNavigationSubItemState extends State<DrawerNavigationSubItem> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: widget.onTap,
      onHover: (value) {
        setState(() {
          hover = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: PaddingSizes.extraBigPadding + PaddingSizes.mainPadding,
        ),
        child: SizedBox(
          height: 36,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical:
                      PaddingSizes.mainPadding - PaddingSizes.extraSmallPadding,
                  horizontal: PaddingSizes.bigPadding,
                ),
                child: VerticalDivider(
                  width: 4,
                  thickness: 2,
                  color: widget.active || hover
                      ? GawTheme.secondaryTint
                      : GawTheme.unselectedText,
                ),
              ),
              MainText(
                widget.label,
                color: widget.active || hover
                    ? GawTheme.secondaryTint
                    : GawTheme.text,
              )
            ],
          ),
        ),
      ),
    );
  }
}
