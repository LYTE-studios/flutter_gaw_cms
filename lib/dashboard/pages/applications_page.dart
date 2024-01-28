import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/application_details_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/tabs/job_tiles_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

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
  @override
  Widget build(BuildContext context) {
    final jobsProviderState = ref.watch(jobsProvider);

    List<Job> jobs = jobsProviderState.upcomingJobs?.jobs?.toList() ?? [];

    return BaseLayoutScreen(
      mainRoute: 'Jobs',
      subRoute: 'Applications',
      child: ScreenSheet(
        topPadding: 120,
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
                    textStyleOverride: TextStyles.titleStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: JobTilesTab(
                jobs: jobs,
                basicView: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ApplicationsListView extends StatefulWidget {
  final bool fullView;

  final String? jobId;

  const ApplicationsListView({
    super.key,
    this.fullView = true,
    this.jobId,
  });

  @override
  State<ApplicationsListView> createState() => _ApplicationsListViewState();
}

class _ApplicationsListViewState extends State<ApplicationsListView>
    with ScreenStateMixin {
  ApplicationListResponse? applicationsListResponse;

  @override
  void initState() {
    Future(() {
      loadData();
    });
    super.initState();
  }

  void loadData() {
    setLoading(true);

    JobsApi.getApplications(jobId: widget.jobId).then((response) {
      setData(() {
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
      header: const BaseListHeader(
        items: {
          'Washer name': ListUtil.xLColumn,
          'Date': ListUtil.sColumn,
          'Region': ListUtil.mColumn,
          'Distance': ListUtil.sColumn,
          '': ListUtil.sColumn,
        },
      ),
      rows: applicationsListResponse?.applications.map(
            (application) {
              return InkWell(
                onTap: () {
                  onSelected(application);
                },
                child: BaseListItem(
                  items: {
                    ProfileRowItem(
                      firstName: application.washer.firstName,
                      lastName: application.washer.lastName,
                      imageUrl: application.washer.profilePictureUrl,
                    ): ListUtil.xLColumn,
                    TextRowItem(
                      value: GawDateUtil.tryFormatReadableDate(
                        GawDateUtil.tryFromApi(application.createdAt),
                      ),
                    ): ListUtil.sColumn,
                    SelectableTextRowItem(
                      value: application.address.city ??
                          application.address.postalCode,
                    ): ListUtil.mColumn,
                    TextRowItem(
                      value: GeoUtil.formatDistance(application.distance),
                    ): ListUtil.sColumn,
                    BaseRowItem(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingSizes.mainPadding,
                          vertical: PaddingSizes.mainPadding,
                        ),
                        child: GenericButton(
                          onTap: () {
                            setLoading(true);
                            JobsApi.approveApplication(id: application.id!)
                                .then((_) {
                              loadData();
                            }).catchError((error) {
                              ExceptionHandler.show(error);
                            }).whenComplete(() => setLoading(false));
                          },
                          label: 'Approve',
                          textStyleOverride: TextStyles.mainStyle.copyWith(
                            color: GawTheme.clearText,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ): ListUtil.mColumn,
                    BaseRowItem(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingSizes.mainPadding,
                          vertical: PaddingSizes.mainPadding,
                        ),
                        child: GenericButton(
                          label: 'Deny',
                          outline: true,
                          onTap: () {
                            setLoading(true);
                            JobsApi.denyApplication(id: application.id!)
                                .then((_) {
                              loadData();
                            }).catchError((error) {
                              ExceptionHandler.show(error);
                            }).whenComplete(() => setLoading(false));
                          },
                          color: GawTheme.clearText,
                          textStyleOverride: TextStyles.mainStyle.copyWith(
                            color: GawTheme.text,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ): ListUtil.mColumn,
                    ActionButtonRowItem(
                      label: 'View application',
                      onTap: () {
                        onSelected(application);
                      },
                    ): ListUtil.lColumn,
                  },
                ),
              );
            },
          ).toList() ??
          [],
    );
  }
}
