import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
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
    "ALL": const LanguageNotification(language: "ALL", text: "Any language"),
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

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Notifications',
      subRoute: 'Notifications',
      child: ScreenSheet(
        topPadding: 136,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingSizes.bigPadding * 2,
            vertical: PaddingSizes.extraBigPadding * 2,
          ),
          children: const [
            FormTitle(
              label: 'Send notification',
            ),
            FormSubTitle(
              label: 'Notification will be sent out instantly',
            ),
            SizedBox(
              height: PaddingSizes.bigPadding,
            ),
            FormRow(
              formItems: [
                SizedBox(
                  width: 520,
                  child: InputTextForm(
                    label: 'Title',
                    hint: 'Notification title...',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: PaddingSizes.mainPadding,
            ),
            FormRow(
              formItems: [
                SizedBox(
                  width: 520,
                  child: InputTextForm(
                    label: 'Description',
                    hint: 'Write a description',
                    lines: 3,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: PaddingSizes.mainPadding,
            ),
            FormRow(
              formItems: [
                SizedBox(
                  width: 520,
                  child: InputMultiSelectionForm(
                    options: {
                      'In-App notification': 0,
                      'Push notification': 1,
                      'Email': 2,
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
class LanguageNotificationState extends ConsumerState<LanguageNotification>
    with ScreenStateMixin {
  bool sendAsEmail = false;
  bool inAppNotification = true;
  bool pushNotification = false;

  /// Callback when user presses the 'send' button
  void onSubmit() {
    print("SENDING");

    setLoading(true);

    NotificationsApi.postNotification(
        request: NotificationsRequest(
      (b) => b
        ..title = tecTitle.text
        ..description = tecDescription.text
        ..isGlobal = true
        ..sendMail = sendAsEmail,
    )).catchError((error) {
      setLoading(false);
    });
  }

  final TextEditingController tecTitle = TextEditingController();
  final TextEditingController tecDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(
                  PaddingSizes.mainPadding,
                ),
                child: Column(
                  children: [
                    InputTextForm(
                      label: 'Title',
                      controller: tecTitle,
                    ),
                    const SizedBox(
                      height: PaddingSizes.smallPadding,
                    ),
                    InputTextForm(
                      lines: 4,
                      label: 'Description',
                      controller: tecDescription,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(
                  PaddingSizes.bigPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CupertinoSwitch(
                      label: 'Send as email',
                      value: sendAsEmail,
                      onUpdate: (bool value) {
                        setState(() {
                          sendAsEmail = value;
                        });
                      },
                    ),
                    _CupertinoSwitch(
                      label: 'In app notification',
                      value: inAppNotification,
                      onUpdate: (bool value) {
                        setState(() {
                          inAppNotification = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(
            PaddingSizes.bigPadding,
          ),
          child: SizedBox(
            width: 161,
            child: GenericButton(
              label: "Send",
              loading: loading,
              onTap: onSubmit,
            ),
          ),
        )
      ],
    );
  }
}

class _CupertinoSwitch extends StatelessWidget {
  final String label;

  final bool value;

  final Function(bool)? onUpdate;

  const _CupertinoSwitch({
    required this.label,
    this.value = false,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        PaddingSizes.smallPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: const Border.fromBorderSide(
            Borders.mainSide,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            PaddingSizes.smallPadding,
          ),
          child: SizedBox(
            width: 270,
            child: Row(
              children: [
                Switch(
                  hoverColor: Colors.transparent,
                  value: value,
                  onChanged: onUpdate,
                ),
                const SizedBox(
                  width: PaddingSizes.smallPadding,
                ),
                MainText(
                  label,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
