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

  Worker? washer;

  void _update() {
    setLoading(true);

    WorkersApi.updateWorker(
      id: widget.washerId!,
      request: WorkerUpdateRequest(
        (b) => b
          ..firstName = tecFirstname.text
          ..lastName = tecLastName.text
          ..email = tecEmail.text
          ..phoneNumber = tecPhoneNumber.text
          ..address = address?.toBuilder()
          ..iban = tecIban.text
          ..ssn = tecSsn.text
          ..dateOfBirth = GawDateUtil.tryToApiUtc(dateOfBirth),
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

  @override
  Future<void> loadData() async {
    setLoading(true);

    WorkersApi.getWorker(id: widget.washerId!).then((Worker? washer) {
      setState(() {
        this.washer = washer;
        tecFirstname.text = washer?.firstName ?? '';
        tecLastName.text = washer?.lastName ?? '';
        tecEmail.text = washer?.email ?? '';
        tecPhoneNumber.text = washer?.phoneNumber ?? '';
        tecIban.text = washer?.iban ?? '';
        tecSsn.text = washer?.ssn ?? '';
        address = washer?.address;
        dateOfBirth = GawDateUtil.tryFromApi(washer?.dateOfBirth);
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
    text: washer?.iban,
  );

  late TextEditingController tecPhoneNumber = TextEditingController(
    text: washer?.phoneNumber,
  );

  late TextEditingController tecSsn = TextEditingController(
    text: washer?.ssn,
  );

  Address? address;

  DateTime? dateOfBirth;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 760,
      child: Padding(
        padding: const EdgeInsets.all(
          PaddingSizes.bigPadding,
        ),
        child: SingleChildScrollView(
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
                          child: InputForm(
                            label: 'Date of Birth',
                            child: GawStandaloneDatePicker(
                              date: dateOfBirth,
                              label: 'Date',
                              enabled: canEdit,
                              onUpdateDate: (DateTime? date) {
                                setState(() {
                                  dateOfBirth = date;
                                });
                              },
                            ),
                          ),
                        ),
                        FormItem(
                          child: InputTextForm(
                            label: 'SSN',
                            controller: tecSsn,
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
      ),
    );
  }
}
