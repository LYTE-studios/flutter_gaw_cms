import 'package:flutter_package_gaw_api/flutter_package_gaw_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jobs_provider_state.freezed.dart';

@freezed
class JobsProviderState with _$JobsProviderState {
  factory JobsProviderState({
    @Default(true) bool loading,
    @Default(true) bool loadingUpcomingJobs,
    @Default(true) bool loadingMyJobs,
    JobListResponse? upcomingJobs,
    JobListResponse? archiveJobs,
    ApplicationListResponse? myJobs,
    Job? currentJob,
  }) = jobsProviderState;
}
