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
  JobListResponse? get activeJobs => throw _privateConstructorUsedError;
  JobListResponse? get doneJobs => throw _privateConstructorUsedError;
  JobListResponse? get draftJobs => throw _privateConstructorUsedError;
  JobListResponse? get upcomingJobs => throw _privateConstructorUsedError;

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
      JobListResponse? activeJobs,
      JobListResponse? doneJobs,
      JobListResponse? draftJobs,
      JobListResponse? upcomingJobs});
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
    Object? activeJobs = freezed,
    Object? doneJobs = freezed,
    Object? draftJobs = freezed,
    Object? upcomingJobs = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      activeJobs: freezed == activeJobs
          ? _value.activeJobs
          : activeJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      doneJobs: freezed == doneJobs
          ? _value.doneJobs
          : doneJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      draftJobs: freezed == draftJobs
          ? _value.draftJobs
          : draftJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      upcomingJobs: freezed == upcomingJobs
          ? _value.upcomingJobs
          : upcomingJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
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
      JobListResponse? activeJobs,
      JobListResponse? doneJobs,
      JobListResponse? draftJobs,
      JobListResponse? upcomingJobs});
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
    Object? activeJobs = freezed,
    Object? doneJobs = freezed,
    Object? draftJobs = freezed,
    Object? upcomingJobs = freezed,
  }) {
    return _then(_$jobsProviderStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      activeJobs: freezed == activeJobs
          ? _value.activeJobs
          : activeJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      doneJobs: freezed == doneJobs
          ? _value.doneJobs
          : doneJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      draftJobs: freezed == draftJobs
          ? _value.draftJobs
          : draftJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
      upcomingJobs: freezed == upcomingJobs
          ? _value.upcomingJobs
          : upcomingJobs // ignore: cast_nullable_to_non_nullable
              as JobListResponse?,
    ));
  }
}

/// @nodoc

class _$jobsProviderStateImpl implements jobsProviderState {
  _$jobsProviderStateImpl(
      {this.loading = true,
      this.activeJobs,
      this.doneJobs,
      this.draftJobs,
      this.upcomingJobs});

  @override
  @JsonKey()
  final bool loading;
  @override
  final JobListResponse? activeJobs;
  @override
  final JobListResponse? doneJobs;
  @override
  final JobListResponse? draftJobs;
  @override
  final JobListResponse? upcomingJobs;

  @override
  String toString() {
    return 'JobsProviderState(loading: $loading, activeJobs: $activeJobs, doneJobs: $doneJobs, draftJobs: $draftJobs, upcomingJobs: $upcomingJobs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$jobsProviderStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.activeJobs, activeJobs) ||
                other.activeJobs == activeJobs) &&
            (identical(other.doneJobs, doneJobs) ||
                other.doneJobs == doneJobs) &&
            (identical(other.draftJobs, draftJobs) ||
                other.draftJobs == draftJobs) &&
            (identical(other.upcomingJobs, upcomingJobs) ||
                other.upcomingJobs == upcomingJobs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, loading, activeJobs, doneJobs, draftJobs, upcomingJobs);

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
      final JobListResponse? activeJobs,
      final JobListResponse? doneJobs,
      final JobListResponse? draftJobs,
      final JobListResponse? upcomingJobs}) = _$jobsProviderStateImpl;

  @override
  bool get loading;
  @override
  JobListResponse? get activeJobs;
  @override
  JobListResponse? get doneJobs;
  @override
  JobListResponse? get draftJobs;
  @override
  JobListResponse? get upcomingJobs;
  @override
  @JsonKey(ignore: true)
  _$$jobsProviderStateImplCopyWith<_$jobsProviderStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
