import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
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

  final Map<String, Widget> notifications = {
    "NL": const LanguageNotification(),
    "FR": const LanguageNotification(),
    "EN": const LanguageNotification(),
  };

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int selectedLanguageIndex = 0;

  void pageIndexChange(int index) {
    if (index == selectedLanguageIndex) {
      return;
    }

    setState(() {
      selectedLanguageIndex = index;
    });
  }

  void onSubmit() {}

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      child: Column(
        children: [
          const SizedBox(
            height: CmsHeader.headerHeight,
          ),
          ScreenSheet(
            child: Padding(
              padding: const EdgeInsets.all(
                PaddingSizes.mainPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabbedView(
                    tabs: widget.notifications.keys.toList(),
                    pages: widget.notifications.values.toList(),
                    selectedIndex: selectedLanguageIndex,
                    onPageIndexChange: pageIndexChange,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: PaddingSizes.mainPadding),
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

class LanguageNotification extends StatefulWidget {
  const LanguageNotification({super.key});

  @override
  State<StatefulWidget> createState() => _LanguageNotification();
}

class _LanguageNotification extends State<LanguageNotification> {
  bool inAppNotificationChecked = false;
  bool pushAppNotificationChecked = false;
  String text = "";

  void inAppNotificationClicked(bool value) {
    setState(() {
      inAppNotificationChecked = value;
    });
  }

  void pushAppNotificationClicked(bool value) {
    setState(() {
      pushAppNotificationChecked = value;
    });
  }

  void bothClicked(bool value) {
    setState(() {
      pushAppNotificationChecked = value;
      inAppNotificationChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    controller.addListener(() {
      text = controller.text;
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
              controller: TextEditingController(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: PaddingSizes.mainPadding, left: 32, right: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    Switch(
                      value: inAppNotificationChecked,
                      onChanged: inAppNotificationClicked,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "In-App Notification",
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    Switch(
                      value: pushAppNotificationChecked,
                      onChanged: pushAppNotificationClicked,
                    ),
                    SizedBox(width: 20),
                    Text("Push-App Notification"),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    Switch(
                      value: pushAppNotificationChecked &&
                          inAppNotificationChecked,
                      onChanged: bothClicked,
                    ),
                    SizedBox(width: 20),
                    Text("Both"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
