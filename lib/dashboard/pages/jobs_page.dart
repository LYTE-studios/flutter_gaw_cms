import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:gaw_ui/src/utility/dialog_util.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/job_create_dialog.dart';
import 'package:flutter_gaw_cms/jobs/presentation/tabs/job_tiles_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage jobsBeamPage = BeamPage(
  title: 'Jobs',
  key: ValueKey('jobs'),
  type: BeamPageType.noTransition,
  child: JobsPage(),
);

class JobsPage extends ConsumerStatefulWidget {
  const JobsPage({super.key});

  static const String route = '/dashboard/jobs';

  @override
  ConsumerState<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends ConsumerState<JobsPage> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final jobsProviderState = ref.watch(jobsProvider);

    return BaseLayoutScreen(
      mainRoute: 'Jobs',
      subRoute: 'Jobs',
      bannerHeightOverride: 160,
      actionWidget: Align(
        alignment: Alignment.topRight,
        child: ActionButton(
          label: 'Create new job',
          onTap: () {
            DialogUtil.show(
              dialog: JobCreatePopup(),
              context: context,
            );
          },
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 180,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.mainPadding,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 180,
              child: TabbedView(
                isScreenSheet: true,
                tabs: const [
                  'Upcoming jobs',
                  'Active jobs',
                  'Done jobs',
                  'Drafts',
                ],
                pages: [
                  JobTilesTab(
                    loading: jobsProviderState.loading,
                    jobs: jobsProviderState.upcomingJobs?.jobs?.toList() ?? [],
                  ),
                  JobTilesTab(
                    loading: jobsProviderState.loading,
                    jobs: jobsProviderState.activeJobs?.jobs?.toList() ?? [],
                  ),
                  JobTilesTab(
                    loading: jobsProviderState.loading,
                    jobs: jobsProviderState.doneJobs?.jobs?.toList() ?? [],
                  ),
                  JobTilesTab(
                    loading: jobsProviderState.loading,
                    jobs: jobsProviderState.draftJobs?.jobs?.toList() ?? [],
                  ),
                ],
                selectedIndex: selectedPage,
                onPageIndexChange: (int index) {
                  setState(() {
                    selectedPage = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
