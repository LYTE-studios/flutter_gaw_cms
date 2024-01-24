import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_ui/gaw_ui.dart';

final logOutProvider = StateProvider<String?>((ref) => "1hour");

const BeamPage settingsBeamPage = BeamPage(
  title: 'Settings',
  key: ValueKey('settings'),
  type: BeamPageType.noTransition,
  child: SettingsPage(),
);

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  static const String route = '/dashboard/settings';

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    String? logoutTime = ref.watch(logOutProvider);

    return BaseLayoutScreen(
      mainRoute: 'Settings',
      subRoute: 'Account settings',
      child: Column(
        children: [
          Expanded(
            child: ScreenSheet(
              topPadding: CmsHeader.headerHeight - PaddingSizes.bigPadding,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 34, vertical: 45),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const MainText("Automatically log out after"),
                        const SizedBox(width: 100),
                        DropdownInputField(
                          hint: "Select",
                          value: logoutTime,
                          options: const {
                            "1hour": "After one hour",
                            "1day": "After one day",
                            "1week": "After one week"
                          },
                        ),
                      ],
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
