import 'package:beamer/beamer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
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

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with ScreenStateMixin {
  bool validated = false;

  String? getLanguageCode() {
    if (language == all) {
      return null;
    }

    if (language == english) {
      return 'en';
    } else {
      return 'nl';
    }
  }

  void validate() {
    validated = true;

    if (tecTitle.text.isEmpty) {
      validated = false;
    }

    if (tecDescription.text.isEmpty) {
      validated = false;
    }

    if (selectedTypes.isEmpty) {
      validated = false;
    }
    if (language?.isEmpty ?? true) {
      validated = false;
    }
    setState(() {
      validated = validated;
    });
  }

  void send() {
    validate();

    if (!validated) {
      return;
    }

    setLoading(true);

    NotificationsApi.postNotification(
      request: NotificationsRequest(
        (b) => b
          ..title = tecTitle.text
          ..description = tecDescription.text
          ..sendNotification = selectedTypes.contains(inApp)
          ..sendPush = selectedTypes.contains(push)
          ..sendMail = selectedTypes.contains(email)
          ..language = getLanguageCode(),
      ),
    ).then((_) {
      setState(() {
        tecTitle.text = '';
        tecDescription.text = '';
        selectedTypes = [];
        language = null;
      });
      validate();
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(() => setLoading(false));
  }

  String english = 'English';
  String dutch = 'Dutch';
  String all = 'All';
  String inApp = 'In-App notification';
  String push = 'Push notification';
  String email = 'Email';

  late final TextEditingController tecTitle = TextEditingController()
    ..addListener(() {
      setState(() {});
    });
  late final TextEditingController tecDescription = TextEditingController()
    ..addListener(() {
      setState(() {});
    });

  List<String> selectedTypes = [];

  String? language;

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Notifications',
      subRoute: 'Notifications',
      child: ScreenSheet(
        topPadding: 136,
        child: ListView(
          shrinkWrap: false,
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.only(
            left: PaddingSizes.bigPadding * 2,
            right: PaddingSizes.bigPadding * 2,
            top: PaddingSizes.extraBigPadding * 2,
            bottom: 256,
          ),
          children: [
            const FormTitle(
              label: 'Send notification',
            ),
            const FormSubTitle(
              label: 'Notification will be sent out instantly',
            ),
            const SizedBox(
              height: PaddingSizes.bigPadding,
            ),
            FormRow(
              formItems: [
                SizedBox(
                  width: 520,
                  child: InputTextForm(
                    label: 'Title',
                    controller: tecTitle,
                    hint: 'Notification title...',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: PaddingSizes.mainPadding,
            ),
            FormRow(
              formItems: [
                SizedBox(
                  width: 520,
                  child: InputTextForm(
                    label: 'Description',
                    controller: tecDescription,
                    hint: 'Write a description',
                    lines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: PaddingSizes.mainPadding,
            ),
            FormRow(
              formItems: [
                SizedBox(
                  width: 520,
                  child: InputMultiSelectionForm(
                    label: 'Notification type',
                    onUpdate: (String value) {
                      if (selectedTypes.contains(value)) {
                        setState(() {
                          selectedTypes.remove(value);
                        });
                        validate();

                        return;
                      }
                      setState(() {
                        selectedTypes.add(value);
                      });
                      validate();
                    },
                    selectedOptions: selectedTypes,
                    options: {
                      inApp: const SvgImage(
                        PixelPerfectIcons.customInApp,
                        fit: BoxFit.fitHeight,
                      ),
                      push: const SvgImage(
                        PixelPerfectIcons.customPush,
                        fit: BoxFit.fitHeight,
                      ),
                      email: const SvgImage(
                        PixelPerfectIcons.customMail,
                        fit: BoxFit.fitHeight,
                      ),
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: PaddingSizes.mainPadding,
            ),
            FormRow(
              formItems: [
                SizedBox(
                  width: 520,
                  child: InputMultiSelectionForm(
                    label: 'Language',
                    isMulti: false,
                    onUpdate: (String value) {
                      setState(() {
                        language = value;
                      });
                      validate();
                    },
                    selectedOptions: language == null ? [] : [language!],
                    options: {
                      all: null,
                      english: const SvgImage(
                        PixelPerfectIcons.unitedKingdom,
                        fit: BoxFit.fitHeight,
                      ),
                      dutch: const SvgImage(
                        PixelPerfectIcons.netherlands,
                        fit: BoxFit.fitHeight,
                      ),
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: PaddingSizes.extraBigPadding,
            ),
            FormRow(
              formItems: [
                GenericButton(
                  loading: loading,
                  minWidth: 108,
                  label: 'Send',
                  onTap: send,
                  icon: PixelPerfectIcons.customSend,
                  textColor: GawTheme.clearText,
                  color: !validated
                      ? GawTheme.unselectedMainTint
                      : GawTheme.mainTint,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: GawTheme.mainTintText,
                  ),
                ),
                const SizedBox(
                  width: PaddingSizes.mainPadding,
                ),
                GenericButton(
                  loading: loading,
                  outline: true,
                  minWidth: 96,
                  onTap: () {
                    setState(() {
                      tecTitle.text = '';
                      tecDescription.text = '';
                      selectedTypes = [];
                      language = null;
                    });
                    validate();
                  },
                  textColor: GawTheme.unselectedText,
                  color: GawTheme.clearBackground,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: GawTheme.text,
                  ),
                  label: 'Clear all',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
