import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobDetailsPopup extends ConsumerWidget {
  final Job job;

  const JobDetailsPopup({
    super.key,
    required this.job,
  });

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
                  label: 'Edit job',
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
          _JobCreateForm(
            job: job,
          ),
        ],
      ),
    );
  }
}

class _JobCreateForm extends ConsumerStatefulWidget {
  final Job job;

  const _JobCreateForm({
    required this.job,
  });

  @override
  ConsumerState<_JobCreateForm> createState() => _JobCreateFormState();
}

class _JobCreateFormState extends ConsumerState<_JobCreateForm>
    with ScreenStateMixin {
  String? customerQueryTerm;

  late Map<String, String> options = widget.job.customer.id == null
      ? {}
      : {
          widget.job.customer.id!:
              '${widget.job.customer.firstName ?? ''} ${widget.job.customer.lastName ?? ''}'
        };

  void createJob({required bool isDraft}) {
    if (!validated) {
      return;
    }

    setLoading(true);

    JobsApi.updateJob(
      id: widget.job.id!,
      request: UpdateJobRequest(
        (b) => b
          ..title = tecTitle.text
          ..startTime = GawDateUtil.toApi(startTime!)
          ..endTime = GawDateUtil.toApi(endTime!)
          ..applicationStartTime =
              GawDateUtil.toApi(applicationRecruitmentPeriodStart!)
          ..applicationEndTime =
              GawDateUtil.toApi(applicationRecruitmentPeriodEnd!)
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

    if (applicationRecruitmentPeriodStart == null ||
        applicationRecruitmentPeriodEnd == null) {
      validated = false;
    }

    if (startTime == null || endTime == null) {
      validated = false;
    }

    setState(() {
      validated = validated;
    });
  }

  late final TextEditingController tecTitle = TextEditingController(
    text: widget.job.title,
  )..addListener(validate);
  late final TextEditingController tecNeededWashers = TextEditingController(
    text: widget.job.maxWashers.toString(),
  )..addListener(validate);
  late final TextEditingController tecDescription = TextEditingController(
    text: widget.job.description,
  )..addListener(validate);

  late Address? address = widget.job.address;

  late String? customerId = widget.job.customer.id;

  late DateTime? applicationRecruitmentPeriodStart =
      GawDateUtil.tryFromApi(widget.job.applicationStartTime);
  late DateTime? applicationRecruitmentPeriodEnd =
      GawDateUtil.tryFromApi(widget.job.applicationEndTime);

  late DateTime? startTime = GawDateUtil.tryFromApi(widget.job.startTime);
  late DateTime? endTime = GawDateUtil.tryFromApi(widget.job.endTime);

  bool validated = true;

  @override
  void initState() {
    super.initState();
  }

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
                frozen: true,
                controller: tecTitle,
                hint: 'Enter a job title',
              ),
            ),
            FormItem(
              child: InputTextForm(
                label: 'Needed washers for the job',
                frozen: true,
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
                enabled: false,
                label: 'Recruitment Period',
                start: applicationRecruitmentPeriodStart,
                end: applicationRecruitmentPeriodEnd,
                hint: 'Enter a job title',
              ),
            ),
            FormItem(
              flex: 2,
              child: InputDateTimeRangeForm(
                enabled: false,
                label: 'Job period',
                startTime: startTime,
                endTime: endTime,
              ),
            ),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputSelectionForm(
                options: options,
                enabled: false,
                value: widget.job.customer.id,
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
                frozen: true,
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
                frozen: true,
                controller: tecDescription,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
