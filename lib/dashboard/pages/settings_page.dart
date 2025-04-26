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
  String oneHour = 'After one hour';
  String oneDay = 'After one day';
  String oneWeek = 'After one week';
  String never = 'Never';

  int toSeconds(String value) {
    if (value == never) {
      return 0;
    }

    if (value == oneHour) {
      return const Duration(hours: 1).inSeconds;
    }

    if (value == oneDay) {
      return const Duration(days: 1).inSeconds;
    }

    if (value == oneWeek) {
      return const Duration(days: 7).inSeconds;
    }

    return 0;
  }

  String toSelectedValue(int? value) {
    if (value == null || value == 0) {
      return never;
    }

    if (value == const Duration(hours: 1).inSeconds) {
      return oneHour;
    }

    if (value == const Duration(days: 1).inSeconds) {
      return oneDay;
    }

    if (value == const Duration(days: 7).inSeconds) {
      return oneWeek;
    }

    return '';
  }

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
                          child: InputMultiSelectionForm(
                            label: 'Automatically log out after',
                            isMulti: false,
                            selectedOptions: [
                              toSelectedValue(Configuration.sessionDuration)
                            ],
                            options: {
                              oneHour: null,
                              oneDay: null,
                              oneWeek: null,
                              never: null,
                            },
                            onUpdate: (String value) async {
                              int seconds = toSeconds(value);

                              setLoading(true);

                              await AuthenticationApi.updateExpirySession(
                                duration: seconds == 0 ? null : seconds,
                              );

                              await AuthenticationApi.testConnection();
                              setState(() {
                                loading = false;
                              });
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
