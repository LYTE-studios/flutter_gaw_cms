import 'package:flutter_gaw_cms/core/providers/notifications/notifications_provider_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';

final notificationsTickerProvider = StateNotifierProvider.autoDispose<
    NotificationsProvider, NotificationsProviderState>((ref) {
  ref.keepAlive();

  return NotificationsProvider(
    ref,
  );
});

class NotificationsProvider extends StateNotifier<NotificationsProviderState> {
  NotificationsProvider(
    this.ref,
  ) : super(NotificationsProviderState()) {
    startTicker();
  }

  final Ref ref;

  Future<void> startTicker() async {
    while (true) {
      await loadData();

      await Future.delayed(
        const Duration(seconds: 3),
      );
    }
  }

  Future<void> loadData() async {
    NotificationsListResponse? response =
        await NotificationsApi.getNotifications();
    state = state.copyWith(notifications: response?.notifications?.toList());
  }
}
