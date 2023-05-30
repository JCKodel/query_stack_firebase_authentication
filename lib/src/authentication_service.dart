import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:query_stack/query_stack.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'auth_provider.dart';
import 'authentication_exception.dart';
import 'principal.dart';
import 'principal_login.dart';

@immutable
class AuthenticationService extends BaseService {
  const AuthenticationService({
    required this.appleServiceId,
    this.appleRedirectUrl,
    required this.googleClientId,
  });

  static AuthenticationService get current => Environment.get<AuthenticationService>();

  @protected
  final String appleServiceId;

  @protected
  final String? appleRedirectUrl;

  @protected
  final String googleClientId;

  static final _principalBehaviorSubject = BehaviorSubject<Principal?>();

  ValueStream<Principal?> get currentPrincipalStream => _principalBehaviorSubject.stream;

  @override
  void initialize() {
    FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
  }

  @protected
  Future<Principal?> fetchPesistedPrincipal(String principalId) async {
    return null;
  }

  @protected
  Future<void> persistPrincipal(Principal principal) async {}

  Future<void> _onAuthStateChanged(User? user) async {
    final principal = await _userToPrincipal(user);

    if (_principalBehaviorSubject.hasValue == false ||
        _principalBehaviorSubject.value != principal) {
      _principalBehaviorSubject.add(principal);

      if (user != null) {
        FirebaseAnalytics.instance
            .logLogin(loginMethod: user.providerData.first.providerId)
            .ignore();
        FirebaseAnalytics.instance.setUserId(id: user.uid).ignore();
      }
    }
  }

  static const _unavailableDisplayName = "(nome indisponível)";
  static const _unavailableEmail = "email@indisponi.vel";

  Future<Principal?> _userToPrincipal(User? user) async {
    if (user == null) {
      return null;
    }

    final currentUser = FirebaseAuth.instance.currentUser!;

    try {
      await user.reload();
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case "network-request-failed":
          break;
        case "invalid-user-token":
        case "user-token-expired":
        case "user-disabled":
          await signOut();
          return null;
        default:
          rethrow;
      }
    }

    final authProviders = {
      GoogleAuthProvider.PROVIDER_ID: AuthProvider.google,
      AppleAuthProvider.PROVIDER_ID: AuthProvider.apple,
    };

    late AuthProvider authProvider;

    for (final providerData in FirebaseAuth.instance.currentUser!.providerData) {
      final p = authProviders[providerData.providerId];

      if (p != null) {
        authProvider = p;
        break;
      }
    }

    final principalLogin = await _getPrincipalLogin(authProvider);
    var principal = await fetchPesistedPrincipal(user.uid);

    if (principal != null) {
      principal = principal.copyWith(lastLogin: principalLogin);

      if (currentUser.displayName != principal.displayName) {
        if (currentUser.displayName == null &&
            principal.displayName != _unavailableDisplayName) {
          await currentUser.updateDisplayName(principal.displayName);
        } else if (currentUser.displayName != null &&
            principal.displayName == _unavailableDisplayName) {
          principal = principal.copyWith(displayName: currentUser.displayName!);
        }

        if (currentUser.email == null && principal.email != _unavailableEmail) {
          await currentUser.updateEmail(principal.email);
        } else if (currentUser.email != null && principal.email == _unavailableEmail) {
          principal = principal.copyWith(email: currentUser.email!);
        }

        if (currentUser.photoURL == null && principal.avatarURL.isNotEmpty) {
          await currentUser.updatePhotoURL(principal.avatarURL);
        } else if (currentUser.photoURL != null && principal.avatarURL.isEmpty) {
          principal = principal.copyWith(avatarURL: currentUser.photoURL!);
        }
      }
    } else {
      final displayName = currentUser.displayName ?? _unavailableDisplayName;
      final email = currentUser.email ?? _unavailableEmail;
      final avatarURL = currentUser.photoURL ?? "";

      principal = Principal(
        avatarURL: avatarURL,
        creationTime: currentUser.metadata.creationTime ?? DateTime.now(),
        displayName: displayName,
        email: email,
        id: currentUser.uid,
        lastLogin: principalLogin,
      );
    }

    await persistPrincipal(principal);

    return principal;
  }

  Future<PrincipalLogin> _getPrincipalLogin(AuthProvider authProvider) async {
    final deviceInfo = DeviceInfoPlugin();

    switch (Environment.platformInfo.nativePlatform) {
      case NativePlatform.android:
        return _getDeviceInfoAndroid(deviceInfo, authProvider);
      case NativePlatform.ios:
        return _getDeviceInfoiOS(deviceInfo, authProvider);
      case NativePlatform.windows:
        return _getDeviceInfoWindows(deviceInfo, authProvider);
      case NativePlatform.macos:
        return _getDeviceInfoMacOS(deviceInfo, authProvider);
      case NativePlatform.linux:
        return _getDeviceInfoLinux(deviceInfo, authProvider);
      case NativePlatform.web:
        return _getDeviceInfoWeb(deviceInfo, authProvider);
      case NativePlatform.unknown:
        throw UnimplementedError(
            "${Environment.platformInfo.nativePlatform} isn't supported");
    }
  }

  Future<PrincipalLogin> _getDeviceInfoAndroid(
      DeviceInfoPlugin deviceInfo, AuthProvider authProvider) async {
    final info = await deviceInfo.androidInfo;

    return _getDeviceInfo(
      model: info.model,
      device: info.device,
      version: info.version.sdkInt.toString(),
      nativePlatform: NativePlatform.android,
      authProvider: authProvider,
    );
  }

  Future<PrincipalLogin> _getDeviceInfoiOS(
      DeviceInfoPlugin deviceInfo, AuthProvider authProvider) async {
    final info = await deviceInfo.iosInfo;

    return _getDeviceInfo(
      model: info.model,
      device: info.utsname.machine,
      version: info.systemVersion,
      nativePlatform: NativePlatform.ios,
      authProvider: authProvider,
    );
  }

  Future<PrincipalLogin> _getDeviceInfoWindows(
      DeviceInfoPlugin deviceInfo, AuthProvider authProvider) async {
    final info = await deviceInfo.windowsInfo;

    return _getDeviceInfo(
      model: info.productName,
      device: "PC",
      version: info.displayVersion,
      nativePlatform: NativePlatform.windows,
      authProvider: authProvider,
    );
  }

  Future<PrincipalLogin> _getDeviceInfoMacOS(
      DeviceInfoPlugin deviceInfo, AuthProvider authProvider) async {
    final info = await deviceInfo.macOsInfo;

    return _getDeviceInfo(
      model: info.model,
      device: info.arch,
      version: info.osRelease,
      nativePlatform: NativePlatform.macos,
      authProvider: authProvider,
    );
  }

  Future<PrincipalLogin> _getDeviceInfoLinux(
      DeviceInfoPlugin deviceInfo, AuthProvider authProvider) async {
    final info = await deviceInfo.linuxInfo;

    return _getDeviceInfo(
      model: info.name,
      device: "PC",
      version: info.version ?? info.versionCodename ?? info.versionId ?? "0",
      nativePlatform: NativePlatform.linux,
      authProvider: authProvider,
    );
  }

  Future<PrincipalLogin> _getDeviceInfoWeb(
      DeviceInfoPlugin deviceInfo, AuthProvider authProvider) async {
    final info = await deviceInfo.webBrowserInfo;

    return _getDeviceInfo(
      model: info.browserName.name,
      device: "Web",
      version: info.appVersion ?? info.platform ?? info.userAgent ?? "0",
      nativePlatform: NativePlatform.web,
      authProvider: authProvider,
    );
  }

  Future<PrincipalLogin> _getDeviceInfo({
    required String model,
    required String device,
    required String version,
    required NativePlatform nativePlatform,
    required AuthProvider authProvider,
  }) async {
    final deviceId = await FirebaseInstallations.instance.getId();

    return PrincipalLogin(
      authProvider: authProvider,
      deviceId: deviceId,
      model: model,
      device: device,
      version: version,
      nativePlatform: nativePlatform,
      signInTime:
          FirebaseAuth.instance.currentUser?.metadata.lastSignInTime ?? DateTime.now(),
    );
  }

  Future<void> signInWithApple() async {
    try {
      await _signInWithApple();
    } on AuthenticationException catch (_) {
      rethrow;
    } on SignInWithAppleAuthorizationException catch (ex, stackTrace) {
      switch (ex.code) {
        case AuthorizationErrorCode.canceled:
          return;
        case AuthorizationErrorCode.failed:
        case AuthorizationErrorCode.invalidResponse:
        case AuthorizationErrorCode.notHandled:
        case AuthorizationErrorCode.notInteractive:
        case AuthorizationErrorCode.unknown:
          throw AuthenticationException(
            reason: FailureReason.unknownFailure,
            message: ex.message,
            stackTrace: stackTrace,
          );
      }
    } on PlatformException catch (ex, stackTrace) {
      throw AuthenticationException(
        reason: FailureReason.unknownFailure,
        message: "${ex.code}: ${ex.message ?? ex}",
        stackTrace: stackTrace,
      );
    } catch (ex, stackTrace) {
      throw AuthenticationException(
        reason: FailureReason.unknownFailure,
        message: ex.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _signInWithApple() async {
    if (await SignInWithApple.isAvailable() == false) {
      throw const AuthenticationException(
        reason: FailureReason.unavailableAuthenticationMethod,
        message: "This device doesn't support Apple Sign In.",
        stackTrace: null,
      );
    }

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: AppleIDAuthorizationScopes.values,
      webAuthenticationOptions: appleRedirectUrl == null
          ? null
          : WebAuthenticationOptions(
              clientId: appleServiceId,
              redirectUri: Uri.parse(appleRedirectUrl!),
            ),
    );

    final displayName =
        [credential.givenName ?? "", credential.familyName ?? ""].join(" ").trim();
    final oAuthProvider = OAuthProvider(AppleAuthProvider.PROVIDER_ID);

    final oAuthCredential = oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    await _signIn(
      credential: oAuthCredential,
      inAvatarURL: "",
      inDisplayName: displayName,
      inEmail: credential.email ?? "",
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      await _signInWithGoogle();
    } on AuthenticationException catch (_) {
      rethrow;
    } on PlatformException catch (ex, stackTrace) {
      throw AuthenticationException(
        reason: FailureReason.unknownFailure,
        message: "${ex.code}: ${ex.message ?? ex}",
        stackTrace: stackTrace,
      );
    } catch (ex, stackTrace) {
      throw AuthenticationException(
        reason: FailureReason.unknownFailure,
        message: ex.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    final isWebSignIn =
        Environment.platformInfo.nativePlatform != NativePlatform.android;

    final googleSignIn = GoogleSignIn(
      scopes: <String>["email"],
      hostedDomain: isWebSignIn ? googleClientId.split(".").reversed.join(".") : null,
      clientId: isWebSignIn ? googleClientId : null,
    );

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return;
    }

    final googleAuth = await googleUser.authentication;
    final oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final displayName = googleUser.displayName ?? "(n/a)";

    await _signIn(
      credential: oAuthCredential,
      inAvatarURL: googleUser.photoUrl ?? "",
      inDisplayName: displayName,
      inEmail: googleUser.email,
    );
  }

  Future<void> _signIn(
      {required OAuthCredential credential,
      required String inAvatarURL,
      required String inDisplayName,
      required String inEmail}) async {
    try {
      await __signIn(
          credential: credential,
          inAvatarURL: inAvatarURL,
          inDisplayName: inDisplayName,
          inEmail: inEmail);
    } on AuthenticationException catch (_) {
      rethrow;
    } on FirebaseAuthException catch (ex, stackTrace) {
      if (ex.code == "user-disabled") {
        throw AuthenticationException(
          reason: FailureReason.userIsDisabled,
          message: ex.message ?? ex.toString(),
          stackTrace: stackTrace,
        );
      }

      throw AuthenticationException(
        reason: FailureReason.unknownFailure,
        message: "${ex.code}: ${ex.message ?? ex}",
        stackTrace: stackTrace,
      );
    } on PlatformException catch (ex, stackTrace) {
      throw AuthenticationException(
        reason: FailureReason.unknownFailure,
        message: "${ex.code}: ${ex.message ?? ex}",
        stackTrace: stackTrace,
      );
    } catch (ex, stackTrace) {
      throw AuthenticationException(
        reason: FailureReason.unknownFailure,
        message: ex.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> __signIn(
      {required OAuthCredential credential,
      required String inAvatarURL,
      required String inDisplayName,
      required String inEmail}) async {
    final oAuthProvider = OAuthProvider(credential.providerId);

    final oAuthCredential = oAuthProvider.credential(
      signInMethod: credential.signInMethod,
      accessToken: credential.accessToken,
      idToken: credential.idToken,
      rawNonce: credential.rawNonce,
      secret: credential.secret,
    );

    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }

    final currentUser =
        (await FirebaseAuth.instance.signInWithCredential(oAuthCredential)).user;

    if (currentUser == null) {
      return;
    }

    if (inDisplayName.isNotEmpty) {
      await currentUser.updateDisplayName(inDisplayName);
    }

    if (inEmail.isNotEmpty) {
      await currentUser.updateEmail(inEmail);
    }

    if (inAvatarURL.isNotEmpty) {
      await currentUser.updatePhotoURL(inAvatarURL);
    } else if (currentUser.photoURL == "") {
      await currentUser.updatePhotoURL(inAvatarURL);
    }

    await currentUser.reload();
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    await FirebaseAuth.instance.signOut();
  }
}
