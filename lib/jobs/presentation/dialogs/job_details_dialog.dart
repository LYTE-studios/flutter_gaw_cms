import 'package:flutter/material.dart';
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
                  label: 'Job info',
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
            Expanded(
              flex: 2,
              child: Row(
                children: [],
              ),
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
      ],
    );
  }
}
