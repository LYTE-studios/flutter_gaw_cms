import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_ui/gaw_ui.dart';

BeamPage notificationsBeamPage = BeamPage(
  title: 'Notifications',
  key: const ValueKey('notifications'),
  type: BeamPageType.noTransition,
  child: NotificationsPage(),
);

class NotificationsPage extends StatefulWidget {
  NotificationsPage({super.key});

  static const String route = '/dashboard/notifications';

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class NotificationInfo {
  NotificationInfo();

  bool inAppNotificationChecked = false;
  bool pushAppNotificationChecked = false;
  String text = "";
}

final notificationsProvider =
    StateProvider<Map<String, NotificationInfo>>((ref) => {});

class _NotificationsPageState extends State<NotificationsPage> {
  int selectedLanguageIndex = 0;

  final Map<String, Widget> notifications = {
    "NL": const LanguageNotification(language: "NL"),
    "FR": const LanguageNotification(language: "FR"),
    "EN": const LanguageNotification(language: "EN"),
  };

  void pageIndexChange(int index) {
    if (index == selectedLanguageIndex) {
      return;
    }

    setState(() {
      selectedLanguageIndex = index;
    });
  }

  /// Callback when user presses the 'send' button
  Future<void> onSubmit() async {
    // TODO: implement
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      child: Column(
        children: [
          const SizedBox(
            height: CmsHeader.headerHeight + 8,
          ),
          ScreenSheet(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 38,
                horizontal: PaddingSizes.extraBigPadding,
              ),
              child: Column(
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
                      child: GenericButton(label: "Send", onTap: onSubmit),
                    ),
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
  });

  final String language;

  @override
  _LanguageNotification createState() => _LanguageNotification();
}

/// A tabbed menu
// class _LanguageNotification extends State<LanguageNotification> {
class _LanguageNotification extends ConsumerState<LanguageNotification> {
  // Callback when user clicks the in-app notification button
  void inAppNotificationClicked(bool value, WidgetRef ref) {
    Map<String, NotificationInfo> infos = ref.read(notificationsProvider);

    infos.update(widget.language, (not) {
      not.inAppNotificationChecked = value;
      return not;
    });

    ref.watch(notificationsProvider.notifier).state = infos;
  }

  // Callback when user clicks the push-app notification button
  void pushAppNotificationClicked(bool value, WidgetRef ref) {
    ref.watch(notificationsProvider).update(widget.language, (not) {
      not.pushAppNotificationChecked = value;
      return not;
    });
  }

  // Callback when user clicks the both button
  void bothClicked(bool value, WidgetRef ref) {
    ref.watch(notificationsProvider).update(widget.language, (not) {
      not.pushAppNotificationChecked = value;
      not.inAppNotificationChecked = value;
      return not;
    });
  }

  List<Widget> generateSettingButtons(WidgetRef ref) {
    List<Widget> buttons = [];

    Map<String, NotificationInfo> infos = ref.watch(notificationsProvider);
    infos.putIfAbsent(widget.language, () => NotificationInfo());

    NotificationInfo info = infos[widget.language]!;

    // Specify type of buttons to appear
    List<_LanguageNotificationOptions> opts = [
      _LanguageNotificationOptions(
        text: 'In-App Notification',
        callback: (bool value) => inAppNotificationClicked(value, ref),
        value: info.inAppNotificationChecked,
      ),
      _LanguageNotificationOptions(
        text: 'Push-App Notification',
        callback: (bool value) => pushAppNotificationClicked(value, ref),
        value: info.pushAppNotificationChecked,
      ),
      _LanguageNotificationOptions(
        text: 'Both',
        callback: (bool value) => bothClicked(value, ref),
        value: info.inAppNotificationChecked && info.pushAppNotificationChecked,
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

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text =
        ref.watch(notificationsProvider)[widget.language]?.text ?? "";
    controller.addListener(() {
      ref.watch(notificationsProvider).update(widget.language, (not) {
        not.text = controller.text;
        return not;
      });
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(
              PaddingSizes.mainPadding,
            ),
            child: AppInputField(
              hint: "Text",
              controller: controller,
            ),
          ),
        ),
        // Button column
        Padding(
          padding: const EdgeInsets.only(
            top: PaddingSizes.mainPadding,
            left: 32,
            right: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: generateSettingButtons(ref),
          ),
        ),
      ],
    );
  }
}
