import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobDetailsDialog extends ConsumerWidget {
  final Job job;

  const JobDetailsDialog({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget title;
    bool draft = job.isDraft ?? true;
    if (draft) {
      title = const PopupTitleText(
        "Job Draft",
        icon: SvgImage(PixelPerfectIcons.editNormal),
      );
    } else {
      title = const PopupTitleText(
        "Job Info",
        icon: SvgImage(PixelPerfectIcons.info),
      );
    }

    Widget footer = Container();

    if (draft) {
      footer = Column(
        children: [
          const SizedBox(height: 41),
          Row(
            children: [
              GenericButton(
                label: "Save",
                onTap: () {},
              ),
              const SizedBox(width: PaddingSizes.mainPadding),
              GenericButton(
                label: "Cancel",
                onTap: () {},
              ),
            ],
          ),
        ],
      );
    }

    return BaseDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: title,
              ),
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: const SvgIcon(
                    PixelPerfectIcons.xNormal,
                    color: GawTheme.text,
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
