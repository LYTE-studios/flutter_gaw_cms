import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobCreatePopup extends ConsumerWidget {
  const JobCreatePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
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
          _JobCreateForm(),
        ],
      ),
    );
  }
}

class _JobCreateForm extends StatefulWidget {
  const _JobCreateForm({super.key});

  @override
  State<_JobCreateForm> createState() => _JobCreateFormState();
}

class _JobCreateFormState extends State<_JobCreateForm> {
  final TextEditingController tecTitle = TextEditingController();
  final TextEditingController tecNeededWashers = TextEditingController();

  DateTime? applicationRecruitmentPeriodStart = DateTime.now();
  DateTime? applicationRecruitmentPeriodEnd = DateTime.now().add(
    const Duration(
      days: 365,
    ),
  );

  @override
  Widget build(BuildContext context) {
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
              child: InputTextForm(
                label: 'Needed washers for the job',
                controller: tecTitle,
                hint: 'Enter needed washers',
                number: true,
              ),
            ),
            const Spacer(),
          ],
        )
      ],
    );
  }
}
