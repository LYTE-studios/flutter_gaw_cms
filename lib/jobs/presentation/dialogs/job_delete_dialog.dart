import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobDeletePopup extends ConsumerWidget {
  const JobDeletePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
      child: Column(
        children: [
          const MainText(
            "Are you sure you want to delete this job?",
          ),
          const MainText(
              "This will delete this job permanently. You cannot undo this action."),
          Row(
            children: [
              GenericButton(
                label: "Delete",
                color: GawTheme.error,
                onTap: () {
                  // ref.read(currentlyDeletingProvider.notifier).state = null;
                  // ref.read(jobsProvider.notifier).state.remove(deleting);

                  // Force update
                  // ref
                  //     .read(jobsProvider.notifier)
                  //     .update((state) => state.toList());
                },
              ),
              const SizedBox(width: PaddingSizes.mainPadding),
              GenericButton(
                label: "Cancel",
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
