import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:image_picker/image_picker.dart';

final imagePathProvider = StateProvider<String?>((ref) => null);
final showPictureProvider = StateProvider<bool>((ref) => false);
final logOutProvider = StateProvider<String?>((ref) => null);
final fullNameProvider = StateProvider<String>((ref) => "");
final userNameProvider = StateProvider<String>((ref) => "");
final emailProvider = StateProvider<String>((ref) => "");
final phoneNumberProvider = StateProvider<String>((ref) => "");
final bioProvider = StateProvider<String>((ref) => "");

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
  void cancel() {
    // TODO: implement
  }

  void save() {
    // TODO: implement
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    String? imagePath = ref.watch(imagePathProvider);

    if (imagePath == null) {
      imageWidget = Container(
        width: 120,
        height: 120,
        padding: const EdgeInsets.all(PaddingSizes.bigPadding),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: SvgIcon(
                PixelPerfectIcons.upload,
                color: GawTheme.toolBarItem,
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: 85,
              child: MainText(
                "Upload your photo",
                alignment: TextAlign.center,
                fontSize: 11,
                color: GawTheme.toolBarItem,
              ),
            ),
          ],
        ),
      );
    } else {
      imageWidget = Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    }

    bool showPicture = ref.watch(showPictureProvider);
    String? logoutTime = ref.watch(logOutProvider);

    // Text inputs
    String fullName = ref.read(fullNameProvider);
    String userName = ref.read(userNameProvider);
    String email = ref.read(emailProvider);
    String phoneNumber = ref.read(phoneNumberProvider);
    String bio = ref.read(bioProvider);

    return BaseLayoutScreen(
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        child: Column(
          children: [
            ScreenSheet(
              topPadding: CmsHeader.headerHeight + 8,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 34, vertical: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const MainText("Your Profile Picture"),
                              const SizedBox(height: PaddingSizes.mainPadding),
                              TextButton(
                                style: const ButtonStyle(
                                  padding:
                                      MaterialStatePropertyAll(EdgeInsets.zero),
                                  overlayColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                ),
                                onPressed: () async {
                                  XFile? file = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);

                                  ref.watch(imagePathProvider.notifier).state =
                                      file?.path;
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: GawTheme.unselectedBackground,
                                  dashPattern: const [4.5, 4.5],
                                  radius: const Radius.circular(12),
                                  strokeWidth: 1,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: GawTheme.clearBackground,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: imageWidget,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const MainText(
                                      "Show profile picture to washers"),
                                  SwitchInputField(
                                      callback: (bool value) {
                                        ref
                                            .watch(showPictureProvider.notifier)
                                            .state = value;
                                      },
                                      value: showPicture),
                                ],
                              ),
                              const SizedBox(height: PaddingSizes.mainPadding),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const MainText("Automatically log out after"),
                                  DropdownInputField(
                                    hint: "Select",
                                    value: logoutTime,
                                    options: const {
                                      "1hour": "After one hour",
                                      "1day": "After one day",
                                      "1week": "After one week"
                                    },
                                    callback: (String? value) {
                                      ref.read(logOutProvider.notifier).state =
                                          value;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 38),
                    const Divider(),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const MainText("Full Name", fontSize: 14.5),
                              const SizedBox(height: PaddingSizes.smallPadding),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: "Full Name"),
                                controller:
                                    TextEditingController(text: fullName),
                                onChanged: (String value) {
                                  ref.watch(fullNameProvider.notifier).state =
                                      value;
                                },
                              ),
                              const SizedBox(
                                  height: PaddingSizes.extraBigPadding),
                              const MainText("User Name", fontSize: 14.5),
                              const SizedBox(height: PaddingSizes.smallPadding),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: "User Name"),
                                controller:
                                    TextEditingController(text: userName),
                                onChanged: (String value) {
                                  ref.watch(userNameProvider.notifier).state =
                                      value;
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: PaddingSizes.mainPadding * 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const MainText("Email", fontSize: 14.5),
                              const SizedBox(height: PaddingSizes.smallPadding),
                              TextField(
                                decoration:
                                    const InputDecoration(hintText: "Email"),
                                controller: TextEditingController(text: email),
                                onChanged: (String value) {
                                  ref.watch(emailProvider.notifier).state =
                                      value;
                                },
                              ),
                              const SizedBox(
                                  height: PaddingSizes.extraBigPadding),
                              const MainText("Phone Number", fontSize: 14.5),
                              const SizedBox(height: PaddingSizes.smallPadding),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: "Phone Number"),
                                controller:
                                    TextEditingController(text: phoneNumber),
                                onChanged: (String value) {
                                  ref
                                      .watch(phoneNumberProvider.notifier)
                                      .state = value;
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PaddingSizes.mainPadding * 2),
                    const MainText("Bio"),
                    const SizedBox(height: PaddingSizes.smallPadding),
                    TextField(
                      minLines: 5,
                      decoration: const InputDecoration(
                          hintText:
                              "Write your Bio here. For example, your hobbies, interests, etc."),
                      maxLines: null,
                      controller: TextEditingController(text: bio),
                      onChanged: (String value) {
                        ref.watch(bioProvider.notifier).state = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GenericButton(
                          label: "Save changes",
                          color: GawTheme.mainTint,
                          onTap: save,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36),
                        ),
                        GenericButton(
                          label: "Cancel",
                          color: Colors.transparent,
                          textColor: GawTheme.darkBackground,
                          onTap: cancel,
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
