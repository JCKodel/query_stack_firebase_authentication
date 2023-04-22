import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:query_stack_firebase_authentication/src/principal_login.dart';

part 'principal.freezed.dart';

@freezed
class Principal with _$Principal {
  const factory Principal({
    required String id,
    required String displayName,
    required String email,
    required String avatarURL,
    required DateTime creationTime,
    required PrincipalLogin lastLogin,
  }) = _Principal;

  const Principal._();

  static DateTime _lastValue = DateTime(2023, 1, 1);

  static String generateNewRandomId() {
    late Random random;

    try {
      random = Random.secure();
    } on UnsupportedError catch (_) {
      random = Random();
    }

    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final randomId = String.fromCharCodes(
      Iterable.generate(28, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );

    return _generateNewId(randomId);
  }

  static String _generateNewId(String principalId) {
    final p1 = int.parse(principalId.substring(0, 4), radix: 36).toRadixString(16).padLeft(6, "0");

    final p2 = int.parse(principalId.substring(4, 8), radix: 36).toRadixString(16).padLeft(6, "0");

    final p3 = int.parse(principalId.substring(8, 12), radix: 36).toRadixString(16).padLeft(6, "0");

    final p4 = int.parse(principalId.substring(12, 16), radix: 36).toRadixString(16).padLeft(6, "0");

    final p5 = int.parse(principalId.substring(16, 20), radix: 36).toRadixString(16).padLeft(6, "0");

    final p6 = int.parse(principalId.substring(20, 24), radix: 36).toRadixString(16).padLeft(6, "0");

    final p7 = int.parse(principalId.substring(24, 28), radix: 36).toRadixString(16).padLeft(6, "0");

    final p = (p1 + p2 + p3 + p4 + p5 + p6 + p7).substring(22, 42);

    var now = DateTime.now().toUtc();

    if (now.difference(_lastValue).inMilliseconds < 4) {
      now = _lastValue.add(const Duration(milliseconds: 4));
    }

    _lastValue = now;

    final ms = now.millisecondsSinceEpoch.toRadixString(16).padLeft(12, "0");
    final guid = p + ms;

    return "${guid.substring(0, 8)}-"
            "${guid.substring(8, 12)}-"
            "${guid.substring(12, 16)}-"
            "${guid.substring(16, 20)}-"
            "${guid.substring(20)}"
        .toUpperCase();
  }

  String generateNewId() {
    return _generateNewId(id);
  }
}
