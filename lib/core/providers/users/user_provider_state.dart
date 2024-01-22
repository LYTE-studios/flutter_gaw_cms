import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaw_api/gaw_api.dart';

part 'user_provider_state.freezed.dart';

@freezed
class UserProviderState with _$UserProviderState {
  factory UserProviderState({
    @Default(true) bool loading,
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profilePictureUrl,
    Uint8List? profilePicture,
    String? description,
    String? phoneNumber,
    String? language,
    DateTime? dateOfBirth,
    Address? address,
  }) = userProviderState;
}
