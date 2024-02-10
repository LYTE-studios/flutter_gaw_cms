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

    if (widget.info.isDraft ?? true) {
      statusString = "Draft";
      statusColour = GawTheme.error;
    } else if (widget.info.state == JobState.pending) {
      statusString = "Active";
      statusColour = GawTheme.success;
    } else if (widget.info.state == JobState.done) {
      statusString = "Done";
      statusColour = GawTheme.text;
    }

    return Padding(
      padding: const EdgeInsets.all(PaddingSizes.mainPadding),
      child: LoadingSwitcher(
        loading: loading,
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
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: InitialsAvatar(
                      isBlock: true,
                      initials: widget.info.customer.initials ?? '',
                      imageUrl: FormattingUtil.formatUrl(
                        widget.info.customer.profilePictureUrl,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !widget.basic && (widget.info.isDraft ?? false),
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
                              ..maxWashers = widget.info.maxWashers
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
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainText(
                    widget.info.title ?? "",
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  MainText(
                    GawDateUtil.formatTimeInterval(
                      GawDateUtil.fromApi(widget.info.startTime),
                      GawDateUtil.fromApi(widget.info.startTime),
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
                  widget.info.description ?? "",
                  alignment: TextAlign.start,
                  fontSize: 12.3,
                ),
              ),
              Row(
                children: [
                  _SelectedWashersWidget(
                    selectedWashers: widget.info.selectedWashers,
                    maxWashers: widget.info.maxWashers,
                  ),
                  const SizedBox(
                    width: PaddingSizes.extraBigPadding,
                  ),
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
              const SizedBox(height: PaddingSizes.bigPadding),
              widget.basic
                  ? ColorlessInkWell(
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
                          child: Row(
                            children: [
                              const Spacer(),
                              MainText(
                                'View applications for this job',
                                textStyleOverride:
                                    TextStyles.mainStyle.copyWith(
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
                  : widget.info.state == JobState.done
                      ? EditButton(
                          onTap: () {
                            DialogUtil.show(
                              dialog: JobDetailsPopup(
                                job: widget.info,
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
                                    id: widget.info.id!,
                                  ),
                                  context: context,
                                );
                              },
                            ),
                            EditButton(
                              onTap: () {
                                DialogUtil.show(
                                  dialog: JobEditPopup(
                                    job: widget.info,
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
