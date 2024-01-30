import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaw_api/gaw_api.dart';

part 'jobs_provider_state.freezed.dart';

@freezed
class JobsProviderState with _$JobsProviderState {
  factory JobsProviderState({
    @Default(true) bool loading,
    JobListResponse? activeJobs,
    JobListResponse? doneJobs,
    JobListResponse? draftJobs,
    JobListResponse? upcomingJobs,
  }) = jobsProviderState;
}
