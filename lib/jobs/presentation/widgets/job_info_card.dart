import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_delete_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobInfoCard extends ConsumerWidget {
  final Job info;

  final bool basic;

  const JobInfoCard({
    required this.info,
    this.basic = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> locations = buildLocationItems();

    String statusString = "";
    Color statusColour = GawTheme.text;

    if (info.isDraft ?? true) {
      statusString = "Draft";
      statusColour = GawTheme.error;
    } else if (info.state == JobState.pending) {
      statusString = "Active";
      statusColour = GawTheme.success;
    }

    String abbreviation =
        (info.title ?? " ").split(" ").map((e) => e[0]).join();

    return Padding(
      padding: const EdgeInsets.all(PaddingSizes.mainPadding),
      child: Container(
        width: 307,
        padding: const EdgeInsets.all(PaddingSizes.extraBigPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: GawTheme.clearText,
          border: Border.all(color: GawTheme.background),
          boxShadow: const [
            Shadows.heavyShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: GawTheme.darkBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: MainText(
                    abbreviation,
                    color: GawTheme.clearText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                basic
                    ? _SelectedWashersWidget(
                        selectedWashers: info.selectedWashers,
                        maxWashers: info.maxWashers,
                      )
                    : ColorlessInkWell(
                        onTap: () {},
                        child: MainText(
                          "duplicate draft",
                          textStyleOverride: TextStyles.mainStyle.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                            color: GawTheme.unselectedText,
                          ),
                        ),
                      ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: MainText(
                GawDateUtil.formatDate(
                  GawDateUtil.fromApi(info.startTime),
                ),
                textStyleOverride: TextStyles.mainStyle.copyWith(
                  color: GawTheme.secondaryTint,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  info.title ?? "",
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                MainText(
                  GawDateUtil.formatTimeInterval(
                    GawDateUtil.fromApi(info.startTime),
                    GawDateUtil.fromApi(info.startTime),
                  ),
                  color: GawTheme.secondaryTint,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ],
            ),
            const SizedBox(
              height: PaddingSizes.mainPadding,
            ),
            Row(
              children: locations,
            ),
            const SizedBox(height: PaddingSizes.bigPadding),
            MainText(info.description ?? "", fontSize: 12.3),
            const SizedBox(height: PaddingSizes.bigPadding),
            Row(
              children: [
                _SelectedWashersWidget(
                  selectedWashers: info.selectedWashers,
                  maxWashers: info.maxWashers,
                ),
                const SizedBox(width: PaddingSizes.extraBigPadding),
                Container(
                  width: 72,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.fromBorderSide(
                      Borders.mainSide.copyWith(
                        color: statusColour,
                        width: 1.8,
                      ),
                    ),
                  ),
                  child: MainText(
                    statusString,
                    textStyleOverride: TextStyles.mainStyle.copyWith(
                      color: statusColour,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: PaddingSizes.bigPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GenericButton(
                  label: "Delete",
                  fontSize: 12,
                  minHeight: 35,
                  color: GawTheme.error,
                  onTap: () {
                    DialogUtil.show(
                      dialog: JobDeletePopup(
                        id: info.id!,
                      ),
                      context: context,
                    );
                  },
                ),
                EditButton(
                  onTap: () {},
                  label: "Edit",
                  fontSize: 12,
                  minHeight: 35,
                  color: Colors.transparent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildLocationItems() {
    List<Widget> locations = [];

    for (String? addressItem in [
      info.address.country,
      info.address.city,
      info.address.postalCode
    ]) {
      if (addressItem != null) {
        locations.add(
          AddressButton(label: addressItem),
        );
      }
    }
    return locations;
  }
}

class _SelectedWashersWidget extends StatelessWidget {
  final int selectedWashers;

  final int maxWashers;

  const _SelectedWashersWidget({
    required this.selectedWashers,
    required this.maxWashers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 21,
          height: 21,
          child: SvgIcon(
            PixelPerfectIcons.customUsers,
            color: GawTheme.text,
          ),
        ),
        const SizedBox(width: PaddingSizes.extraSmallPadding),
        MainText(
          "$selectedWashers/$maxWashers",
        ),
      ],
    );
  }
}
