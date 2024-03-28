import 'package:flutter_gaw_cms/core/providers/jobs/jobs_provider_state.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

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

  void loadData({DateTime? startTime, DateTime? endTime}) {
    setLoading(true);

    Future(() async {
      await loadDraftJobs().catchError(_handleError);
      await loadDoneJobs(
        startTime: startTime,
        endTime: endTime,
      ).catchError(_handleError);
      await loadUpcomingJobs(
        startTime: startTime,
        endTime: endTime,
      ).catchError(_handleError);
      await loadActiveJobs().catchError(_handleError);
    }).then((_) {
      setLoading(false);
    });
  }

  Future<void> loadUpcomingJobs(
      {DateTime? startTime, DateTime? endTime}) async {
    JobListResponse? response = await JobsApi.getUpcomingJobs(
      isAdmin: true,
      startTime: GawDateUtil.tryToApi(startTime),
      endTime: GawDateUtil.tryToApi(
        endTime,
        toEndOfDay: true,
      ),
    );

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

  Future<void> loadDoneJobs({DateTime? startTime, DateTime? endTime}) async {
    JobListResponse? response = await JobsApi.getDoneJobs(
      startTime: GawDateUtil.tryToApi(startTime),
      endTime: GawDateUtil.tryToApi(
        endTime,
        toEndOfDay: true,
      ),
    );

    state = state.copyWith(doneJobs: response);
  }
}
