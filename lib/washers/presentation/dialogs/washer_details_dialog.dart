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
  RegistrationOnboardingData? registrationData;

  bool isJobTypeExpanded = true;
  bool isSituationExpanded = true;
  bool isLocationsExpanded = true;
  bool isWorkTimesExpanded = true;

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

  Future<void> loadData() async {
    setLoading(true);

    try {
      Worker? worker = await WorkersApi.getWorker(id: widget.washerId!);
      setState(() {
        washer = worker;
        tecFirstname.text = worker?.firstName ?? '';
        tecLastName.text = worker?.lastName ?? '';
        tecEmail.text = worker?.email ?? '';
        tecPhoneNumber.text = worker?.phoneNumber ?? '';
        tecIban.text = worker?.iban ?? '';
        tecSsn.text = worker?.ssn ?? '';
        address = worker?.address;
        dateOfBirth = GawDateUtil.tryFromApi(worker?.dateOfBirth);
      });
    } catch (error) {
      ExceptionHandler.show(error);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadRegistrationData() async {
    setLoading(true);

    try {
      RegistrationOnboardingData? data =
          await AuthenticationApi.getWorkerRegistrationData(
        widget.washerId!,
      );

      setState(() {
        registrationData = data;
      });
    } catch (error) {
      // Set empty lists to prevent null errors
      setState(() {
        registrationData = null;
      });
    } finally {
      setLoading(false);
    }
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
      loadRegistrationData();
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
                  const MainText(
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
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: GawTheme.unselectedText.withOpacity(0.4),
                    width: 1.0,
                  ),
                ),
              ),
              child: TabBar(
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
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
                          children: registrationData?.jobTypes
                                  .map((e) => _DisplayItem(
                                      value: e.name, extra: e.mastery.name))
                                  .toList() ??
                              [],
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
                          children: registrationData?.workTypes
                                  .map(
                                    (e) => _DisplayItem(
                                      value: e.name,
                                    ),
                                  )
                                  .toList() ??
                              [],
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
                          children: registrationData?.locations
                                  .map(
                                    (e) => _DisplayItem(
                                      value: e.name,
                                    ),
                                  )
                                  .toList() ??
                              [],
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
    required List<Widget> children,
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
              child: Wrap(
                children: children,
              ),
            ),
        ],
      ),
    );
  }
}

class _DisplayItem extends StatelessWidget {
  final String value;
  final String? extra;

  const _DisplayItem({
    super.key,
    required this.value,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingSizes.mainPadding,
        vertical: PaddingSizes.smallPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: GawTheme.unselectedText.withOpacity(0.3),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: PaddingSizes.smallPadding,
            horizontal: PaddingSizes.mainPadding,
          ),
          child: MainText(
            '$value${extra == null ? '' : ' - $extra'}',
            textStyleOverride: TextStyles.mainStyle.copyWith(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
