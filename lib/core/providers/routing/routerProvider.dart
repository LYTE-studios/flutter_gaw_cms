import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Router provider that saves the current route
final routerProvider = StateProvider.autoDispose<String?>((ref) {
  // Keeps alive
  ref.keepAlive();

  // Start route
  return '';
});
