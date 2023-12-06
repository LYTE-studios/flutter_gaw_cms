import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/banners/base_banner_item.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class CmsBanner extends StatelessWidget {
  const CmsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GawTheme.unselectedMainTint.withOpacity(0.15),
      ),
      width: 480,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: PaddingSizes.extraBigPadding * 2,
              vertical: PaddingSizes.bigPadding * 2,
            ),
            child: MainLogoBig(),
          ),
          const Spacer(),
          const SizedBox(
            height: 520,
            width: 480,
            child: _HoveringItems(),
          ),
          const Spacer(),
          SizedBox(
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
        ],
      ),
    );
  }
}

class _HoveringItems extends StatelessWidget {
  const _HoveringItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            // TODO Finish widgets
            Positioned(
              bottom: constraints.maxHeight - 180,
              left: constraints.maxWidth - 230,
              child: SizedBox(
                height: 120,
                width: 120,
                child: BaseBannerItem(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: PaddingSizes.mainPadding,
                        ),
                        child: MainText(
                          '8h',
                          textStyleOverride: TextStyles.titleStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: constraints.maxHeight / 2,
              left: constraints.maxWidth - 310,
              child: const SizedBox(
                height: 140,
                width: 200,
                child: BaseBannerItem(
                  child: SizedBox(),
                ),
              ),
            ),
            Positioned(
              bottom: constraints.maxHeight - 270,
              left: constraints.maxWidth - 130,
              child: const SizedBox(
                height: 140,
                width: 140,
                child: BaseBannerItem(
                  child: SizedBox(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
