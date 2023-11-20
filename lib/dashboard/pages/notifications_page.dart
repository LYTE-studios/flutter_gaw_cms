import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

const BeamPage notificationsBeamPage = BeamPage(
  title: 'Notifications',
  key: ValueKey('notifications'),
  type: BeamPageType.noTransition,
  child: NotificationsPage(),
);

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  static const String route = '/notifications';

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int selectedLanguageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      child: Column(
        children: [
          const SizedBox(
            height: CmsHeader.headerHeight,
          ),
          Padding(
            padding: const EdgeInsets.all(
              PaddingSizes.mainPadding,
            ),
            child: TabbedView(
              tabs: const [
                'En',
                'nl',
                'Fr',
              ],
              pages: const [
                _LanguageNotification(),
                _LanguageNotification(),
                _LanguageNotification(),
              ],
              selectedIndex: selectedLanguageIndex,
              onPageIndexChange: (int index) {
                if (index == selectedLanguageIndex) {
                  return;
                }
                setState(() {
                  selectedLanguageIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageNotification extends StatelessWidget {
  const _LanguageNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
