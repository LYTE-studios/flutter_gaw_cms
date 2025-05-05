import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/dashboard/pages/applications_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:tuple/tuple.dart';

const BeamPage dashboardPageBeamPage = BeamPage(
  title: 'Dashboard',
  key: ValueKey('dashboard'),
  type: BeamPageType.noTransition,
  child: DashboardPage(),
);

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  static const String route = '/dashboard/home';

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with ScreenStateMixin {
  AdminStatisticsOverviewResponse? adminStatistics;

  @override
  Future<void> loadData() async {
    Tuple2<DateTime, DateTime> dateRange = GawDateUtil.getWeekRange();

    AdminStatisticsOverviewResponse? adminStats =
        await StatisticsApi.getAdminStatistics(
      startTime: GawDateUtil.toApi(
        dateRange.item1,
      ),
      endTime: GawDateUtil.toApi(
        dateRange.item2,
      ),
    );

    setState(() {
      adminStatistics = adminStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      showWelcomeMessage: true,
      mainRoute: 'Dashboard',
      subRoute: 'Dashboard',
      child: Column(
        children: [
          const SizedBox(
            height: 196,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.extraSmallPadding,
            ),
            child: SizedBox(
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
                    child: TargetStatisticsBlock(
                      loading: loading,
                      jobsCount: adminStatistics?.jobCount ?? 0,
                      increaseAmount: adminStatistics?.getJobCountTrend() ?? 0,
                    ),
                  ),
                  Expanded(
                    child: TargetStatisticsBlock(
                      loading: loading,
                      candidatesCount: adminStatistics?.candidatesCount ?? 0,
                      increaseAmount: adminStatistics?.getJobCountTrend() ?? 0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: PaddingSizes.bigPadding,
              horizontal: PaddingSizes.mainPadding,
            ),
            child: Container(
              height: 86,
              decoration: BoxDecoration(
                color: GawTheme.clearText,
                boxShadow: const [
                  Shadows.mainShadow,
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PaddingSizes.bigPadding,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: PaddingSizes.mainPadding,
                            ),
                            child: MainText(
                              'Applications',
                              textStyleOverride: TextStyles.titleStyle.copyWith(
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MainText(
                                'Workers job applications',
                                textStyleOverride:
                                    TextStyles.mainStyle.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: PaddingSizes.extraSmallPadding,
                              ),
                              const SizedBox(
                                height: 8,
                                width: 8,
                                child: SvgIcon(
                                  PixelPerfectIcons.info,
                                  color: GawTheme.text,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: ScreenSheet(
              fullScreen: false,
              child: ApplicationsListView(
                fullView: false,
                isJobSpecific: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
