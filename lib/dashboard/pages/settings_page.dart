import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:image_picker/image_picker.dart';

const BeamPage settingsBeamPage = BeamPage(
  title: 'Settings',
  key: ValueKey('settings'),
  type: BeamPageType.noTransition,
  child: SettingsPage(),
);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String route = '/dashboard/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? imagePath;
  String? logoutTime;
  bool showPicture = false;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imagePath == null) {
      imageWidget = Container(
        width: 120,
        height: 120,
        padding: EdgeInsets.all(PaddingSizes.bigPadding),
        child: Column(
          children: [
            Container(
              width: 26,
              height: 26,
              child: SvgIcon(
                PixelPerfectIcons.upload,
                color: Color.fromRGBO(153, 153, 153, 1),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 85,
              child: MainText(
                "Upload your photo",
                alignment: TextAlign.center,
                color: Color.fromRGBO(153, 153, 153, 1),
                textStyleOverride: TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      imageWidget = Column(
        children: [
          Container(
            width: 120,
            height: 120,
            child: Image.network(
              imagePath!,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }

    return BaseLayoutScreen(
      child: Column(
        children: [
          ScreenSheet(
            topPadding: CmsHeader.headerHeight + 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const MainText("Your Profile Picture"),
                            TextButton(
                              style: const ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                              ),
                              onPressed: () async {
                                XFile? file = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);

                                setState(() {
                                  imagePath = file?.path;
                                });
                              },
                              child: DottedBorder(
                                color: const Color.fromRGBO(202, 202, 202, 1),
                                strokeWidth: 1,
                                child: imageWidget,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MainText(
                                    "Show profile picture to washers"),
                                Switch(
                                  value: showPicture,
                                  onChanged: (bool value) {
                                    setState(() {
                                      showPicture = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MainText("Automatically log out after"),
                                DropdownButton<String>(
                                  onChanged: (String? value) {
                                    setState(() {
                                      logoutTime = value;
                                    });
                                  },
                                  value: logoutTime,
                                  items: const [
                                    DropdownMenuItem(
                                      value: "1hour",
                                      child: MainText("After one hour"),
                                    ),
                                    DropdownMenuItem(
                                      value: "1day",
                                      child: MainText("After one day"),
                                    ),
                                    DropdownMenuItem(
                                      value: "1week",
                                      child: MainText("After one week"),
                                    ),
                                  ],
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
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText("Full Name"),
                            SizedBox(height: PaddingSizes.smallPadding),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "Full Name",
                              ),
                            ),
                            SizedBox(height: PaddingSizes.extraBigPadding),
                            MainText("User Name"),
                            SizedBox(height: PaddingSizes.smallPadding),
                            TextField(
                              decoration:
                                  InputDecoration(hintText: "User Name"),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: PaddingSizes.mainPadding * 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText("Email"),
                            SizedBox(height: PaddingSizes.smallPadding),
                            TextField(
                              decoration: InputDecoration(hintText: "Email"),
                            ),
                            SizedBox(height: PaddingSizes.extraBigPadding),
                            MainText("Phone Number"),
                            SizedBox(height: PaddingSizes.smallPadding),
                            TextField(
                              decoration:
                                  InputDecoration(hintText: "Phone Number"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PaddingSizes.mainPadding * 2),
                  const MainText("Bio"),
                  const SizedBox(height: PaddingSizes.smallPadding),
                  const TextField(
                    minLines: 5,
                    decoration: InputDecoration(
                        hintText:
                            "Write your Bio here. For example, your hobbies, interests, etc."),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      GenericButton(
                          label: "Save changes",
                          color: Color.fromRGBO(53, 115, 183, 1)),
                      GenericButton(
                        label: "Cancel",
                        color: Colors.transparent,
                        textColor: Color.fromRGBO(76, 83, 95, 1),
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
