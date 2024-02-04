import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/notifications/notifications_provider.dart';
import 'package:flutter_gaw_cms/core/providers/users/user_provider.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/route_description.dart';
import 'package:flutter_gaw_cms/secrets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart' as api;
import 'package:gaw_ui/gaw_ui.dart';

class CmsHeader extends ConsumerWidget {
  final String mainRoute;

  final String subRoute;

  final bool showWelcomeMessage;

  final double? heightOverride;

  const CmsHeader(
      {super.key,
      required this.mainRoute,
      required this.subRoute,
      this.showWelcomeMessage = false,
      this.heightOverride});

  static const double headerHeight = 280;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Container(
      height: heightOverride ?? CmsHeader.headerHeight,
      decoration: const BoxDecoration(color: GawTheme.secondaryTint),
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
                const LanguageButton(),
                const SizedBox(
                  width: PaddingSizes.extraBigPadding,
                ),
                const NotificationButton(),
                const SizedBox(
                  width: PaddingSizes.extraBigPadding * 2,
                ),
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
                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: MainText(
                      'Welcome back, ${user.firstName ?? ''}',
                      textStyleOverride: TextStyles.titleStyle.copyWith(
                        color: GawTheme.clearText,
                      ),
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

    EasyLocalization.of(context)?.setLocale(
      Locale(_english ? 'en' : 'nl'),
    );

    //UsersApi.updateLanguage(UpdateLanguageRequest((b) => b..language = _english ? 'en' : 'nl'));
    //loadData();
  }

  void _toggleMenu(MenuController controller) {
    if (controller.isOpen) {
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
      alignmentOffset: const Offset(0, 4),
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(1),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            _toggleLanguage();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(GawTheme.clearText),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return GawTheme.secondaryTint
                      .withOpacity(0.3); // Color for hover state
                }
                return GawTheme.clearText; // Default for other states
              },
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 0,
              right: 24,
              top: 6,
              bottom: 6,
            ),
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
          ),
        )
      ],
      builder: (context, controller, child) {
        return ColorlessInkWell(
          onTap: () => _toggleMenu(controller),
          child: Container(
            width: 80.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: GawTheme.clearText,
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

class NotificationButton extends ConsumerStatefulWidget {
  const NotificationButton({super.key});

  @override
  ConsumerState<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends ConsumerState<NotificationButton> {
  bool isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ref.watch(userProvider).profilePictureUrl;

    final notificationState = ref.watch(notificationsTickerProvider);

    return Container(
      width: 86,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: GawTheme.mainTint,
          width: 0.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ColorlessInkWell(
              onTap: () {
                setState(() => isDialogOpen = true);
                _dialogBuilder(context).whenComplete(
                  () => setState(() => isDialogOpen = false),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 42,
                    //width: 42,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        topLeft: Radius.circular(24),
                      ),
                      boxShadow:
                          isDialogOpen // Use the state to conditionally add the shadow
                              ? [
                                  Shadows.heavyShadow,
                                ]
                              : [],
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: NotificationIcon(
                        openNotifications: notificationState.notifications
                                ?.map((e) => e.seen)
                                .contains(false) ??
                            false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: PaddingSizes.extraSmallPadding,
            ),
            child: SizedBox(
              height: 36,
              width: 36,
              child: ProfilePictureAvatar(
                imageUrl: imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const double dialogHeight = 330;
    const double dialogWidth = 520;

    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Align(
          alignment: Alignment.topRight,
          child: Container(
            width: dialogWidth,
            height: dialogHeight,
            margin: EdgeInsets.only(
              top: statusBarHeight +
                  45, // Add top margin + some distance from the status bar
              right: 20, // Add right margin to distance from the screen edge
            ),
            child: const Material(
              type: MaterialType.transparency,
              child: NotificationDialog(
                dialogWidth: dialogWidth,
                dialogHeight: dialogHeight,
              ),
            ),
          ),
        );
      },
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}

class NotificationDialog extends ConsumerStatefulWidget {
  final double dialogWidth;
  final double dialogHeight;

  const NotificationDialog({
    super.key,
    required this.dialogWidth,
    required this.dialogHeight,
  });

  @override
  ConsumerState<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends ConsumerState<NotificationDialog>
    with ScreenStateMixin {
  int current = 0;
  List<api.Notification>? all;
  List<api.Notification>? archive;

  void loadData() {
    reload();
    api.NotificationsApi.readAllNotifications();
  }

  void reload() {
    setLoading(true);
    ref.read(notificationsTickerProvider.notifier)
      ..addListener((state) {
        loadArrays();
      })
      ..loadData().then((_) => setLoading(false));
  }

  void loadArrays() {
    List<api.Notification> notifications =
        ref.read(notificationsTickerProvider).notifications ?? [];
    setState(() {
      all = notifications
          .where((notification) => !notification.archived)
          .toList();
      archive =
          notifications.where((notification) => notification.archived).toList();
    });
  }

  void toggleNotificationArchive(String id, bool shouldBeArchived) async {
    final updateRequest = api.NotificationsUpdateRequest(
      (b) => b
        ..id = id
        ..seen = true // Setting seen to true by default
        ..archived = shouldBeArchived,
    );

    await api.NotificationsApi.updateNotification(request: updateRequest);
    reload();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth = widget.dialogWidth;
    final dialogHeight = widget.dialogHeight;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: dialogHeight,
        width: dialogWidth,
        decoration: BoxDecoration(
          color: GawTheme.clearText,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            Shadows.heavyShadow,
          ],
          border: const Border.fromBorderSide(Borders.lightSide),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: PaddingSizes.mainPadding + 2,
                top: PaddingSizes.bigPadding - 2,
                bottom: PaddingSizes.mainPadding - 2,
              ),
              child: MainText(
                'Notifications',
                textStyleOverride: TextStyles.titleStyle.copyWith(
                  color: GawTheme.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ), // Replace with your MainText widget
            Container(
              width: dialogWidth,
              height: dialogHeight * 0.12,
              decoration: const BoxDecoration(
                color: GawTheme.clearText,
                border: Border(
                  bottom: Borders.mainSide,
                ),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    bottom: 0,
                    left: current == 0
                        ? PaddingSizes.mainPadding
                        : PaddingSizes.mainPadding +
                            dialogWidth * 0.15 +
                            PaddingSizes.bigPadding -
                            3,
                    child: AnimatedContainer(
                      width: dialogWidth * 0.15,
                      height: dialogHeight * 0.112 - 30,
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: GawTheme.secondaryTint,
                        borderRadius: BorderRadius.circular(0.1),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: dialogWidth,
                      height: dialogHeight * 0.114,
                      decoration: const BoxDecoration(
                        color: GawTheme.clearText,
                        border: Border(
                          top: BorderSide(
                            color: GawTheme.clearText,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: PaddingSizes.mainPadding,
                      ),
                      //color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: PaddingSizes.extraBigPadding,
                          ),
                          ColorlessInkWell(
                            onTap: () {
                              setState(() {
                                current = 0;
                              });
                            },
                            child: SizedBox(
                              width: dialogWidth * 0.15,
                              child: MainText(
                                'All',
                                textStyleOverride:
                                    TextStyles.mainStyle.copyWith(
                                  color: current == 0
                                      ? GawTheme.secondaryTint
                                      : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          ColorlessInkWell(
                            onTap: () {
                              setState(() {
                                current = 1;
                              });
                            },
                            child: SizedBox(
                              width: dialogWidth * 0.15,
                              child: MainText(
                                'Archive',
                                textStyleOverride:
                                    TextStyles.mainStyle.copyWith(
                                  color: current == 1
                                      ? GawTheme.secondaryTint
                                      : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // padding: const EdgeInsets.only(
              //   bottom: PaddingSizes.mainPadding,
              // ),
              child: LoadingSwitcher(
                loading: loading,
                child: ListView.builder(
                  itemCount:
                      current == 0 ? all?.length ?? 0 : archive?.length ?? 0,
                  // Determine the number of items based on the current tab
                  itemBuilder: (context, index) {
                    // Select the list based on the current tab
                    final list = current == 0 ? all : archive;
                    final notification = list?[index];

                    if (notification != null) {
                      return CmsNotificationTile(
                        label: notification.title,
                        description: notification.body,
                        date: GawDateUtil.fromApi(notification.sent!),
                        imageUrl: notification.profilePicture,
                        notificationId: notification.id!,
                        isArchived: notification.archived,
                        onArchiveToggle: toggleNotificationArchive,
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // In case of null notification, return an empty space
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CmsNotificationTile extends StatelessWidget {
  final String label;
  final String description;
  final DateTime date;
  final String? imageUrl;
  final String notificationId;
  final bool isArchived;
  final Function(String, bool) onArchiveToggle;

  const CmsNotificationTile({
    super.key,
    required this.label,
    required this.date,
    required this.description,
    this.imageUrl,
    required this.notificationId,
    required this.isArchived,
    required this.onArchiveToggle,
  });

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      int differenceInHours = now.difference(date).inHours;
      return '${differenceInHours}h ago';
    } else if (difference > 0 && difference <= 30) {
      return '${difference}d';
    } else {
      // Handle the case for dates older than 30 days
      return 'more than 30d';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingSizes.bigPadding,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: PaddingSizes.mainPadding,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: Borders.lightSide,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.grey.shade400.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    8), // Match the parent Container's radius
                child: imageUrl != null
                    ? Image.network(
                        apiUrl + imageUrl!,
                        width: 35,
                        height: 35,
                        fit: BoxFit
                            .cover, // This ensures the image covers the bounds of the container
                      )
                    : const MainLogoSmall(),
              ),
            ),
            const SizedBox(
              width: PaddingSizes.mainPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(
                    label,
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: GawTheme.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  MainText(
                    description,
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: GawTheme.unselectedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ColorlessInkWell(
                  onTap: () => onArchiveToggle(notificationId, !isArchived),
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: SvgIcon(
                      isArchived
                          ? PixelPerfectIcons.arrowBack
                          : PixelPerfectIcons.trashMedium,
                      color: GawTheme.text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: PaddingSizes.mainPadding,
                  ),
                  child: MainText(
                    '${timeAgo(date)} ago',
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: GawTheme.unselectedText,
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
