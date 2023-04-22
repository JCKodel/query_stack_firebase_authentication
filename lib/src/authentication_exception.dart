import 'package:flutter/foundation.dart';

enum FailureReason {
  unavailableAuthenticationMethod,
  unknownFailure,
  networkError,
  userIsDisabled,
}

@immutable
class AuthenticationException implements Exception {
  const AuthenticationException({
    required this.reason,
    required this.message,
    required this.stackTrace,
  });

  final FailureReason reason;
  final String message;
  final StackTrace? stackTrace;
}
