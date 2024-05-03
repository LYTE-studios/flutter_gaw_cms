import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaw_api/gaw_api.dart';

part 'notifications_provider_state.freezed.dart';

@freezed
class NotificationsProviderState with _$NotificationsProviderState {
  factory NotificationsProviderState({
    List<Notification>? notifications,
    @Default(false) bool tickerIsRunning,
  }) = notificationsProviderState;
}
