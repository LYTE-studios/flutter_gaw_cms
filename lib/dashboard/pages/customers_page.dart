import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_gaw_cms/customers/dialogs/customer_create_dialog.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  static const String route = '/customers';

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController tecItemsPerPage = TextEditingController(
    text: 12.toString(),
  );

  final TextEditingController tecPages = TextEditingController(
    text: 1.toString(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Column(
          children: [
            CmsHeader(),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CustomerCreateDialog(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(PaddingSizes.mainPadding),
                      child: Container(
                        height: 36,
                        width: 120,
                        decoration: BoxDecoration(
                          color: GawTheme.clearBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: MainText(
                            'Add new customer',
                            textStyleOverride: TextStyles.mainStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingSizes.mainPadding,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: GawTheme.clearText,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingSizes.mainPadding,
                        ),
                        child: Container(
                          height: 56,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: Borders.mainSide,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: PaddingSizes.smallPadding,
                                ),
                                child: MainText(
                                  'Customers',
                                  textStyleOverride:
                                      TextStyles.mainStyleTitle.copyWith(
                                    fontSize: 21,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(
                                height: 24,
                                width: 24,
                                child: SvgIcon(
                                  PixelPerfectIcons.trashMedium,
                                  color: GawTheme.unselectedText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PaddingSizes.mainPadding,
                                  vertical: PaddingSizes.mainPadding,
                                ),
                                child: SizedBox(
                                  width: 180,
                                  child: TextField(
                                    decoration:
                                        InputStyles.largeDecoration.copyWith(
                                      hintText: 'Search',
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.all(
                                          PaddingSizes.smallPadding,
                                        ),
                                        child: SvgIcon(
                                          PixelPerfectIcons.zoomMedium,
                                          color: GawTheme.text,
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
                      Expanded(
                        child: ListView(
                          children: [],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingSizes.mainPadding,
                        ),
                        child: Container(
                          height: 42,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: Borders.mainSide,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 56,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: PaddingSizes.smallPadding,
                                    vertical: PaddingSizes.smallPadding,
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    style: TextStyles.mainStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                    controller: tecItemsPerPage,
                                    decoration: InputStyles.mainDecoration,
                                  ),
                                ),
                              ),
                              MainText(
                                'customers per page',
                                textStyleOverride:
                                    TextStyles.mainStyle.copyWith(
                                  color: GawTheme.unselectedText,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: PaddingSizes.smallPadding,
                              ),
                              const MainText(
                                '1-10 of 25 items',
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 56,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: PaddingSizes.smallPadding,
                                    vertical: PaddingSizes.smallPadding,
                                  ),
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    style: TextStyles.mainStyle.copyWith(
                                      fontSize: 12,
                                    ),
                                    controller: tecPages,
                                    decoration: InputStyles.mainDecoration,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PaddingSizes.extraSmallPadding,
                                ),
                                child: MainText(
                                  'of 3 pages',
                                  textStyleOverride:
                                      TextStyles.mainStyle.copyWith(
                                    color: GawTheme.unselectedText,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                                width: 12,
                                child: RotatedBox(
                                  quarterTurns: 2,
                                  child: SvgIcon(
                                    PixelPerfectIcons.arrowRightMedium,
                                    color: GawTheme.text,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                                width: 12,
                                child: SvgIcon(
                                  PixelPerfectIcons.arrowRightMedium,
                                  color: GawTheme.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
