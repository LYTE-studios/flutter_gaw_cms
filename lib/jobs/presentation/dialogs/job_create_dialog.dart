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
  @override
  Widget build(BuildContext context) {
    return GawForm(
      rows: [
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(),
            ),
          ],
        ),
      ],
    );
  }
}
