import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class CustomerDetailDialog extends StatefulWidget {
  final String? customerId;

  const CustomerDetailDialog({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerDetailDialog> createState() => _CustomerDetailDialogState();
}

class _CustomerDetailDialogState extends State<CustomerDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Padding(
        padding: const EdgeInsets.all(
          PaddingSizes.bigPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MainText(
                  'Customer profile',
                  textStyleOverride: TextStyles.mainStyleTitle,
                ),
                GestureDetector(
                  child: const SvgIcon(
                    PixelPerfectIcons.editNormal,
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 120,
                width: 120,
                child: ProfilePictureAvatar(
                  showCircle: true,
                ),
              ),
            ),
            Row(
              children: [
                _LabeledField(
                  label: 'First name',
                  tec: TextEditingController(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;

  final TextEditingController tec;

  final bool enabled;

  const _LabeledField({
    super.key,
    required this.label,
    required this.tec,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText(
          label,
          textStyleOverride: TextStyles.mainStyleTitle,
        ),
        CmsInputField(
          controller: tec,
          enabled: enabled,
        ),
      ],
    );
  }
}
