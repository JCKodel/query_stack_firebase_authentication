import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:query_stack/query_stack.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'authentication_exception.dart';
import 'authentication_service.dart';
import 'principal.dart';

@immutable
class BaseLoginConfiguration {
  const BaseLoginConfiguration({
    required this.header,
    required this.privacyPolicyText,
    required this.privacyPolicyURL,
    required this.signInWithAppleText,
    required this.signInWithGoogleText,
    required this.termsOfUseText,
    required this.termsOfUseURL,
    this.backgroundColor,
    this.footerTextColor,
    this.onAuthenticated,
    this.onDebug,
    this.progressIndicatorColor,
  });

  final Color? backgroundColor;
  final Color? footerTextColor;
  final Color? progressIndicatorColor;
  final String privacyPolicyText;
  final String privacyPolicyURL;
  final String signInWithAppleText;
  final String signInWithGoogleText;
  final String termsOfUseText;
  final String termsOfUseURL;
  final Widget header;
  final void Function()? onDebug;
  final void Function(Principal? principal)? onAuthenticated;
}

@immutable
class BaseLoginPage extends StatefulWidget {
  const BaseLoginPage({
    required this.loginConfiguration,
    super.key,
  });

  final BaseLoginConfiguration loginConfiguration;

  @override
  State<BaseLoginPage> createState() => _BaseLoginPageState();
}

class _BaseLoginPageState extends State<BaseLoginPage> {
  late ThemeData currentTheme;
  bool _isBusy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentTheme = Theme.of(context);
  }

  @override
  void dispose() {
    final platformBrightness = ThemeData.estimateBrightnessForColor(currentTheme.scaffoldBackgroundColor);
    final inverseBrightness = platformBrightness == Brightness.light ? Brightness.dark : Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: currentTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: inverseBrightness,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: inverseBrightness,
        statusBarBrightness: inverseBrightness,
        statusBarColor: Colors.transparent,
      ),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final isApple = Environment.platformInfo.platformDesignSystem == PlatformDesignSystem.appleHumanInterface;
    final blackWhite = isDarkTheme ? Colors.black : Colors.white;

    final buttonTextStyle = TextStyle(
      fontFamily: isApple ? "SF UI Text" : "Lexend",
      fontSize: 16,
      color: blackWhite,
    );

    final footerTextStyle = theme.textTheme.labelSmall!.copyWith(
      color: widget.loginConfiguration.footerTextColor ?? theme.colorScheme.primary,
    );

    final appleButtonStyle = TextButton.styleFrom(
      backgroundColor: isDarkTheme ? Colors.white : Colors.black,
      iconColor: blackWhite,
      textStyle: buttonTextStyle,
      elevation: 0,
    );

    final googleButtonStyle = TextButton.styleFrom(
      backgroundColor: isDarkTheme ? Colors.red : Colors.red.shade800,
      iconColor: blackWhite,
      textStyle: buttonTextStyle,
      elevation: 0,
    );

    final appleButton = TextButton.icon(
      icon: _IconPainter(painter: _AppleIconPainter(blackWhite)),
      onPressed: _isBusy
          ? null
          : () => _signIn(
                context,
                (authenticationService) => authenticationService.signInWithApple(),
              ),
      style: appleButtonStyle,
      label: Text(widget.loginConfiguration.signInWithAppleText, style: buttonTextStyle),
    );

    final googleButton = TextButton.icon(
      icon: const _IconPainter(painter: _GoogleIconPainter(Colors.white)),
      onPressed: _isBusy
          ? null
          : () => _signIn(
                context,
                (authenticationService) => authenticationService.signInWithGoogle(),
              ),
      style: googleButtonStyle,
      label: Text(
        widget.loginConfiguration.signInWithGoogleText,
        style: buttonTextStyle.copyWith(color: Colors.white),
      ),
    );

    if (widget.loginConfiguration.backgroundColor != null) {
      final platformBrightness = ThemeData.estimateBrightnessForColor(widget.loginConfiguration.backgroundColor!);
      final inverseBrightness = platformBrightness == Brightness.light ? Brightness.dark : Brightness.light;

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: widget.loginConfiguration.backgroundColor,
          systemNavigationBarIconBrightness: inverseBrightness,
          systemNavigationBarContrastEnforced: false,
          systemStatusBarContrastEnforced: false,
          statusBarIconBrightness: inverseBrightness,
          statusBarBrightness: inverseBrightness,
          statusBarColor: Colors.transparent,
        ),
      );
    }

    return Scaffold(
      backgroundColor: widget.loginConfiguration.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            widget.loginConfiguration.header,
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedCrossFade(
                duration: kTabScrollDuration,
                crossFadeState: _isBusy ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [isApple ? appleButton : googleButton, const SizedBox(height: 16), isApple ? googleButton : appleButton],
                    ),
                  ),
                ),
                secondChild: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(
                        widget.loginConfiguration.progressIndicatorColor ?? theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _isBusy ? null : _privacyPolicy,
                    child: Text(widget.loginConfiguration.privacyPolicyText, style: footerTextStyle),
                  ),
                  if (kDebugMode && widget.loginConfiguration.onDebug != null) ...[
                    const Spacer(),
                    TextButton(
                      onPressed: widget.loginConfiguration.onDebug,
                      child: Text("DEBUG", style: footerTextStyle),
                    ),
                    const Spacer(),
                  ] else
                    const Spacer(),
                  TextButton(
                    onPressed: _isBusy ? null : _termsOfUse,
                    child: Text(widget.loginConfiguration.termsOfUseText, style: footerTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _privacyPolicy() {
    _openLink(
      widget.loginConfiguration.privacyPolicyURL,
      widget.loginConfiguration.privacyPolicyText,
    ).ignore();
  }

  void _termsOfUse() {
    _openLink(
      widget.loginConfiguration.termsOfUseURL,
      widget.loginConfiguration.termsOfUseText,
    ).ignore();
  }

  Future<void> _openLink(String url, String title) async {
    final uri = Uri.parse(url);

    await UrlLauncher.launchUrl(
      uri,
      mode: UrlLauncher.LaunchMode.inAppWebView,
      webOnlyWindowName: title,
      webViewConfiguration: const UrlLauncher.WebViewConfiguration(
        enableJavaScript: false,
        enableDomStorage: false,
      ),
    );
  }

  Future<void> _signIn(BuildContext context, Future<void> Function(AuthenticationService authenticationService) handler) async {
    setState(() => _isBusy = true);

    try {
      await handler(AuthenticationService.current);

      if (widget.loginConfiguration.onAuthenticated != null) {
        widget.loginConfiguration.onAuthenticated!(AuthenticationService.current.currentPrincipalStream.value);
      }
    } catch (ex) {
      if (ex is AuthenticationException) {
        late String detailTitle;
        late String detailBody;

        switch (ex.reason) {
          case FailureReason.unavailableAuthenticationMethod:
            detailTitle = "Método indisponível";
            detailBody = "O método de autenticação escolhido não está disponível para este dispositivo.\n\n"
                "Por favor, tente se autenticar com outro método.";
            break;
          case FailureReason.unknownFailure:
            detailTitle = "Falha desconhecida";
            detailBody = ex.message;
            break;
          case FailureReason.networkError:
            detailTitle = "Servidor indisponível";
            detailBody = "Não foi possível enviar informações ao servidor por que o mesmo se "
                "encontra indisponível.\n\n"
                "Verifique sua conexão à internet ou tente novamente mais tarde."
                "${ex.message}";
            break;
          case FailureReason.userIsDisabled:
            detailTitle = "Usuário bloqueado";
            detailBody = "Este usuário encontra-se bloqueado por violações nos "
                "Termos de Uso do aplicativo.\n\n"
                "Utilize o botão Termos de Uso para maiores detalhes.";
            break;
        }

        await showOkAlertDialog(
          context: context,
          title: detailTitle,
          message: detailBody,
        );

        return;
      }

      final showDetails = await showOkCancelAlertDialog(
        context: context,
        cancelLabel: "Cancelar",
        okLabel: "Detalhes",
        message: "Não foi possível lhe autenticar no momento.",
        title: "Oops",
      );

      if (showDetails == OkCancelResult.ok) {
        await showOkAlertDialog(
          context: context,
          title: "Exceção ${ex.runtimeType}",
          message: ex.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }
}

class _IconPainter extends StatelessWidget {
  const _IconPainter({required this.painter});

  final IIconPainter painter;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: painter.offset,
      child: CustomPaint(
        painter: painter,
        isComplex: true,
        willChange: false,
        size: const Size(16, 16),
      ),
    );
  }
}

@immutable
abstract class IIconPainter implements CustomPainter {
  Size get size;
  Offset get offset;
}

@immutable
class _AppleIconPainter extends CustomPainter implements IIconPainter {
  const _AppleIconPainter(this.color);

  final Color color;

  @override
  Size get size => const Size(16, 14);

  @override
  Offset get offset => const Offset(0, -2);

  @override
  void paint(Canvas canvas, Size _) {
    final paint = Paint();
    final path = Path();

    paint.color = color;

    path.lineTo(size.width * 0.83, size.height * 1.26);

    path.cubicTo(
      size.width * 0.77,
      size.height * 1.33,
      size.width * 0.7,
      size.height * 1.31,
      size.width * 0.63,
      size.height * 1.28,
    );

    path.cubicTo(
      size.width * 0.56,
      size.height * 1.25,
      size.width * 0.49,
      size.height * 1.25,
      size.width * 0.42,
      size.height * 1.28,
    );

    path.cubicTo(
      size.width * 0.32,
      size.height * 1.33,
      size.width * 0.27,
      size.height * 1.31,
      size.width * 0.22,
      size.height * 1.26,
    );

    path.cubicTo(
      -0.11,
      size.height * 0.89,
      -0.06,
      size.height / 3,
      size.width * 0.31,
      size.height * 0.31,
    );

    path.cubicTo(
      size.width * 0.39,
      size.height * 0.32,
      size.width * 0.46,
      size.height * 0.37,
      size.width * 0.51,
      size.height * 0.37,
    );

    path.cubicTo(
      size.width * 0.59,
      size.height * 0.35,
      size.width * 0.66,
      size.height * 0.3,
      size.width * 0.74,
      size.height * 0.31,
    );

    path.cubicTo(
      size.width * 0.84,
      size.height * 0.32,
      size.width * 0.92,
      size.height * 0.36,
      size.width * 0.97,
      size.height * 0.44,
    );

    path.cubicTo(
      size.width * 0.76,
      size.height * 0.58,
      size.width * 0.81,
      size.height * 0.88,
      size.width,
      size.height * 0.96,
    );

    path.cubicTo(
      size.width * 0.96,
      size.height * 1.07,
      size.width * 0.91,
      size.height * 1.18,
      size.width * 0.83,
      size.height * 1.26,
    );

    path.cubicTo(
      size.width * 0.83,
      size.height * 1.26,
      size.width * 0.83,
      size.height * 1.26,
      size.width * 0.83,
      size.height * 1.26,
    );

    path.cubicTo(
      size.width * 0.83,
      size.height * 1.26,
      size.width * 0.83,
      size.height * 1.26,
      size.width * 0.83,
      size.height * 1.26,
    );

    canvas.drawPath(path, paint);

    path.reset();

    path.lineTo(size.width / 2, size.height * 0.31);

    path.cubicTo(
      size.width * 0.49,
      size.height * 0.15,
      size.width * 0.61,
      size.height * 0.01,
      size.width * 0.75,
      0,
    );

    path.cubicTo(
      size.width * 0.77,
      size.height * 0.19,
      size.width * 0.59,
      size.height / 3,
      size.width / 2,
      size.height * 0.31,
    );

    path.cubicTo(
      size.width / 2,
      size.height * 0.31,
      size.width / 2,
      size.height * 0.31,
      size.width / 2,
      size.height * 0.31,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as _AppleIconPainter).color != color;
  }
}

@immutable
class _GoogleIconPainter extends CustomPainter implements IIconPainter {
  const _GoogleIconPainter(this.color);

  final Color color;

  @override
  Size get size => const Size(16, 16);

  @override
  Offset get offset => const Offset(0, 0);

  @override
  void paint(Canvas canvas, Size _) {
    final paint = Paint();
    final path = Path();

    paint.color = color;
    path.lineTo(size.width, size.height * 0.42);

    path.cubicTo(
      size.width,
      size.height * 0.42,
      size.width * 0.51,
      size.height * 0.42,
      size.width * 0.51,
      size.height * 0.42,
    );

    path.cubicTo(
      size.width * 0.51,
      size.height * 0.42,
      size.width * 0.51,
      size.height * 0.61,
      size.width * 0.51,
      size.height * 0.61,
    );

    path.cubicTo(
      size.width * 0.51,
      size.height * 0.61,
      size.width * 0.79,
      size.height * 0.61,
      size.width * 0.79,
      size.height * 0.61,
    );

    path.cubicTo(
      size.width * 0.77,
      size.height * 0.67,
      size.width * 0.74,
      size.height * 0.72,
      size.width * 0.68,
      size.height * 0.76,
    );

    path.cubicTo(
      size.width * 0.68,
      size.height * 0.76,
      size.width * 0.68,
      size.height * 0.76,
      size.width * 0.68,
      size.height * 0.76,
    );

    path.cubicTo(
      size.width * 0.63,
      size.height * 0.79,
      size.width * 0.57,
      size.height * 0.8,
      size.width * 0.51,
      size.height * 0.8,
    );

    path.cubicTo(
      size.width * 0.38,
      size.height * 0.8,
      size.width * 0.27,
      size.height * 0.72,
      size.width * 0.22,
      size.height * 0.6,
    );

    path.cubicTo(
      size.width / 5,
      size.height * 0.57,
      size.width / 5,
      size.height * 0.53,
      size.width / 5,
      size.height / 2,
    );

    path.cubicTo(
      size.width / 5,
      size.height * 0.47,
      size.width / 5,
      size.height * 0.44,
      size.width * 0.22,
      size.height * 0.41,
    );

    path.cubicTo(
      size.width * 0.22,
      size.height * 0.41,
      size.width * 0.22,
      size.height * 0.41,
      size.width * 0.22,
      size.height * 0.41,
    );

    path.cubicTo(
      size.width * 0.27,
      size.height * 0.28,
      size.width * 0.38,
      size.height / 5,
      size.width * 0.51,
      size.height / 5,
    );

    path.cubicTo(
      size.width * 0.58,
      size.height / 5,
      size.width * 0.65,
      size.height * 0.22,
      size.width * 0.71,
      size.height * 0.27,
    );

    path.cubicTo(
      size.width * 0.71,
      size.height * 0.27,
      size.width * 0.85,
      size.height * 0.13,
      size.width * 0.85,
      size.height * 0.13,
    );

    path.cubicTo(
      size.width * 0.76,
      size.height * 0.04,
      size.width * 0.64,
      0,
      size.width * 0.51,
      0,
    );

    path.cubicTo(
      size.width * 0.32,
      0,
      size.width * 0.14,
      size.height * 0.11,
      size.width * 0.06,
      size.height * 0.28,
    );

    path.cubicTo(
      size.width * 0.06,
      size.height * 0.28,
      size.width * 0.06,
      size.height * 0.28,
      size.width * 0.06,
      size.height * 0.28,
    );

    path.cubicTo(
      -0.02,
      size.height * 0.42,
      -0.02,
      size.height * 0.58,
      size.width * 0.06,
      size.height * 0.72,
    );

    path.cubicTo(
      size.width * 0.14,
      size.height * 0.9,
      size.width * 0.32,
      size.height,
      size.width * 0.51,
      size.height,
    );

    path.cubicTo(
      size.width * 0.65,
      size.height,
      size.width * 0.76,
      size.height * 0.96,
      size.width * 0.85,
      size.height * 0.88,
    );

    path.cubicTo(
      size.width * 0.85,
      size.height * 0.88,
      size.width * 0.85,
      size.height * 0.88,
      size.width * 0.85,
      size.height * 0.88,
    );

    path.cubicTo(
      size.width * 0.94,
      size.height * 0.79,
      size.width,
      size.height * 0.66,
      size.width,
      size.height * 0.51,
    );

    path.cubicTo(
      size.width,
      size.height * 0.48,
      size.width,
      size.height * 0.45,
      size.width,
      size.height * 0.42,
    );

    path.cubicTo(
      size.width,
      size.height * 0.42,
      size.width,
      size.height * 0.42,
      size.width,
      size.height * 0.42,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as _GoogleIconPainter).color != color;
  }
}
