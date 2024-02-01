import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/notifications/notifications_provider.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
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

  void loadData() {
    setLoading(true);

    Tuple2<DateTime, DateTime> dateRange = GawDateUtil.getWeekRange();

    StatisticsApi.getAdminStatistics(
      startTime: GawDateUtil.toApi(
        dateRange.item1,
      ),
      endTime: GawDateUtil.toApi(
        dateRange.item2,
      ),
    ).then((adminStats) {
      setData(() {
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
    ref.watch(notificationsTickerProvider);

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
                      value: adminStatistics?.unservicedJobCount ?? 0,
                      maxValue: adminStatistics?.jobCount ?? 0,
                      title: 'Jobs without candidates',
                      description: 'Out of all planned jobs this week',
                    ),
                  ),
                  Expanded(
                    child: CircularProgressOverviewBlock(
                      color: GawTheme.mainTint,
                      value: adminStatistics?.unservicedJobCount ?? 0,
                      maxValue: adminStatistics?.jobCount ?? 0,
                      title: 'Jobs with no approved candidates',
                      description: 'Out of all planned jobs this week',
                      isLoading: loading,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TargetStatisticsBlock(
                      loading: loading,
                      jobsCount: adminStatistics?.jobCount ?? 0,
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
                                'Washers job applications',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
