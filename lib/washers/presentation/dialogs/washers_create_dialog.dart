import 'dart:html';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/core/widgets/forms/file_upload_form.dart';
import 'package:flutter_gaw_cms/washers/presentation/forms/washer_basic_details_form.dart';
import 'package:flutter_gaw_cms/washers/presentation/forms/washer_billing_form.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class WasherCreateDialog extends StatefulWidget {
  const WasherCreateDialog({super.key});

  @override
  State<WasherCreateDialog> createState() => _WasherCreateDialogState();
}

class _WasherCreateDialogState extends State<WasherCreateDialog>
    with TickerProviderStateMixin, ScreenStateMixin {
  final TextEditingController tecFirstName = TextEditingController();
  final TextEditingController tecLastName = TextEditingController();
  final TextEditingController tecEmail = TextEditingController();
  final TextEditingController tecPhoneNumber = TextEditingController();
  final TextEditingController tecVat = TextEditingController();

  Address? address;

  int index = 0;

  bool valid = false;

  void _next() {
    if (index == 2) {
      setLoading(true);
      WorkersApi.registerWorker(
          request: RegisterRequest(
        (b) => b
          ..firstName = tecFirstName.text
          ..lastName = tecLastName.text
          ..email = tecEmail.text,
      )).then((_) {}).catchError((error) {
        ExceptionHandler.show(error);
        Navigator.of(context).pop();
      }).whenComplete(
        () => setLoading(false),
      );

      return;
    }

    setState(() {
      index = index + 1;
    });
  }

  File? profilePicture;
  Uint8List? rawImage;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 520,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              height: 100,
              width: 720,
              child: WizardHeader(
                items: const [
                  'Information',
                  'Billing',
                  'Picture',
                ],
                selectedIndex: index,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizes.bigPadding,
              ),
              child: [
                WasherBasicDetailsForm(
                  onValidationChange: (bool value) {
                    setState(() {
                      valid = value;
                    });
                  },
                  onUpdateAddress: (Address address) {
                    setState(() {
                      this.address = address;
                    });
                  },
                  address: address,
                  tecFirstName: tecFirstName,
                  tecLastName: tecLastName,
                  tecEmail: tecEmail,
                  tecPhoneNumber: tecPhoneNumber,
                ),
                WasherBillingForm(
                  tecVat: tecVat,
                ),
                FileUploadForm(
                  onUpdateFile: (File? file, Uint8List data) {
                    setState(() {
                      profilePicture = file;
                      rawImage = data;
                    });
                  },
                  onRemoveFile: () {
                    setState(() {
                      profilePicture = null;
                      rawImage = null;
                    });
                  },
                  file: profilePicture,
                  rawData: rawImage,
                ),
              ][index],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.extraBigPadding,
            ),
            child: SizedBox(
              height: 86,
              child: Row(
                children: [
                  ColorlessInkWell(
                    onTap: !valid ? null : _next,
                    child: Container(
                      height: 42,
                      width: 156,
                      decoration: BoxDecoration(
                        color: !valid
                            ? GawTheme.unselectedMainTint
                            : GawTheme.mainTint,
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        boxShadow: const [
                          Shadows.lightShadow,
                        ],
                      ),
                      child: Center(
                        child: LoadingSwitcher(
                          loading: loading,
                          color: GawTheme.clearText,
                          child: MainText(
                            index == 2 ? 'Create' : 'Next',
                            textStyleOverride: TextStyles.titleStyle.copyWith(
                              color: GawTheme.mainTintText,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: index > 0,
                    child: ColorlessInkWell(
                      onTap: () {
                        setState(() {
                          index = index - 1;
                        });
                        return;
                      },
                      child: SizedBox(
                        width: 72,
                        child: Center(
                          child: MainText(
                            LocaleKeys.back.tr(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
