import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class WasherDeleteDialog extends ConsumerStatefulWidget {
  final List<String> ids;

  const WasherDeleteDialog({
    super.key,
    required this.ids,
  });

  @override
  ConsumerState<WasherDeleteDialog> createState() => _JobDeletePopupState();
}

class _JobDeletePopupState extends ConsumerState<WasherDeleteDialog>
    with ScreenStateMixin {
  Future<void> deleteCustomers() async {
    setLoading(true);
    for (String id in widget.ids) {
      await WorkersApi.deleteWorker(
        id: id,
      );
    }

    Navigator.pop(context);

    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 180,
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.smallPadding,
              vertical: PaddingSizes.mainPadding,
            ),
            child: MainText(
              widget.ids.length == 1
                  ? "Are you sure you want to delete this washer?"
                  : "Are you sure you want to delete these washers?",
              textStyleOverride: TextStyles.titleStyle.copyWith(
                fontSize: 18,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.smallPadding,
              vertical: PaddingSizes.smallPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GenericButton(
                    label: "Delete",
                    color: GawTheme.error,
                    onTap: deleteCustomers,
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: GawTheme.mainTintText,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  width: PaddingSizes.mainPadding,
                ),
                Expanded(
                  child: GenericButton(
                    loading: loading,
                    label: "Cancel",
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
