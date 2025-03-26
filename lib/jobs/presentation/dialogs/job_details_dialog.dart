import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/widgets/time_registration_card.dart';
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
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: PaddingSizes.bigPadding,
              horizontal: PaddingSizes.smallPadding,
            ),
            child: FormTitle(
              label: 'Job info',
            ),
          ),
          Expanded(
            child: _JobDetailsForm(
              job: job,
            ),
          ),
        ],
      ),
    );
  }
}

class _JobDetailsForm extends ConsumerStatefulWidget {
  final Job job;

  const _JobDetailsForm({
    required this.job,
  });

  @override
  ConsumerState<_JobDetailsForm> createState() => _JobCreateFormState();
}

class _JobCreateFormState extends ConsumerState<_JobDetailsForm>
    with ScreenStateMixin {
  String? customerQueryTerm;

  List<Customer> knownCustomers = [];

  List<Customer> setCustomerList(List<Customer> customers) {
    for (Customer customer in customers) {
      if (!knownCustomers.contains(customer)) {
        knownCustomers.add(customer);
      }
    }

    return knownCustomers;
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
    text: widget.job.maxWorkers.toString(),
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

  WorkersForJobResponse? washersForJob;

  void loadData() {
    setLoading(true);

    JobsApi.getWashersForJob(jobId: widget.job.id!).then((response) {
      setState(() {
        washersForJob = response;
      });
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(() => setLoading(false));
  }

  @override
  void initState() {
    Future(() {
      loadData();
    });
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
            const Spacer(
              flex: 2,
            ),
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
                options: {
                  widget.job.customer.id: widget.job.customer.getFullName(),
                },
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
                text: (address?.formattedAddress().isEmpty ?? true)
                    ? address?.formattedLatLong()
                    : address?.formattedAddress(),
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
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(
              PaddingSizes.smallPadding,
            ),
            child: _WashersBlock(
              loading: loading,
              response: washersForJob,
              job: widget.job,
              onEditTimeRegistration: () {
                loadData();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _WashersBlock extends StatelessWidget {
  final bool loading;

  final WorkersForJobResponse? response;

  final Job? job;

  final Function()? onEditTimeRegistration;

  const _WashersBlock({
    this.loading = false,
    this.response,
    this.job,
    this.onEditTimeRegistration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 128,
      ),
      decoration: BoxDecoration(
        border: const Border.fromBorderSide(Borders.mainSide),
        borderRadius: BorderRadius.circular(12),
        color: GawTheme.clearText,
      ),
      child: LoadingSwitcher(
        loading: loading,
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: getItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> getItems() {
    List<Widget> widgets = [];

    for (Worker washer in response?.workers ?? []) {
      TimeRegistration? registration =
          response?.timeRegistrations.firstWhereOrNull(
        (item) => item.worker?.id == washer.id,
      );

      if (job == null) {
        return [];
      }

      widgets.add(
        TimeRegistrationCard(
          timeRegistration: registration,
          washer: washer,
          job: job!,
          onEdit: onEditTimeRegistration,
        ),
      );
    }

    return widgets;
  }
}
