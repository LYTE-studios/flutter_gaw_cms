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
    with ScreenStateMixin, SingleTickerProviderStateMixin {
  bool canEdit = false;
  late TabController _tabController;
  Worker? washer;

  bool isJobTypeExpanded = false;
  bool isSituationExpanded = false;
  bool isLocationsExpanded = false;
  bool isWorkTimesExpanded = false;

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

  void loadData() {
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
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    Future(() {
      loadData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 760,
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
                    textStyleOverride: TextStyles.titleStyle,
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
                height: 100,
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
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'General Info'),
                      Tab(text: 'Onboarding Information'),
                    ],
                    labelColor: GawTheme.text,
                    unselectedLabelColor: GawTheme.unselectedText,
                    indicatorColor: GawTheme.mainTint,
                    indicatorWeight: 2.0,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: TextStyles.mainStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyles.mainStyle.copyWith(
                      color: GawTheme.unselectedText,
                      fontWeight: FontWeight.w600,
                    ),
                    isScrollable: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // General Info Tab
                  SingleChildScrollView(
                    child: LoadingSwitcher(
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
                                    textStyleOverride:
                                        TextStyles.mainStyle.copyWith(
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
                                    textStyleOverride:
                                        TextStyles.mainStyle.copyWith(
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
                  ),
                  // Onboarding Information Tab
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Job Type Section
                        _buildExpandableSection(
                          title: 'Job Type',
                          isExpanded: isJobTypeExpanded,
                          onToggle: () {
                            setState(() {
                              isJobTypeExpanded = !isJobTypeExpanded;
                            });
                          },
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: const [
                              Chip(
                                label: Text(
                                  'Car Washing - Intermediate',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  'Waiter - Beginner',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  'Cleaning - Skilled',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  'Other - Expert',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Situation Section
                        _buildExpandableSection(
                          title: 'Situation',
                          isExpanded: isSituationExpanded,
                          onToggle: () {
                            setState(() {
                              isSituationExpanded = !isSituationExpanded;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PaddingSizes.smallPadding,
                              vertical: PaddingSizes.smallPadding,
                            ),
                            child: Text(
                              'Situation details go here.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),

                        // Locations Section
                        _buildExpandableSection(
                          title: 'Locations',
                          isExpanded: isLocationsExpanded,
                          onToggle: () {
                            setState(() {
                              isLocationsExpanded = !isLocationsExpanded;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PaddingSizes.smallPadding,
                              vertical: PaddingSizes.smallPadding,
                            ),
                            child: Text(
                              'Location details go here.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),

                        // Work Times Section
                        _buildExpandableSection(
                          title: 'Work Times',
                          isExpanded: isWorkTimesExpanded,
                          onToggle: () {
                            setState(() {
                              isWorkTimesExpanded = !isWorkTimesExpanded;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PaddingSizes.smallPadding,
                              vertical: PaddingSizes.smallPadding,
                            ),
                            child: Text(
                              'Work time details go here.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: PaddingSizes.smallPadding,
        horizontal: PaddingSizes.mainPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizes.mainPadding,
                vertical: PaddingSizes.smallPadding,
              ),
              decoration: BoxDecoration(
                color: GawTheme.clearBackground,
                border:
                    Border.all(color: GawTheme.unselectedText.withOpacity(0.3)),
                borderRadius:
                    BorderRadius.circular(8), // Always rounded on all sides
              ),
              child: Row(
                children: [
                  MainText(
                    title,
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: GawTheme.text,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            const SizedBox(height: 8), // Increased space between boxes
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(PaddingSizes.mainPadding),
              decoration: BoxDecoration(
                color: GawTheme.clearBackground,
                border:
                    Border.all(color: GawTheme.unselectedText.withOpacity(0.3)),
                borderRadius:
                    BorderRadius.circular(8), // Always rounded on all sides
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}
