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
  DateIntervalSelectable? selectable;

  DateTime startTime = DateTime.now().subtract(
    const Duration(days: 356),
  );

  DateTime endTime = DateTime.now();

  AdminStatisticsOverviewResponse? adminStatistics;

  bool showPicker = false;

  void loadData() {
    setLoading(true);

    StatisticsApi.getAdminStatistics(
      startTime: GawDateUtil.toApi(startTime),
      endTime: GawDateUtil.toApi(endTime),
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
  void initState() {
    Future(() {
      loadData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      mainRoute: 'Dashboard',
      subRoute: 'Statistics',
      showWelcomeMessage: true,
      bannerHeightOverride: StatisticsPage.bannerHeight,
      actionWidget: CmsExpandableDateRangePicker(
        expanded: showPicker,
        initialStart: startTime,
        initialEnd: endTime,
        selectable: selectable,
        onUpdateSelectable: (DateIntervalSelectable selectable) {
          PickerDateRange range = selectable.getDateRange();

          setState(() {
            this.selectable = selectable;
            startTime = range.startDate!;
            endTime = range.endDate!;
          });
        },
        toggleExpand: () {
          setState(() {
            showPicker = !showPicker;
          });
        },
        onUpdateDates: (DateTime start, DateTime end) {
          setState(() {
            selectable = null;
            startTime = start;
            endTime = end;
            showPicker = !showPicker;
          });
          Future(() {
            loadData();
          });
        },
      ),
      child: GestureDetector(
        onTap: () {
          if (showPicker) {
            setState(() {
              showPicker = false;
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 860,
                maxWidth: 1240,
              ),
              child: SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    const SizedBox(
                      height: StatisticsPage.bannerHeight,
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          vertical: PaddingSizes.mainPadding,
                          horizontal: PaddingSizes.bigPadding,
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
                                    value:
                                        adminStatistics?.unservicedJobCount ??
                                            0,
                                    maxValue: adminStatistics?.jobCount ?? 0,
                                    title: 'Jobs without candidates',
                                    description: 'Out of all planned jobs',
                                  ),
                                ),
                                Expanded(
                                  child: CircularProgressOverviewBlock(
                                    color: GawTheme.mainTint,
                                    value:
                                        adminStatistics?.unservicedJobCount ??
                                            0,
                                    maxValue: adminStatistics?.jobCount ?? 0,
                                    title: 'Jobs with no approved candidates',
                                    description: 'Out of all planned jobs',
                                    isLoading: loading,
                                  ),
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: TargetStatisticsBlock(
                                    jobsCount: 1,
                                    increaseAmount: 12.5,
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
                                    value:
                                        adminStatistics?.ongoingJobCount ?? 0,
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
                                        adminStatistics?.unservicedJobCount ??
                                            0,
                                    maxValue: adminStatistics?.jobCount ?? 0,
                                    title: 'Unserviced jobs',
                                    description: 'Out of all jobs',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 360,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: StatisticsChartContainer(
                                    weeklyStatistics: [],
                                    averageHours: 2,
                                    isTrend: false,
                                    trend: 2,
                                    showWeekly: false,
                                    overriddenPadding: EdgeInsets.all(
                                      PaddingSizes.smallPadding,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ShelfOverviewBlock(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
