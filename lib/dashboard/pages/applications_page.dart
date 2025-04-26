import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/application_details_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/tabs/job_tiles_tab.dart';
import 'package:flutter_gaw_cms/washers/presentation/dialogs/washer_history_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

const BeamPage applicationsBeamPage = BeamPage(
  title: 'Applications',
  key: ValueKey('applications'),
  type: BeamPageType.noTransition,
  child: ApplicationsPage(),
);

class ApplicationsPage extends ConsumerStatefulWidget {
  const ApplicationsPage({super.key});

  static const String route = '/dashboard/washers/applications';

  @override
  ConsumerState<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends ConsumerState<ApplicationsPage>
    with ScreenStateMixin {
  final OverlayPortalController controller = OverlayPortalController();

  DateIntervalSelectable? selectable = DateIntervalSelectable.thisYear;

  late PickerDateRange? range = selectable?.getDateRange();

  late DateTime? startTime = range?.startDate;

  late DateTime? endTime = range?.endDate;

  @override
  Widget build(BuildContext context) {
    final jobsProviderState = ref.watch(jobsProvider);

    List<Job> jobs = jobsProviderState.upcomingJobs?.jobs?.toList() ?? [];

    return BaseLayoutScreen(
      mainRoute: 'Jobs',
      subRoute: 'Applications',
      child: LayoutBuilder(builder: (context, constraints) {
        return OverlayPortal(
          controller: controller,
          overlayChildBuilder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    right: PaddingSizes.mainPadding,
                  ),
                  child: SizedBox(
                    height: constraints.maxHeight - 128,
                    width: 400,
                    child: CmsDateRangePicker(
                      selectable: selectable,
                      initialStart: startTime,
                      initialEnd: endTime,
                      onUpdateSelectable: (DateIntervalSelectable? selectable) {
                        if (selectable == null) {
                          setState(() {
                            this.selectable = null;
                          });
                          return;
                        }
                        if (selectable == this.selectable) {
                          setState(() {
                            this.selectable = null;
                            startTime = null;
                            endTime = null;
                          });
                          return;
                        }

                        PickerDateRange range = selectable.getDateRange();

                        setState(() {
                          this.selectable = selectable;
                          startTime = range.startDate!;
                          endTime = range.endDate!;
                        });
                      },
                      onUpdateDates: (startTime, endTime) {
                        controller.toggle();

                        ref.read(jobsProvider.notifier).reloadUpcomingJobs(
                              startTime: startTime,
                              endTime: endTime,
                            );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          child: GestureDetector(
            onTap: () {
              if (!controller.isShowing) {
                return;
              }
              controller.toggle();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 64,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingSizes.smallPadding,
                  ),
                  child: SizedBox(
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Spacer(),
                        CmsExpandableDateRangePicker(
                          toggleExpand: controller.toggle,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ScreenSheet(
                    topPadding: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: Borders.lightSide,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: PaddingSizes.mainPadding,
                                horizontal: PaddingSizes.bigPadding,
                              ),
                              child: MainText(
                                'All jobs up for application',
                                textStyleOverride:
                                    TextStyles.titleStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: JobTilesTab(
                            loading: ref.watch(jobsProvider).loading,
                            jobs: jobs,
                            basicView: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ApplicationsListView extends StatefulWidget {
  final bool fullView;

  final bool isJobSpecific;

  final String? jobId;

  const ApplicationsListView({
    super.key,
    this.fullView = true,
    this.isJobSpecific = true,
    this.jobId,
  });

  @override
  State<ApplicationsListView> createState() => _ApplicationsListViewState();
}

class _ApplicationsListViewState extends State<ApplicationsListView>
    with ScreenStateMixin {
  ApplicationListResponse? applicationsListResponse;


  @override
  Future<void> loadData() async {
    setLoading(true);

    JobsApi.getApplications(jobId: widget.jobId).then((response) {
      setState(() {
        applicationsListResponse = response;
      });
    }).catchError((error) {
      ExceptionHandler.show(error);
    }).whenComplete(
      () => setLoading(false),
    );
  }

  void onSelected(JobApplication application) {
    DialogUtil.show(
      dialog: ApplicationDetailsDialog(
        application: application,
      ),
      context: context,
    ).then((_) => loadData());
  }

  @override
  Widget build(BuildContext context) {
    return GenericListView(
      loading: loading,
      title: LocaleKeys.applications.tr(),
      valueName: LocaleKeys.applications.tr().toLowerCase(),
      totalItems: 0,
      showFooter: widget.fullView,
      showHeader: widget.fullView || widget.jobId != null,
      header: BaseListHeader(
        items: {
          const BaseHeaderItem(
            label: 'Washer name',
          ): ListUtil.xLColumn,
          BaseHeaderItem(
            label: !widget.isJobSpecific ? 'Job Date' : 'Date',
          ): ListUtil.mColumn,
          BaseHeaderItem(
            label: !widget.isJobSpecific ? 'Job title' : 'Region',
          ): ListUtil.lColumn,
          const BaseHeaderItem(
            label: 'Notes',
          ): ListUtil.sColumn,
          const BaseHeaderItem(
            label: 'Distance',
          ): ListUtil.sColumn,
        },
      ),
      rows: applicationsListResponse?.applications.map(
            (application) {
              String? distance = GeoUtil.formatDistance(application.distance);
              if (application.noTravelCosts) {
                distance = '($distance)';
              }

              return InkWell(
                onTap: () {
                  onSelected(application);
                },
                child: BaseListItem(
                  items: {
                    ProfileRowItem(
                      onTap: () {
                        DialogUtil.show(
                          dialog: WasherHistoryDialog(
                            washerId: application.worker.id!,
                          ),
                          context: context,
                        );
                      },
                      firstName: application.worker.firstName,
                      lastName: application.worker.lastName,
                      imageUrl: FormattingUtil.formatUrl(
                        application.worker.profilePictureUrl,
                      ),
                    ): ListUtil.xLColumn,
                    TextRowItem(
                      value: GawDateUtil.tryFormatReadableDate(
                        GawDateUtil.tryFromApi(
                          !widget.isJobSpecific
                              ? application.job.startTime
                              : application.createdAt,
                        ),
                      ),
                    ): ListUtil.mColumn,
                    !widget.isJobSpecific
                        ? TextRowItem(
                            value: application.job.title,
                          )
                        : SelectableTextRowItem(
                            value: application.address.city ??
                                application.address.postalCode,
                          ): ListUtil.lColumn,
                    BaseRowItem(
                      child: Visibility(
                        visible: application.note?.isNotEmpty ?? false,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 21,
                            width: 21,
                            child: SvgIcon(
                              PixelPerfectIcons.customCopy,
                              color: GawTheme.unselectedText,
                            ),
                          ),
                        ),
                      ),
                    ): ListUtil.sColumn,
                    TextRowItem(
                      value: distance,
                    ): ListUtil.sColumn,
                    BaseRowItem(
                      child: Row(
                        children: [
                          const Spacer(),
                          Visibility(
                            visible: application.state ==
                                JobApplicationState.approved,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: PaddingSizes.mainPadding,
                              ),
                              child: ApprovedStateBlock(),
                            ),
                          ),
                          Visibility(
                            visible: application.state ==
                                JobApplicationState.rejected,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: PaddingSizes.mainPadding,
                              ),
                              child: RejectedStateBlock(),
                            ),
                          ),
                          Visibility(
                            visible: application.state ==
                                    JobApplicationState.pending &&
                                application.job.selectedWashers <
                                    application.job.maxWorkers,
                            child: SizedBox(
                              width: 128,
                              child: _ApprovalButton(
                                label: 'Approve',
                                icon: PixelPerfectIcons.checkMedium,
                                backgroundColor: GawTheme.mainTint,
                                textColor: GawTheme.clearText,
                                onTap: () {
                                  setLoading(true);

                                  JobsApi.approveApplication(
                                          id: application.id!)
                                      .then((_) {
                                    loadData();
                                  }).catchError((error) {
                                    ExceptionHandler.show(
                                      error,
                                      message:
                                          'Washer could not be approved. Does the washer have all necessary information?',
                                    );
                                  }).whenComplete(() => setLoading(false));
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: application.state ==
                                    JobApplicationState.pending &&
                                application.job.selectedWashers <
                                    application.job.maxWorkers,
                            child: SizedBox(
                              width: 105,
                              child: _ApprovalButton(
                                label: 'Deny',
                                icon: PixelPerfectIcons.xMedium,
                                backgroundColor: GawTheme.clearText,
                                textColor: GawTheme.mainTint,
                                onTap: () {
                                  setLoading(true);
                                  JobsApi.denyApplication(id: application.id!)
                                      .then((_) {
                                    loadData();
                                  }).catchError((error) {
                                    ExceptionHandler.show(error);
                                  }).whenComplete(() => setLoading(false));
                                },
                              ),
                            ),
                          ),
                          ColorlessInkWell(
                            onTap: () {
                              onSelected(application);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  PaddingSizes.mainPadding),
                              child: Container(
                                height: 32,
                                width: 128,
                                decoration: BoxDecoration(
                                  color: GawTheme.clearText,
                                  borderRadius: BorderRadius.circular(4),
                                  border: const Border.fromBorderSide(
                                    Borders.lightSide,
                                  ),
                                ),
                                child: const IntrinsicWidth(
                                  child: IntrinsicWidth(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: PaddingSizes.smallPadding,
                                        ),
                                        child: MainText(
                                          'View application',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ): 420,
                  },
                ),
              );
            },
          ).toList() ??
          [],
    );
  }
}

class _ApprovalButton extends StatelessWidget {
  final String label;

  final String icon;

  final bool outline;

  final Color backgroundColor;

  final Color textColor;

  final Function()? onTap;

  const _ApprovalButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.outline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingSizes.mainPadding,
      ),
      child: ColorlessInkWell(
        onTap: onTap,
        child: Container(
          height: 32,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: outline
                ? null
                : const Border.fromBorderSide(
                    Borders.thickMainTintSide,
                  ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: PaddingSizes.mainPadding,
                ),
                child: MainText(
                  label,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  right: PaddingSizes.smallPadding,
                ),
                child: SizedBox(
                  height: 21,
                  width: 21,
                  child: SvgIcon(
                    icon,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
