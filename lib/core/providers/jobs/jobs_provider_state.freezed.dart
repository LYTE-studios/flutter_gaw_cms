// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jobs_provider_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$JobsProviderState {
  bool get loading => throw _privateConstructorUsedError;
  bool get loadingUpcomingJobs => throw _privateConstructorUsedError;
  bool get loadingMyJobs => throw _privateConstructorUsedError;
  JobListResponse? get upcomingJobs => throw _privateConstructorUsedError;
  JobListResponse? get archiveJobs => throw _privateConstructorUsedError;
  ApplicationListResponse? get myJobs => throw _privateConstructorUsedError;
  Job? get currentJob => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $JobsProviderStateCopyWith<JobsProviderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobsProviderStateCopyWith<$Res> {
  factory $JobsProviderStateCopyWith(
          JobsProviderState value, $Res Function(JobsProviderState) then) =
      _$JobsProviderStateCopyWithImpl<$Res, JobsProviderState>;
  @useResult
  $Res call(
      {bool loading,
      bool loadingUpcomingJobs,
      bool loadingMyJobs,
      JobListResponse? upcomingJobs,
      JobListResponse? archiveJobs,
      ApplicationListResponse? myJobs,
      Job? currentJob});
}

/// @nodoc
class _$JobsProviderStateCopyWithImpl<$Res, $Val extends JobsProviderState>
    implements $JobsProviderStateCopyWith<$Res> {
  _$JobsProviderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? loadingUpcomingJobs = null,
    Object? loadingMyJobs = null,
    Object? upcomingJobs = freezed,
    Object? archiveJobs = freezed,
    Object? myJobs = freezed,
    Object? currentJob = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingUpcomingJobs: null == loadingUpcomingJobs
          ? _value.loadingUpcomingJobs
          : loadingUpcomingJobs // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMyJobs: null == loadingMyJobs
          ? _value.loadingMyJobs
          : loadingMyJobs // ignore: cast_nullable_to_non_nullable
              as bool,
      upcomingJobs: freezed == upcomingJobs
          ? _value.upcomingJobs
          : upcomingJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      archiveJobs: freezed == archiveJobs
          ? _value.archiveJobs
          : archiveJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      myJobs: freezed == myJobs
          ? _value.myJobs
          : myJobs // ignore: cast_nullable_to_non_nullable
              as ApplicationListResponse?,
      currentJob: freezed == currentJob
          ? _value.currentJob
          : currentJob // ignore: cast_nullable_to_non_nullable
              as Job?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$jobsProviderStateImplCopyWith<$Res>
    implements $JobsProviderStateCopyWith<$Res> {
  factory _$$jobsProviderStateImplCopyWith(_$jobsProviderStateImpl value,
          $Res Function(_$jobsProviderStateImpl) then) =
      __$$jobsProviderStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool loadingUpcomingJobs,
      bool loadingMyJobs,
      JobListResponse? upcomingJobs,
      JobListResponse? archiveJobs,
      ApplicationListResponse? myJobs,
      Job? currentJob});
}

/// @nodoc
class __$$jobsProviderStateImplCopyWithImpl<$Res>
    extends _$JobsProviderStateCopyWithImpl<$Res, _$jobsProviderStateImpl>
    implements _$$jobsProviderStateImplCopyWith<$Res> {
  __$$jobsProviderStateImplCopyWithImpl(_$jobsProviderStateImpl _value,
      $Res Function(_$jobsProviderStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? loadingUpcomingJobs = null,
    Object? loadingMyJobs = null,
    Object? upcomingJobs = freezed,
    Object? archiveJobs = freezed,
    Object? myJobs = freezed,
    Object? currentJob = freezed,
  }) {
    return _then(_$jobsProviderStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingUpcomingJobs: null == loadingUpcomingJobs
          ? _value.loadingUpcomingJobs
          : loadingUpcomingJobs // ignore: cast_nullable_to_non_nullable
              as bool,
      loadingMyJobs: null == loadingMyJobs
          ? _value.loadingMyJobs
          : loadingMyJobs // ignore: cast_nullable_to_non_nullable
              as bool,
      upcomingJobs: freezed == upcomingJobs
          ? _value.upcomingJobs
          : upcomingJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      archiveJobs: freezed == archiveJobs
          ? _value.archiveJobs
          : archiveJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      myJobs: freezed == myJobs
          ? _value.myJobs
          : myJobs // ignore: cast_nullable_to_non_nullable
              as ApplicationListResponse?,
      currentJob: freezed == currentJob
          ? _value.currentJob
          : currentJob // ignore: cast_nullable_to_non_nullable
              as Job?,
    ));
  }
}

/// @nodoc

class _$jobsProviderStateImpl implements jobsProviderState {
  _$jobsProviderStateImpl(
      {this.loading = true,
      this.loadingUpcomingJobs = true,
      this.loadingMyJobs = true,
      this.upcomingJobs,
      this.archiveJobs,
      this.myJobs,
      this.currentJob});

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool loadingUpcomingJobs;
  @override
  @JsonKey()
  final bool loadingMyJobs;
  @override
  final JobListResponse? upcomingJobs;
  @override
  final JobListResponse? archiveJobs;
  @override
  final ApplicationListResponse? myJobs;
  @override
  final Job? currentJob;

  @override
  String toString() {
    return 'JobsProviderState(loading: $loading, loadingUpcomingJobs: $loadingUpcomingJobs, loadingMyJobs: $loadingMyJobs, upcomingJobs: $upcomingJobs, archiveJobs: $archiveJobs, myJobs: $myJobs, currentJob: $currentJob)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$jobsProviderStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.loadingUpcomingJobs, loadingUpcomingJobs) ||
                other.loadingUpcomingJobs == loadingUpcomingJobs) &&
            (identical(other.loadingMyJobs, loadingMyJobs) ||
                other.loadingMyJobs == loadingMyJobs) &&
            (identical(other.upcomingJobs, upcomingJobs) ||
                other.upcomingJobs == upcomingJobs) &&
            (identical(other.archiveJobs, archiveJobs) ||
                other.archiveJobs == archiveJobs) &&
            (identical(other.myJobs, myJobs) || other.myJobs == myJobs) &&
            (identical(other.currentJob, currentJob) ||
                other.currentJob == currentJob));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, loadingUpcomingJobs,
      loadingMyJobs, upcomingJobs, archiveJobs, myJobs, currentJob);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$jobsProviderStateImplCopyWith<_$jobsProviderStateImpl> get copyWith =>
      __$$jobsProviderStateImplCopyWithImpl<_$jobsProviderStateImpl>(
          this, _$identity);
}

abstract class jobsProviderState implements JobsProviderState {
  factory jobsProviderState(
      {final bool loading,
      final bool loadingUpcomingJobs,
      final bool loadingMyJobs,
      final JobListResponse? upcomingJobs,
      final JobListResponse? archiveJobs,
      final ApplicationListResponse? myJobs,
      final Job? currentJob}) = _$jobsProviderStateImpl;

  @override
  bool get loading;
  @override
  bool get loadingUpcomingJobs;
  @override
  bool get loadingMyJobs;
  @override
  JobListResponse? get upcomingJobs;
  @override
  JobListResponse? get archiveJobs;
  @override
  ApplicationListResponse? get myJobs;
  @override
  Job? get currentJob;
  @override
  @JsonKey(ignore: true)
  _$$jobsProviderStateImplCopyWith<_$jobsProviderStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
