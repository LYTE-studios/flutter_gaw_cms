import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:gaw_ui/gaw_ui.dart';

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MainText(
                'Customer profile',
                textStyleOverride: TextStyles.mainStyleTitle,
              ),
              const Spacer(),
              GestureDetector(
                child: const SizedBox(
                  width: 16,
                  height: 16,
                  child: SvgIcon(
                    PixelPerfectIcons.editNormal,
                  ),
                ),
              ),
            ],
          ),
          // // const Row(
          //   children: [
          //     // SizedBox(
          //     //   height: 120,
          //     //   width: 120,
          //     //   child: ProfilePictureAvatar(
          //     //     showCircle: true,
          //     //   ),
          //     // ),
          //     Spacer(),
          //   ],
          // ),
          // Row(
          //   children: [
          //     _LabeledField(
          //       label: 'First name',
          //       tec: TextEditingController(),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;

  final TextEditingController tec;

  final bool enabled;

  const _LabeledField({
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
