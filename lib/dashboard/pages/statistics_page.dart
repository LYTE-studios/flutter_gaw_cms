import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

const BeamPage statisticsBeamPage = BeamPage(
  title: 'Statistics',
  key: ValueKey('statistics'),
  type: BeamPageType.noTransition,
  child: StatisticsPage(),
);

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  static const String route = '/dashboard/home/statistics';

  static const double bannerHeight = 210;

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with ScreenStateMixin {
  OverlayPortalController controller = OverlayPortalController();

  DateIntervalSelectable? selectable = DateIntervalSelectable.thisMonth;

  late PickerDateRange? range = selectable?.getDateRange();

  late DateTime? startTime = range?.startDate;

  late DateTime? endTime = range?.endDate;

  AdminStatisticsOverviewResponse? adminStatistics;

  bool showPicker = false;

  @override
  Future<void> loadData() async {
    if (startTime == null || endTime == null) {
      return;
    }

    await StatisticsApi.getAdminStatistics(
      startTime: GawDateUtil.toApi(startTime!),
      endTime: GawDateUtil.toApi(endTime!),
    ).then((adminStats) {
      setState(() {
        adminStatistics = adminStats;
      });
    }).catchError(
      (error) {
        ExceptionHandler.show(error);
      },
    ).whenComplete(() => setLoading(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (!controller.isShowing) {
            return;
          }

          controller.toggle();
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return OverlayPortal(
            controller: controller,
            overlayChildBuilder: (context) {
              return Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: PaddingSizes.mainPadding,
                  ),
                  child: SizedBox(
                    height: constraints.maxHeight - 56,
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

                        setState(() {
                          selectable = null;
                          this.startTime = startTime;
                          this.endTime = endTime;
                        });

                        loadData();
                      },
                    ),
                  ),
                ),
              );
            },
            child: BaseLayoutScreen(
              mainRoute: 'Dashboard',
              subRoute: 'Statistics',
              showWelcomeMessage: true,
              bannerHeightOverride: StatisticsPage.bannerHeight,
              actionWidget: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingSizes.extraBigPadding,
                ),
                child: CmsExpandableDateRangePicker(
                  expanded: false,
                  toggleExpand: () {
                    controller.toggle();
                  },
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  if (showPicker) {
                    setState(() {
                      showPicker = false;
                    });
                  }
                },
                behavior: HitTestBehavior.deferToChild,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: StatisticsPage.bannerHeight,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 860,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                        top: PaddingSizes.mainPadding,
                        left: PaddingSizes.mainPadding,
                        right: PaddingSizes.mainPadding,
                      ),
                      children: [
                        SizedBox(
                          height: 148,
                          child: Row(
                            children: [
                              Expanded(
                                child: CircularProgressOverviewBlock(
                                  isLoading: loading,
                                  color: GawTheme.secondaryTint,
                                  value: adminStatistics
                                          ?.jobsWithoutCandidatesCount ??
                                      0,
                                  maxValue: adminStatistics?.jobCount ?? 0,
                                  title: 'Jobs without candidates',
                                  description: 'Out of all planned jobs',
                                ),
                              ),
                              Expanded(
                                child: CircularProgressOverviewBlock(
                                  color: GawTheme.mainTint,
                                  value: (adminStatistics?.jobCount ?? 0) -
                                      (adminStatistics?.plannedJobCount ?? 0),
                                  maxValue: adminStatistics?.jobCount ?? 0,
                                  title: 'Jobs with no approved candidates',
                                  description: 'Out of all planned jobs',
                                  isLoading: loading,
                                ),
                              ),
                              Expanded(
                                child: TargetStatisticsBlock(
                                  jobsCount: adminStatistics?.jobCount ?? 0,
                                  increaseAmount:
                                      adminStatistics?.getJobCountTrend() ?? 0,
                                ),
                              ),
                              Expanded(
                                child: TargetStatisticsBlock(
                                  candidatesCount:
                                      adminStatistics?.candidatesCount ?? 0,
                                  increaseAmount:
                                      adminStatistics?.getJobCountTrend() ?? 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 148,
                          child: Row(
                            children: [
                              Expanded(
                                child: CircularProgressOverviewBlock(
                                  isLoading: loading,
                                  color: GawTheme.secondaryTint,
                                  value: adminStatistics?.comingJobCount ?? 0,
                                  maxValue: adminStatistics?.jobCount ?? 0,
                                  title: 'Jobs that haven\'t started yet',
                                  description: 'Out of all jobs',
                                ),
                              ),
                              Expanded(
                                child: CircularProgressOverviewBlock(
                                  isLoading: loading,
                                  color: GawTheme.mainTint,
                                  value: adminStatistics?.ongoingJobCount ?? 0,
                                  maxValue: adminStatistics?.jobCount ?? 0,
                                  title: 'Ongoing jobs',
                                  description: 'Out of all jobs',
                                ),
                              ),
                              Expanded(
                                child: CircularProgressOverviewBlock(
                                  isLoading: loading,
                                  color: GawTheme.success,
                                  value:
                                      adminStatistics?.completedJobCount ?? 0,
                                  maxValue: adminStatistics?.jobCount ?? 0,
                                  title: 'Jobs completed',
                                  description: 'Out of all planned jobs',
                                ),
                              ),
                              Expanded(
                                child: CircularProgressOverviewBlock(
                                  isLoading: loading,
                                  color: GawTheme.error,
                                  value:
                                      adminStatistics?.unservicedJobCount ?? 0,
                                  maxValue: adminStatistics?.jobCount ?? 0,
                                  title: 'Unserviced jobs',
                                  description: 'Out of all jobs',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 420,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: StatisticsChartContainer(
                                  weeklyStatistics: adminStatistics
                                          ?.hoursWorkedStats
                                          .toSpots() ??
                                      [],
                                  averageHours: adminStatistics
                                          ?.hoursWorkedStats.totalWorkedHours
                                          .round() ??
                                      0,
                                  isTrend: false,
                                  trend: adminStatistics?.getHoursWorkedTrend(),
                                  showWeekly: false,
                                  overriddenPadding: const EdgeInsets.all(
                                    PaddingSizes.smallPadding,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ShelfOverviewBlock(
                                  scheduledCount:
                                      adminStatistics?.plannedJobCount,
                                  doneCount: adminStatistics?.completedJobCount,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
