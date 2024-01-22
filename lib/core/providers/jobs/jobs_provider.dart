import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider_state.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';

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
    setLoading(true);

    Future(() {
      loadDraftJobs().catchError(_handleError);
      loadDoneJobs().catchError(_handleError);
      loadUpcomingJobs().catchError(_handleError);
      loadActiveJobs().catchError(_handleError);
    }).then((_) {
      setLoading(false);
    });
  }

  Future<void> loadUpcomingJobs() async {
    JobListResponse? response = await JobsApi.getUpcomingJobs();

    state = state.copyWith(upcomingJobs: response);
  }

  Future<void> loadDraftJobs() async {
    JobListResponse? response = await JobsApi.getDraftJobs();

    state = state.copyWith(draftJobs: response);
  }

  Future<void> loadActiveJobs() async {
    JobListResponse? response = await JobsApi.getActiveJobs();

    state = state.copyWith(activeJobs: response);
  }

  Future<void> loadDoneJobs() async {
    JobListResponse? response = await JobsApi.getDoneJobs();

    state = state.copyWith(doneJobs: response);
  }
}
