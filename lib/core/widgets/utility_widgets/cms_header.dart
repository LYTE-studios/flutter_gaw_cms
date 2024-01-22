import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/users/user_provider.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/route_description.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
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
                  Row(
                    children: [
                      RouteDescription(
                        mainRoute: mainRoute,
                        subRoute: subRoute,
                      ),
                      const Spacer(),
                      LanguageButton(),
                    ],
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

class LanguageButton extends ConsumerStatefulWidget {
  const LanguageButton({super.key});

  @override
  ConsumerState<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends ConsumerState<LanguageButton> {
  bool _english = true;
  bool _menuOpen = false;

  void loadData() {
    ref.invalidate(userProvider);
  }

  void _toggleLanguage() {
    setState(() {
      _english = !_english;
    });
    //UsersApi.updateLanguage(UpdateLanguageRequest((b) => b..language = _english ? 'en' : 'nl'));
    //loadData();
  }

  void _toggleMenu(MenuController controller) {
    if (controller.isOpen) {
      _toggleRotation();
      controller.close();
    } else {
      _toggleRotation();
      controller.open();
    }
  }

  void _toggleRotation() {
    setState(() {
      _menuOpen = !_menuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final userState = ref.watch(userProvider);

    return MenuAnchor(
      onClose: _toggleRotation,
      //onOpen: _toggleRotation,
      alignmentOffset: Offset(0, 4),
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        //surfaceTintColor: MaterialStateProperty.all(GawTheme.secondaryTint),
        elevation: MaterialStateProperty.all(1),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      anchorTapClosesMenu: true,
      //onOpen: _toggleRotation,
      menuChildren: [
        MenuItemButton(
            onPressed: () {
              _toggleLanguage();
              //_toggleRotation();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return GawTheme.secondaryTint.withOpacity(0.3); // Color for hover state
                  }
                  return Colors.white; // Default for other states
                },
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 24, top: 6, bottom: 6),
              child: SizedBox(
                width: 40,
                height: 32,
                child: SvgIcon(
                  _english
                      ? PixelPerfectIcons.netherlands
                      : PixelPerfectIcons.unitedKingdom,
                  color: Colors.transparent,
                ),
              ),
            ))
      ],
      builder: (context, controller, child) {
        return InkWell(
          hoverColor: GawTheme.secondaryTint,
          onTap: () => _toggleMenu(controller),
          child: Container(
            width: 80.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: 40,
                    height: 32,
                    child: SvgIcon(
                      !_english
                          ? PixelPerfectIcons.netherlands
                          : PixelPerfectIcons.unitedKingdom,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                RotatingIcon(
                  iconUrl: PixelPerfectIcons.arrowRightMedium,
                  rotate: _menuOpen,
                  turns: 0.5,
                  rotation: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
