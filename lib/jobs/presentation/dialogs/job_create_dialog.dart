import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/location_picker_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobCreatePopup extends ConsumerWidget {
  const JobCreatePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
      height: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: PaddingSizes.bigPadding,
              horizontal: PaddingSizes.smallPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const FormTitle(
                  label: 'Create new job',
                ),
                const Spacer(),
                GawCloseButton(
                  onClose: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const _JobCreateForm(),
        ],
      ),
    );
  }
}

class _JobCreateForm extends ConsumerStatefulWidget {
  const _JobCreateForm();

  @override
  ConsumerState<_JobCreateForm> createState() => _JobCreateFormState();
}

class _JobCreateFormState extends ConsumerState<_JobCreateForm>
    with ScreenStateMixin {
  String? customerQueryTerm;

  Map<String, String> options = {};

  void createJob({required bool isDraft}) {
    if (!validated) {
      return;
    }

    setLoading(true);

    JobsApi.createJob(
      request: CreateJobRequest(
        (b) => b
          ..title = tecTitle.text
          ..startTime = GawDateUtil.toApi(startTime!)
          ..endTime = GawDateUtil.toApi(endTime!)
          ..applicationStartTime =
              GawDateUtil.toApi(applicationRecruitmentPeriodStart)
          ..applicationEndTime =
              GawDateUtil.toApi(applicationRecruitmentPeriodEnd)
          ..customerId = customerId
          ..maxWashers = int.parse(tecNeededWashers.text)
          ..isDraft = isDraft
          ..address = address!.toBuilder()
          ..description = tecDescription.text,
      ),
    ).then((_) {
      Navigator.pop(context);
      ref.read(jobsProvider.notifier).loadData();
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(
      () => setLoading(false),
    );
  }

  Map<String, String> loadOptionsByResponse(CustomerListResponse? response) {
    if (response == null) {
      return {};
    }

    Map<String, String> customerOptions = {};

    for (Customer customer in response.customers.toList()) {
      if (customer.firstName == null || customer.lastName == null) {
        customerOptions[customer.id!] = customer.email ?? '';
      } else {
        customerOptions[customer.id!] =
            '${customer.firstName ?? ''} ${customer.lastName ?? ''}';
      }
    }

    return customerOptions;
  }

  List<Customer> knownCustomers = [];

  List<Customer> setCustomerList(List<Customer> customers) {
    for (Customer customer in customers) {
      if (!knownCustomers.contains(customer)) {
        knownCustomers.add(customer);
      }
    }

    return knownCustomers;
  }

  void getCustomerOptions() {
    if (customerQueryTerm?.isEmpty ?? true) {
      CustomerApi.getCustomers().then((CustomerListResponse? response) {
        setState(() {
          knownCustomers = setCustomerList(response?.customers.toList() ?? []);
          options = loadOptionsByResponse(response);
        });
      }).catchError((error) {
        ExceptionHandler.show(error);
      });
    } else {
      CustomerApi.getCustomersQuery(query: customerQueryTerm ?? '')
          .then((CustomerListResponse? response) {
        setState(() {
          knownCustomers = setCustomerList(response?.customers.toList() ?? []);
          options = loadOptionsByResponse(response);
        });
      }).catchError((error) {
        ExceptionHandler.show(error);
      });
    }
  }

  void validate() {
    validated = true;

    List<TextEditingController> controllers = [tecTitle, tecNeededWashers];

    for (TextEditingController controller in controllers) {
      if (controller.text.isEmpty) {
        validated = false;
      }
    }

    if (address == null) {
      validated = false;
    }

    if (customerId == null) {
      validated = false;
    }

    if (startTime == null || endTime == null) {
      validated = false;
    }

    setState(() {
      validated = validated;
    });
  }

  final TextEditingController tecTitle = TextEditingController();
  final TextEditingController tecNeededWashers = TextEditingController();
  final TextEditingController tecDescription = TextEditingController();

  Address? address;

  String? customerId;

  DateTime applicationRecruitmentPeriodStart = DateTime.now();
  DateTime applicationRecruitmentPeriodEnd = DateTime.now().add(
    const Duration(
      days: 365,
    ),
  );

  DateTime? startTime;
  DateTime? endTime;

  bool validated = false;

  @override
  Widget build(BuildContext context) {
    validate();

    return GawForm(
      rows: [
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'Title',
                controller: tecTitle,
                hint: 'Enter a job title',
              ),
            ),
            FormItem(
              child: InputTextForm(
                label: 'Needed washers for the job',
                controller: tecNeededWashers,
                hint: 'Enter needed washers',
                number: true,
              ),
            ),
            const Spacer(),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputDateRangeForm(
                label: 'Recruitment Period',
                start: applicationRecruitmentPeriodStart,
                end: applicationRecruitmentPeriodEnd,
                onUpdateDates: (DateTime start, DateTime end) {
                  setState(() {
                    applicationRecruitmentPeriodStart = start;
                    applicationRecruitmentPeriodEnd = end;
                  });
                },
                hint: 'Enter a job title',
              ),
            ),
            FormItem(
              flex: 2,
              child: InputDateTimeRangeForm(
                label: 'Job period',
                startTime: startTime,
                endTime: endTime,
                onSelectTimeRange: (DateTime start, DateTime end) {
                  startTime ??= DateTime.now();

                  start = DateTime(
                    startTime!.year,
                    startTime!.month,
                    startTime!.day,
                    start.hour,
                    start.minute,
                  );

                  end = DateTime(
                    startTime!.year,
                    startTime!.month,
                    startTime!.day,
                    end.hour,
                    end.minute,
                  );

                  if (end.millisecondsSinceEpoch <
                      start.millisecondsSinceEpoch) {
                    end = end.add(
                      const Duration(days: 1),
                    );
                  }

                  setState(() {
                    startTime = start;
                    endTime = end;
                  });
                },
                onSelectDate: (DateTime date) {
                  setState(() {
                    startTime = date;
                  });
                },
              ),
            ),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputSelectionForm(
                options: options,
                onChanged: (String? term) {
                  setState(() {
                    customerQueryTerm = term;
                  });
                  getCustomerOptions();
                },
                onSelected: (value) {
                  setState(() {
                    customerId = value as String;
                    address = knownCustomers
                        .firstWhere((customer) => customerId == customer.id)
                        .address;
                  });
                },
                label: 'Customer',
                hint: 'Choose the customer for your job',
              ),
            ),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputStaticTextForm(
                label: 'Location',
                onTap: () {
                  DialogUtil.show(
                    dialog: LocationPickerDialog(
                      address: address,
                      onAddressSelected: (Address address) {
                        setState(() {
                          this.address = address;
                        });
                      },
                    ),
                    context: context,
                  );
                },
                text: (address?.formattedAddres().isEmpty ?? true)
                    ? address?.formattedLatLong()
                    : address?.formattedAddres(),
                icon: PixelPerfectIcons.placeIndicator,
                hint: 'Location for the job',
              ),
            ),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'Description',
                hint: 'Type job description here',
                lines: 3,
                controller: tecDescription,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: PaddingSizes.mainPadding,
          ),
          child: FormRow(
            formItems: [
              Padding(
                padding: const EdgeInsets.all(
                  PaddingSizes.smallPadding,
                ),
                child: GenericButton(
                  loading: loading,
                  onTap: () => createJob(isDraft: true),
                  outline: true,
                  color: GawTheme.clearBackground,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: GawTheme.text,
                  ),
                  label: 'Save as draft',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                  PaddingSizes.smallPadding,
                ),
                child: GenericButton(
                  loading: loading,
                  color: validated
                      ? GawTheme.mainTint
                      : GawTheme.unselectedBackground,
                  onTap: () => createJob(isDraft: false),
                  minWidth: 156,
                  label: 'Save & create job',
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: GawTheme.mainTintText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
