import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/location_picker_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class WasherDetailsDialog extends StatefulWidget {
  final String? washerId;

  const WasherDetailsDialog({
    super.key,
    this.washerId,
  });

  @override
  State<WasherDetailsDialog> createState() => _WasherDetailsFormState();
}

class _WasherDetailsFormState extends State<WasherDetailsDialog>
    with ScreenStateMixin {
  bool canEdit = false;

  Washer? washer;

  void _update() {
    setLoading(true);

    WashersApi.updateWasher(
      id: widget.washerId!,
      request: WasherUpdateRequest(
        (b) => b
          ..firstName = tecFirstname.text
          ..lastName = tecLastName.text
          ..email = tecEmail.text
          ..phoneNumber = tecPhoneNumber.text
          ..address = address?.toBuilder()
          ..taxNumber = tecIban.text,
      ),
    ).then((_) {
      loadData();
      setState(() {
        canEdit = false;
      });
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(
      () => setLoading(false),
    );
  }

  void loadData() {
    setLoading(true);

    WashersApi.getWasher(id: widget.washerId!).then((Washer? washer) {
      setState(() {
        this.washer = washer;
        tecFirstname.text = washer?.firstName ?? '';
        tecLastName.text = washer?.lastName ?? '';
        tecEmail.text = washer?.email ?? '';
        tecPhoneNumber.text = washer?.phoneNumber ?? '';
        tecIban.text = washer?.taxNumber ?? '';
        address = washer?.address;
      });
    }).catchError(
      (error) {
        ExceptionHandler.show(error);
      },
    ).whenComplete(() => setLoading(false));
  }

  late TextEditingController tecFirstname = TextEditingController(
    text: washer?.firstName,
  );

  late TextEditingController tecLastName = TextEditingController(
    text: washer?.lastName,
  );

  late TextEditingController tecEmail = TextEditingController(
    text: washer?.email,
  );

  late TextEditingController tecIban = TextEditingController(
    text: washer?.taxNumber,
  );

  late TextEditingController tecPhoneNumber = TextEditingController(
    text: washer?.phoneNumber,
  );

  Address? address;

  @override
  void initState() {
    Future(() {
      loadData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 680,
      child: Padding(
        padding: const EdgeInsets.all(
          PaddingSizes.bigPadding,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                PaddingSizes.mainPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MainText(
                    'Washer profile',
                    textStyleOverride: TextStyles.mainStyleTitle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: PaddingSizes.mainPadding,
                    ),
                    child: ColorlessInkWell(
                      onTap: () {
                        setState(() {
                          canEdit = !canEdit;
                        });
                      },
                      child: const SizedBox(
                        width: 21,
                        height: 21,
                        child: SvgIcon(
                          PixelPerfectIcons.editNormal,
                          color: GawTheme.text,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: PaddingSizes.bigPadding,
              ),
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: Borders.mainSide,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: ProfilePictureAvatar(
                      canEdit: true,
                      showCircle: true,
                      imageUrl: FormattingUtil.formatUrl(
                        washer?.profilePictureUrl,
                      ),
                      onEditPressed: () {
                        setLoading(true);

                        FilePicker.platform
                            .pickFiles(
                          type: FileType.image,
                        )
                            .then((FilePickerResult? result) {
                          if (result?.files.isEmpty ?? true) {
                            setLoading(false);

                            return;
                          }

                          UsersApi.uploadProfilePicture(
                            result!.files[0].bytes!,
                            userId: washer!.id,
                          ).then((_) {
                            loadData();
                          }).catchError((error) {
                            ExceptionHandler.show(error);
                          }).whenComplete(() => setLoading(false));
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            LoadingSwitcher(
              loading: loading,
              child: GawForm(
                rows: [
                  FormRow(
                    formItems: [
                      FormItem(
                        child: InputTextForm(
                          label: 'First name',
                          controller: tecFirstname,
                          frozen: !canEdit,
                        ),
                      ),
                      FormItem(
                        child: InputTextForm(
                          label: 'Last name',
                          controller: tecLastName,
                          frozen: !canEdit,
                        ),
                      ),
                      FormItem(
                        flex: 2,
                        child: InputTextForm(
                          label: 'Email',
                          controller: tecEmail,
                          frozen: !canEdit,
                        ),
                      ),
                    ],
                  ),
                  FormRow(
                    formItems: [
                      FormItem(
                        child: InputTextForm(
                          label: 'IBAN',
                          controller: tecIban,
                          frozen: !canEdit,
                        ),
                      ),
                      FormItem(
                        child: InputTextForm(
                          label: 'Phone number',
                          controller: tecPhoneNumber,
                          frozen: !canEdit,
                        ),
                      ),
                    ],
                  ),
                  FormRow(
                    formItems: [
                      FormItem(
                        flex: 2,
                        child: InputStaticTextForm(
                          label: 'Address',
                          onTap: () {
                            if (!canEdit) {
                              return;
                            }
                            DialogUtil.show(
                              dialog: LocationPickerDialog(
                                onAddressSelected: (Address address) {
                                  setState(() {
                                    this.address = address;
                                  });
                                },
                              ),
                              context: context,
                            );
                          },
                          frozen: !canEdit,
                          text: address?.formattedAddress(),
                          icon: PixelPerfectIcons.placeIndicator,
                          hint: 'Washer address',
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: canEdit,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: PaddingSizes.bigPadding,
                        left: PaddingSizes.mainPadding,
                        right: PaddingSizes.mainPadding,
                        bottom: PaddingSizes.mainPadding,
                      ),
                      child: FormRow(
                        formItems: [
                          GenericButton(
                            label: 'Save changes',
                            onTap: () {
                              if (loading) {
                                return;
                              }
                              _update();
                            },
                            loading: loading,
                            textStyleOverride: TextStyles.mainStyle.copyWith(
                              color: GawTheme.clearText,
                            ),
                          ),
                          const SizedBox(
                            width: PaddingSizes.mainPadding,
                          ),
                          GenericButton(
                            outline: true,
                            label: 'Cancel',
                            color: GawTheme.clearText,
                            textColor: GawTheme.text,
                            textStyleOverride: TextStyles.mainStyle.copyWith(
                              fontSize: 12,
                            ),
                            onTap: () {
                              setState(() {
                                canEdit = false;
                              });
                              loadData();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
