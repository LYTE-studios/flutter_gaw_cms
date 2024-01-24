import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobDeletePopup extends ConsumerStatefulWidget {
  final String id;

  const JobDeletePopup({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<JobDeletePopup> createState() => _JobDeletePopupState();
}

class _JobDeletePopupState extends ConsumerState<JobDeletePopup>
    with ScreenStateMixin {
  void deleteJob() {
    if (loading) {
      return;
    }
    setLoading(true);

    JobsApi.deleteJob(
      id: widget.id,
    ).then((_) {
      Navigator.pop(context);
      ref.read(jobsProvider.notifier).loadData();
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(
      () => setLoading(false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 240,
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.mainPadding,
              vertical: PaddingSizes.mainPadding,
            ),
            child: MainText(
              "Are you sure you want to delete this job?",
              textStyleOverride: TextStyles.titleStyle.copyWith(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.mainPadding,
              vertical: PaddingSizes.bigPadding,
            ),
            child: MainText(
              "This will delete this job permanently. You cannot undo this action.",
              textStyleOverride: TextStyles.mainStyleTitle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.mainPadding,
              vertical: PaddingSizes.bigPadding,
            ),
            child: Row(
              children: [
                GenericButton(
                  label: "Delete",
                  color: GawTheme.error,
                  onTap: deleteJob,
                  minWidth: 156,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: GawTheme.mainTintText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  width: PaddingSizes.mainPadding,
                ),
                GenericButton(
                  loading: loading,
                  label: "Cancel",
                  minWidth: 156,
                  outline: true,
                  color: GawTheme.clearBackground,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: GawTheme.text,
                  ),
                  onTap: () {
                    if (loading) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
