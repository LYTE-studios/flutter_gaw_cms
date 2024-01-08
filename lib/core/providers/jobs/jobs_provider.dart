import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider_state.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ErrorCallback = Function(dynamic error)?;

final jobsProvider = StateNotifierProvider<JobsProvider, JobsProviderState>(
  (ref) => JobsProvider(
    ref,
  ),
);

class JobsProvider extends StateNotifier<JobsProviderState> {
  JobsProvider(
    this.ref,
  ) : super(JobsProviderState()) {
    loadData();
  }

  final Ref ref;

  void setLoading(bool value) {
    state = state.copyWith(
      loading: value,
    );
  }

  void _handleError(dynamic error) {
    ExceptionHandler.show(error);
  }

  void loadData() {
    loadUpcomingJobs().catchError(_handleError);
    loadApplications().catchError(_handleError);
  }

  Future<void> loadUpcomingJobs() async {
    state = state.copyWith(
      loadingUpcomingJobs: true,
    );

    JobListResponse? jobsList = await JobsApi.getUpcomingJobs();

    state = state.copyWith(
      loadingUpcomingJobs: false,
      upcomingJobs: jobsList,
    );
  }

  Future<void> loadJob({
    required String jobId,
  }) async {
    state = state.copyWith(
      currentJob: null,
      loading: true,
    );

    Job? job = await JobsApi.getJob(id: jobId);

    state = state.copyWith(
      currentJob: job,
      loading: false,
    );
  }

  Future<void> loadHistory() async {
    setLoading(false);

    JobListResponse? historyResponse = await JobsApi.getHistoryJobs();

    state = state.copyWith(
      loading: false,
      archiveJobs: historyResponse,
    );
  }

  Future<void> loadApplications() async {
    state = state.copyWith(
      loadingMyJobs: true,
    );

    ApplicationListResponse? applicationList =
        await JobsApi.getMyApplications();

    state = state.copyWith(
      loadingMyJobs: false,
      myJobs: applicationList,
    );
  }
}
