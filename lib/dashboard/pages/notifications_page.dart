import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

BeamPage notificationsBeamPage = const BeamPage(
  title: 'Notifications',
  key: ValueKey('notifications'),
  type: BeamPageType.noTransition,
  child: NotificationsPage(),
);

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  static const String route = '/dashboard/notifications';

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class NotificationInfo {
  NotificationInfo();

  String text = "";

  @override
  String toString() {
    return text;
  }
}

/// This is a map of <LanguageCode, Info>
final notificationsProvider =
    StateProvider<Map<String, NotificationInfo>>((ref) => {});

final inAppNotificationProvider = StateProvider<bool>((ref) => false);
final pushAppNotificationProvider = StateProvider<bool>((ref) => false);

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with ScreenStateMixin {
  int selectedLanguageIndex = 0;

  final Map<String, Widget> notifications = {
    "NL": const LanguageNotification(language: "NL", text: "Dutch"),
    "FR": const LanguageNotification(language: "FR", text: "French"),
    "EN": const LanguageNotification(language: "EN", text: "English"),
  };

  void pageIndexChange(int index) {
    if (index == selectedLanguageIndex) {
      return;
    }

    setState(() {
      selectedLanguageIndex = index;
    });
  }

  // Callback when user clicks the in-app notification button
  void inAppNotificationClicked(bool value) {
    ref.read(inAppNotificationProvider.notifier).state = value;
  }

  // Callback when user clicks the push-app notification button
  void pushAppNotificationClicked(bool value) {
    ref.read(pushAppNotificationProvider.notifier).state = value;
  }

  // Callback when user clicks the both button
  void bothClicked(bool value) {
    ref.read(inAppNotificationProvider.notifier).state = value;
    ref.read(pushAppNotificationProvider.notifier).state = value;
  }

  List<Widget> generateSettingButtons() {
    List<Widget> buttons = [];

    bool inApp = ref.watch(inAppNotificationProvider);
    bool pushApp = ref.watch(pushAppNotificationProvider);

    // Specify type of buttons to appear
    List<_LanguageNotificationOptions> opts = [
      _LanguageNotificationOptions(
        text: 'In-App Notification',
        callback: inAppNotificationClicked,
        value: inApp,
      ),
      _LanguageNotificationOptions(
        text: 'Push-App Notification',
        callback: pushAppNotificationClicked,
        value: pushApp,
      ),
      _LanguageNotificationOptions(
        text: 'Both',
        callback: bothClicked,
        value: inApp && pushApp,
      ),
    ];

    // Convert button specs into button widgets
    for (var opt in opts) {
      buttons.add(
        Container(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            children: [
              SizedBox(
                width: 38,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: opt.value,
                    onChanged: opt.callback,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(opt.text),
            ],
          ),
        ),
      );
    }

    return buttons;
  }

  /// Callback when user presses the 'send' button
  void onSubmit() {
    bool inApp = ref.read(inAppNotificationProvider.notifier).state;
    bool pushApp = ref.read(pushAppNotificationProvider.notifier).state;

    print("SENDING");
    print("In App: $inApp");
    print("Push App: $pushApp");
    print("Languages");
    Map<String, NotificationInfo> notifications =
        ref.read(notificationsProvider);

    NotificationInfo english = notifications['EN']!;

    setLoading(true);

    NotificationsApi.postNotification(
        request: NotificationsRequest(
      (b) => b
        ..title = 'New notification!'
        ..description = english.text
        ..isGlobal = true
        ..sendMail = false,
    )).catchError((error) {
      setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Notifications',
      subRoute: 'Notifications',
      child: Column(
        children: [
          ScreenSheet(
            topPadding: CmsHeader.headerHeight + 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 38,
                horizontal: PaddingSizes.extraBigPadding,
              ),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabbedView(
                          tabs: notifications.keys.toList(),
                          pages: notifications.values.toList(),
                          selectedIndex: selectedLanguageIndex,
                          onPageIndexChange: pageIndexChange,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 161,
                            child: GenericButton(
                              label: "Send",
                              loading: loading,
                              onTap: onSubmit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Button column
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: PaddingSizes.mainPadding,
                          left: 32,
                          right: 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: generateSettingButtons(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Structure for defining the settings buttons
/// which should show up
class _LanguageNotificationOptions {
  String text;
  ValueChanged<bool> callback;
  bool value;

  _LanguageNotificationOptions({
    required this.text,
    required this.callback,
    required this.value,
  });
}

/// Tab
class LanguageNotification extends ConsumerStatefulWidget {
  const LanguageNotification({
    super.key,
    required this.language,
    required this.text,
  });

  final String language;
  final String text;

  @override
  LanguageNotificationState createState() => LanguageNotificationState();
}

/// A tabbed menu
// class _LanguageNotification extends State<LanguageNotification> {
class LanguageNotificationState extends ConsumerState<LanguageNotification> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text =
        ref.watch(notificationsProvider)[widget.language]?.text ?? "";

    controller.addListener(() {
      ref
          .watch(notificationsProvider)
          .putIfAbsent(widget.language, () => NotificationInfo());

      ref.watch(notificationsProvider).update(widget.language, (not) {
        not.text = controller.text;
        return not;
      });
    });

    const InputBorder border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: GawTheme.unselectedBackground,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(
              PaddingSizes.mainPadding,
            ),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: widget.text,
                enabledBorder: border,
                focusedBorder: border,
              ),
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }
}
