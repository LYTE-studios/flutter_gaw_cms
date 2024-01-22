import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/banners/base_banner_item.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CmsBanner extends StatelessWidget {
  const CmsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GawTheme.unselectedMainTint.withOpacity(0.15),
      ),
      width: 480,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: PaddingSizes.extraBigPadding * 2,
                vertical: PaddingSizes.bigPadding * 2,
              ),
              child: MainLogoBig(),
            ),
          ),
          const Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 520,
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
                  '© 2023 GET-A-WASH',
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    fontSize: 12,
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

class _HoveringItems extends StatelessWidget {
  const _HoveringItems();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: 64,
          left: 140,
          child: SizedBox(
            height: 120,
            width: 120,
            child: BaseBannerItem(
              child: SizedBox(
                height: 96,
                width: 96,
                child: SvgImage(
                  'assets/images/banner/banner_item_1.svg',
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 208,
          left: 90,
          child: SizedBox(
            height: 140,
            width: 200,
            child: BaseBannerItem(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: PaddingSizes.bigPadding,
                ),
                child: SvgImage(
                  'assets/images/banner/banner_item_3.svg',
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 136,
          left: 240,
          child: SizedBox(
            height: 140,
            width: 140,
            child: BaseBannerItem(
              child: Padding(
                padding: EdgeInsets.all(
                  PaddingSizes.mainPadding,
                ),
                child: SvgImage(
                  'assets/images/banner/banner_item_2.svg',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
