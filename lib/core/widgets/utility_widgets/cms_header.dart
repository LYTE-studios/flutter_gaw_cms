import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/users/user_provider.dart';
import 'package:flutter_gaw_cms/core/widgets/navigation/route_description.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart' as api;
import 'package:gaw_ui/gaw_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gaw_cms/secrets.dart';

class CmsHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: heightOverride ?? CmsHeader.headerHeight,
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
                      const SizedBox(
                        width: PaddingSizes.extraBigPadding,
                      ),
                      NotificationButton(),
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
      alignmentOffset: Offset(0, 4),
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
              backgroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return GawTheme.secondaryTint
                        .withOpacity(0.3); // Color for hover state
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

class NotificationButton extends ConsumerStatefulWidget {
  const NotificationButton({super.key});

  @override
  ConsumerState<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends ConsumerState<NotificationButton> {
  bool isDialogOpen = false;
  Uint8List? bytes;

  void loadData() {
    api.UsersApi.me().then((response) {
      api.UsersApi.fetchProfilePicture(response?.profilePictureUrl ?? '')
          ?.then((response) {
        setState(() {
          bytes = response;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //loadData();
    return Container(
        width: 80,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: GawTheme.mainTint,
            width: 0.2,
          ),
        ),
        child: Row(children: [
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() => isDialogOpen = true);
              _dialogBuilder(context)
                  .whenComplete(() => setState(() => isDialogOpen = false));
            },
            child: Stack(
              children: [
                Container(
                  height: 42,
                  //width: 42,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        topLeft: Radius.circular(24)),
                    boxShadow:
                        isDialogOpen // Use the state to conditionally add the shadow
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 0,
                                  offset: Offset(0, 0),
                                ),
                              ]
                            : [],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: PaddingSizes.smallPadding),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      child: SvgIcon(
                        PixelPerfectIcons.bellMedium,
                        color: GawTheme.background.withOpacity(0.8),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
          Stack(children: [
            const Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: SizedBox(
                  height: 42,
                  width: 42,
                  // child: ProfilePictureAvatar(
                  //   bytes: bytes,
                  // ))
            ))),
            SizedBox(
              child: ProfilePictureAvatar(
                bytes: bytes,
              ),
            )
          ]),
        ]));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const dialogHeight = 330.0;
    const dialogWidth = 426.0;

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

class NotificationDialog extends StatefulWidget {
  final double dialogWidth;
  final double dialogHeight;

  const NotificationDialog({
    super.key,
    required this.dialogWidth,
    required this.dialogHeight,
  });

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  int current = 0;
  api.NotificationsListResponse? notificationListResponse;
  List<api.Notification>? all;
  List<api.Notification>? archive;

  void loadData() {
    api.UsersApi.me().then((response) {
      print(response?.profilePictureUrl);
    });
    api.NotificationsApi.getNotifications().then((response) {
      setState(() {
        notificationListResponse = response;
      });
      api.NotificationsApi.readAllNotifications();
      loadArrays();
    });
  }

  void loadArrays() {
    if (notificationListResponse != null) {
      setState(() {
        all = notificationListResponse!.notifications
            ?.where((notification) => !notification.archived)
            .toList();
        archive = notificationListResponse!.notifications
            ?.where((notification) => notification.archived)
            .toList();
      });
    }
  }

  void toggleNotificationArchive(String id, bool shouldBeArchived) async {
    try {
      final updateRequest = api.NotificationsUpdateRequest((b) => b
        ..id = id
        ..seen = true // Setting seen to true by default
        ..archived = shouldBeArchived);

      await api.NotificationsApi.updateNotification(request: updateRequest);
      loadData(); // Reload the data to reflect changes
    } catch (e) {
      // Handle exceptions, e.g., by showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update notification: $e')),
      );
    }
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
      backgroundColor: Colors.grey.shade300, //Color.fromRGBO(235, 231, 228, 1)
      surfaceTintColor: GawTheme.clearBackground,
      shadowColor: GawTheme.darkShadow, // Replace with your theme color
      elevation: 6.0, // Adjust the shadow elevation
      child: Container(
        height: dialogHeight,
        width: dialogWidth,
        decoration: BoxDecoration(
          color: GawTheme.clearBackground, //Color.fromRGBO(235, 231, 228, 1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade400, //Color.fromRGBO(235, 231, 228, 1),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: PaddingSizes.mainPadding + 2,
                  top: PaddingSizes.bigPadding - 2,
                  bottom: PaddingSizes.mainPadding - 2),
              child: MainText(
                'Notifications',
                textStyleOverride: TextStyles.mainStyle.copyWith(
                  color: Colors.black,
                  fontSize: 20.75,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ), // Replace with your MainText widget
            Container(
                width: dialogWidth,
                height: dialogHeight * 0.12,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400.withOpacity(0.6),
                ),
                child: Stack(children: [
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: dialogWidth,
                      height: dialogHeight * 0.114,
                      decoration: BoxDecoration(
                        color: GawTheme.clearBackground,
                        border: Border(
                          top: BorderSide(
                            color: GawTheme.clearBackground,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: PaddingSizes.mainPadding),
                      //color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: PaddingSizes.extraBigPadding,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                current = 0;
                              });
                            },
                            child: Container(
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
                          InkWell(
                            onTap: () {
                              setState(() {
                                current = 1;
                              });
                            },
                            child: Container(
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
                ])),
            Expanded(
                // padding: const EdgeInsets.only(
                //   bottom: PaddingSizes.mainPadding,
                // ),
                child: ListView.builder(
              itemCount: current == 0
                  ? all?.length ?? 0
                  : archive?.length ??
                      0, // Determine the number of items based on the current tab
              itemBuilder: (context, index) {
                // Select the list based on the current tab
                final list = current == 0 ? all : archive;
                final notification = list?[index];

                if (notification != null) {
                  return CmsNotificationTile(
                    label: notification.title,
                    date: DateTime.fromMillisecondsSinceEpoch(
                        notification.sent! *
                            1000), // Assuming 'sent' is in seconds
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
            ))
          ],
        ),
      ),
    );
  }
}

class CmsNotificationTile extends StatelessWidget {
  final String label;
  final DateTime date;
  final String? imageUrl;
  final String notificationId;
  final bool isArchived;
  final Function(String, bool) onArchiveToggle;

  const CmsNotificationTile({
    super.key,
    required this.label,
    required this.date,
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
        horizontal: 26,
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: PaddingSizes.mainPadding,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade400.withOpacity(0.6),
                width: 1,
              ),
            ),
          ),
          child: Row(children: [
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
                    : const SizedBox(
                        width: 35,
                        height: 35,
                      ),
              ),
            ),
            const SizedBox(
              width: PaddingSizes.smallPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(
                    label,
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  MainText(
                    timeAgo(date),
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => onArchiveToggle(notificationId, !isArchived),
              child: SizedBox(
                height: 20,
                width: 20,
                child: SvgIcon(
                  PixelPerfectIcons.trashMedium,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            )
          ])),
    );
  }
}
