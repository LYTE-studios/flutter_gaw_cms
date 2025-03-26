import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider.dart';
import 'package:flutter_gaw_cms/core/routing/dashboard_router.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/jobs/presentation/application_review_screen.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_delete_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_details_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_edit_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobInfoCard extends ConsumerStatefulWidget {
  final Job info;

  final bool basic;

  const JobInfoCard({
    required this.info,
    this.basic = false,
    super.key,
  });

  @override
  ConsumerState<JobInfoCard> createState() => _JobInfoCardState();
}

class _JobInfoCardState extends ConsumerState<JobInfoCard>
    with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    List<Widget> locations = buildLocationItems();

    String statusString = "";
    Color statusColour = GawTheme.text;

    bool isActive = false;

    if (widget.info.isDraft ?? true) {
      statusString = "Draft";
      statusColour = GawTheme.error;
    } else if (widget.info.state == JobState.pending) {
      if (GawDateUtil.fromApi(widget.info.startTime).isBefore(DateTime.now())) {
        statusString = "Active";
        statusColour = GawTheme.success;
        isActive = true;
      } else {
        statusString = "Pending";
        statusColour = GawTheme.secondaryTint;
      }
    } else if (widget.info.state == JobState.done) {
      statusString = "Done";
      statusColour = GawTheme.text;
    } else {
      statusString = "Unserviced";
      statusColour = GawTheme.error;
    }

    return Padding(
      padding: const EdgeInsets.all(PaddingSizes.mainPadding),
      child: LoadingSwitcher(
        loading: loading,
        child: Container(
          height: 240,
          width: 240,
          padding: const EdgeInsets.all(
            PaddingSizes.bigPadding,
          ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MainText(
                          widget.info.title ?? "",
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: PaddingSizes.extraSmallPadding,
                            right: PaddingSizes.bigPadding,
                          ),
                          child: MainText(
                            widget.info.address.formattedAddress(),
                            alignment: TextAlign.start,
                            fontSize: 10,
                            color: GawTheme.unselectedText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                        visible:
                            !widget.basic && (widget.info.isDraft ?? false),
                        child: ColorlessInkWell(
                          onTap: () {
                            setLoading(true);

                            JobsApi.createJob(
                              request: CreateJobRequest(
                                (b) => b
                                  ..title = widget.info.title
                                  ..startTime = widget.info.startTime
                                  ..endTime = widget.info.endTime
                                  ..applicationStartTime =
                                      widget.info.applicationStartTime
                                  ..applicationEndTime =
                                      widget.info.applicationEndTime
                                  ..customerId = widget.info.customer.id
                                  ..maxworkers = widget.info.maxWorkers
                                  ..isDraft = true
                                  ..address = widget.info.address.toBuilder()
                                  ..description = widget.info.description,
                              ),
                            ).then((_) {
                              ref.read(jobsProvider.notifier).loadData();
                            }).catchError((error) {
                              ExceptionHandler.show(error);
                            }).whenComplete(
                              () => setLoading(false),
                            );
                          },
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
                      Container(
                        alignment: Alignment.centerRight,
                        child: MainText(
                          GawDateUtil.formatDate(
                            GawDateUtil.fromApi(widget.info.startTime),
                          ),
                          textStyleOverride: TextStyles.mainStyle.copyWith(
                            color: GawTheme.secondaryTint,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ),
                      MainText(
                        GawDateUtil.formatTimeInterval(
                          GawDateUtil.fromApi(widget.info.startTime),
                          GawDateUtil.fromApi(widget.info.endTime),
                        ),
                        color: GawTheme.secondaryTint,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: PaddingSizes.mainPadding,
              ),
              Expanded(
                child: MainText(
                  widget.info.description ?? "",
                  alignment: TextAlign.start,
                  fontSize: 12.3,
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: PaddingSizes.extraSmallPadding,
                  ),
                  SelectedWashersWidget(
                    selectedWashers: widget.info.selectedWashers,
                    maxWashers: widget.info.maxWorkers,
                  ),
                  const Spacer(),
                  Visibility(
                    visible: !widget.basic,
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
              const SizedBox(
                height: PaddingSizes.smallPadding,
              ),
              [JobState.done, JobState.cancelled].contains(widget.info.state) ||
                      isActive
                  ? EditButton(
                      onTap: () {
                        DialogUtil.show(
                          dialog: JobDetailsPopup(
                            job: widget.info,
                          ),
                          context: context,
                        ).then((_) {
                          ref.read(jobsProvider.notifier).loadData();
                        });
                      },
                      icon: PixelPerfectIcons.info,
                      label: "Info",
                      fontSize: 12,
                      minHeight: 35,
                      color: GawTheme.clearText,
                    )
                  : Column(
                      children: [
                        ColorlessInkWell(
                          onTap: () {
                            dashboardRouter.beamToNamed(
                              ApplicationReviewScreen.route.replaceFirst(
                                ApplicationReviewScreen.kJobId,
                                widget.info.id ?? '',
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
                              child: Center(
                                child: MainText(
                                  'View applications for this job',
                                  textStyleOverride:
                                      TextStyles.mainStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: GawTheme.clearText,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: PaddingSizes.smallPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ColorlessInkWell(
                                onTap: () {
                                  DialogUtil.show(
                                    dialog: JobDeletePopup(
                                      id: widget.info.id!,
                                    ),
                                    context: context,
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: GawTheme.error,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: PaddingSizes.smallPadding,
                                    ),
                                    child: Center(
                                      child: MainText(
                                        'Delete',
                                        textStyleOverride:
                                            TextStyles.mainStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: GawTheme.clearText,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: PaddingSizes.smallPadding,
                            ),
                            Expanded(
                              child: ColorlessInkWell(
                                onTap: () {
                                  DialogUtil.show(
                                    dialog: JobEditPopup(
                                      job: widget.info,
                                    ),
                                    context: context,
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                    ),
                                    color: GawTheme.clearText,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: PaddingSizes.smallPadding,
                                    ),
                                    child: Center(
                                      child: MainText(
                                        'Edit',
                                        textStyleOverride:
                                            TextStyles.mainStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: GawTheme.text,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildLocationItems() {
    List<Widget> locations = [];

    for (String? addressItem in [
      widget.info.address.country,
      widget.info.address.city,
      widget.info.address.postalCode
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

class SelectedWashersWidget extends StatelessWidget {
  final int selectedWashers;

  final int maxWashers;

  const SelectedWashersWidget({
    super.key,
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
