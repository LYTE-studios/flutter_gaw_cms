import 'package:flutter_gaw_cms/core/providers/users/user_provider_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

/// User provider to keep the current users state
final userProvider = StateNotifierProvider<UserProvider, UserProviderState>(
  (ref) => UserProvider(ref),
);

// STATE
class UserProvider extends StateNotifier<UserProviderState> {
  UserProvider(this.ref) : super(UserProviderState()) {
    // Load data upon initialization
    loadData();
    loadSettings();
  }

  final Ref ref;

  void loadData() {
    state = state.copyWith(
      loading: true,
    );

    UsersApi.helloThere().then((HelloThereResponse? response) {
      state = state.copyWith(
        id: response!.id,
        email: response.email,
        firstName: response.firstName,
        lastName: response.lastName,
        profilePictureUrl: response.profilePictureUrl,
      );
    });
  }

  void loadSettings() {
    UsersApi.me().then((response) {
      state = state.copyWith(
        id: response!.userId,
        firstName: response.firstName,
        lastName: response.lastName,
        phoneNumber: response.phoneNumber,
        language: response.language,
        dateOfBirth: response.dateOfBirth == null
            ? null
            : GawDateUtil.fromApi(response.dateOfBirth!),
        address: response.address,
      );
    });
  }
}
