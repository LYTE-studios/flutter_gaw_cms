import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
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

class _SettingsPageState extends ConsumerState<SettingsPage>
    with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Settings',
      subRoute: 'Account settings',
      child: ScreenSheet(
        topPadding: CmsHeader.headerHeight - PaddingSizes.bigPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            LoadingSwitcher(
              loading: loading,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 45,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormRow(
                      formItems: [
                        Expanded(
                          child: InputSelectionForm(
                            hint: "Select",
                            label: 'Automatically log out after',
                            enableText: false,
                            value: Configuration.sessionDuration?.toString() ??
                                '0',
                            onSelected: (dynamic value) async {
                              int? duration = int.tryParse(value);

                              if (duration == null) {
                                return;
                              }

                              setLoading(true);

                              if (duration == 0) {
                                duration = null;
                              }

                              await AuthenticationApi.updateExpirySession(
                                duration: duration,
                              );

                              await AuthenticationApi.testConnection();
                              setData(() {
                                loading = false;
                              });
                            },
                            options: {
                              const Duration(hours: 1).inSeconds.toString():
                                  "After one hour",
                              const Duration(days: 1).inSeconds.toString():
                                  "After one day",
                              const Duration(days: 7).inSeconds.toString():
                                  "After one week",
                              '0': "Never",
                            },
                          ),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
