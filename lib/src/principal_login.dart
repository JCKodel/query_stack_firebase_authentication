import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:query_stack/query_stack.dart';

import 'auth_provider.dart';

part 'principal_login.freezed.dart';

@freezed
class PrincipalLogin with _$PrincipalLogin {
  const factory PrincipalLogin({
    required AuthProvider authProvider,
    required String deviceId,
    required String model,
    required String device,
    required String version,
    required NativePlatform nativePlatform,
    required DateTime signInTime,
  }) = _PrincipalLogin;
}
