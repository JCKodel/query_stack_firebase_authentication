import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:query_stack/query_stack.dart';
import 'package:query_stack_firebase_authentication/query_stack_firebase_authentication.dart';

class AuthenticationQuery extends StatelessWidget {
  const AuthenticationQuery({required this.loginConfiguration, required this.builder, super.key});

  final BaseLoginConfiguration loginConfiguration;
  final Widget Function(BuildContext context, Principal principal) builder;

  @override
  Widget build(BuildContext context) {
    return QueryStreamBuilder<Principal>(
      stream: AuthenticationService.current.currentPrincipalStream,
      emptyBuilder: (_) => BaseLoginPage(loginConfiguration: loginConfiguration),
      waitingBuilder: (_) => WaitingPage(header: loginConfiguration.header),
      errorBuilder: (_, __) => BaseLoginPage(loginConfiguration: loginConfiguration),
      initialData: AuthenticationService.current.currentPrincipalStream.hasValue ? AuthenticationService.current.currentPrincipalStream.value : null,
      onError: _onError,
      dataBuilder: builder,
    );
  }

  void _onError(BuildContext context, Object error) {
    showOkAlertDialog(
      context: context,
      title: "Erro inesperado",
      message: error.toString(),
    );
  }
}
