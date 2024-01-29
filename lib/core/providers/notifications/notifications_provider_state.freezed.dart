// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_provider_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationsProviderState {
  List<Notification>? get notifications => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsProviderStateCopyWith<NotificationsProviderState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsProviderStateCopyWith<$Res> {
  factory $NotificationsProviderStateCopyWith(NotificationsProviderState value,
          $Res Function(NotificationsProviderState) then) =
      _$NotificationsProviderStateCopyWithImpl<$Res,
          NotificationsProviderState>;
  @useResult
  $Res call({List<Notification>? notifications});
}

/// @nodoc
class _$NotificationsProviderStateCopyWithImpl<$Res,
        $Val extends NotificationsProviderState>
    implements $NotificationsProviderStateCopyWith<$Res> {
  _$NotificationsProviderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = freezed,
  }) {
    return _then(_value.copyWith(
      notifications: freezed == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<Notification>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$notificationsProviderStateImplCopyWith<$Res>
    implements $NotificationsProviderStateCopyWith<$Res> {
  factory _$$notificationsProviderStateImplCopyWith(
          _$notificationsProviderStateImpl value,
          $Res Function(_$notificationsProviderStateImpl) then) =
      __$$notificationsProviderStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Notification>? notifications});
}

/// @nodoc
class __$$notificationsProviderStateImplCopyWithImpl<$Res>
    extends _$NotificationsProviderStateCopyWithImpl<$Res,
        _$notificationsProviderStateImpl>
    implements _$$notificationsProviderStateImplCopyWith<$Res> {
  __$$notificationsProviderStateImplCopyWithImpl(
      _$notificationsProviderStateImpl _value,
      $Res Function(_$notificationsProviderStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = freezed,
  }) {
    return _then(_$notificationsProviderStateImpl(
      notifications: freezed == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<Notification>?,
    ));
  }
}

/// @nodoc

class _$notificationsProviderStateImpl implements notificationsProviderState {
  _$notificationsProviderStateImpl({final List<Notification>? notifications})
      : _notifications = notifications;

  final List<Notification>? _notifications;
  @override
  List<Notification>? get notifications {
    final value = _notifications;
    if (value == null) return null;
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'NotificationsProviderState(notifications: $notifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$notificationsProviderStateImpl &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_notifications));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$notificationsProviderStateImplCopyWith<_$notificationsProviderStateImpl>
      get copyWith => __$$notificationsProviderStateImplCopyWithImpl<
          _$notificationsProviderStateImpl>(this, _$identity);
}

abstract class notificationsProviderState
    implements NotificationsProviderState {
  factory notificationsProviderState(
          {final List<Notification>? notifications}) =
      _$notificationsProviderStateImpl;

  @override
  List<Notification>? get notifications;
  @override
  @JsonKey(ignore: true)
  _$$notificationsProviderStateImplCopyWith<_$notificationsProviderStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
