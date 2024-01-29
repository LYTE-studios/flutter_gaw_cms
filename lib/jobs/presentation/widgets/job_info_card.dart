import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/routing/dashboard_router.dart';
import 'package:flutter_gaw_cms/jobs/presentation/application_review_screen.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_delete_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_details_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_edit_dialog.dart';
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
    } else if (info.state == JobState.done) {
      statusString = "Done";
      statusColour = GawTheme.text;
    }

    String abbreviation =
        (info.title ?? " ").split(" ").map((e) => e[0]).join();

    return Padding(
      padding: const EdgeInsets.all(PaddingSizes.mainPadding),
      child: Container(
        height: 280,
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
                Visibility(
                  visible: !basic,
                  child: ColorlessInkWell(
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
            const SizedBox(
              height: PaddingSizes.mainPadding,
            ),
            Expanded(
              child: MainText(
                info.description ?? "",
                alignment: TextAlign.start,
                fontSize: 12.3,
              ),
            ),
            Row(
              children: [
                _SelectedWashersWidget(
                  selectedWashers: info.selectedWashers,
                  maxWashers: info.maxWashers,
                ),
                const SizedBox(
                  width: PaddingSizes.extraBigPadding,
                ),
                Visibility(
                  visible: !basic,
                  child: Container(
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
                ),
              ],
            ),
            const SizedBox(height: PaddingSizes.bigPadding),
            basic
                ? ColorlessInkWell(
                    onTap: () {
                      dashboardRouter.beamToNamed(
                        ApplicationReviewScreen.route.replaceFirst(
                          ApplicationReviewScreen.kJobId,
                          info.id ?? '',
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: GawTheme.secondaryTint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: PaddingSizes.smallPadding,
                        ),
                        child: Row(
                          children: [
                            const Spacer(),
                            MainText(
                              'View applications for this job',
                              textStyleOverride: TextStyles.mainStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: GawTheme.clearText,
                              ),
                            ),
                            const Spacer(),
                            const Padding(
                              padding: EdgeInsets.only(
                                right: PaddingSizes.mainPadding,
                              ),
                              child: SizedBox(
                                height: 16,
                                width: 16,
                                child: SvgIcon(
                                  PixelPerfectIcons.arrowRightMedium,
                                  color: GawTheme.clearText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : info.state == JobState.done
                    ? EditButton(
                        onTap: () {
                          DialogUtil.show(
                            dialog: JobDetailsPopup(
                              job: info,
                            ),
                            context: context,
                          );
                        },
                        icon: PixelPerfectIcons.info,
                        label: "Info",
                        fontSize: 12,
                        minHeight: 35,
                        color: Colors.transparent,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          EditButton(
                            label: "Delete",
                            fontSize: 12,
                            minHeight: 35,
                            color: GawTheme.error,
                            textColor: GawTheme.clearText,
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
                            onTap: () {
                              DialogUtil.show(
                                dialog: JobEditPopup(
                                  job: info,
                                ),
                                context: context,
                              );
                            },
                            icon: PixelPerfectIcons.editNormal,
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
