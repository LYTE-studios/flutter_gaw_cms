import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobCreatePopup extends ConsumerWidget {
  JobCreatePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget footer = Row(
      children: [
        GenericButton(
          onTap: () {},
          label: "Create",
        ),
        GenericButton(
          onTap: () {},
          label: "Safe as draft",
        ),
      ],
    );

    return BaseDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PopupTitleText("Create Job"),
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: const SvgIcon(
                    PixelPerfectIcons.xNormal,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          footer,
        ],
      ),
    );
  }
}
