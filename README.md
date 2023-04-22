# Query Stack Firebase Authentication

A Firebase Authentication service for [Query Stack](https://pub.dev/packages/query_stack)

# Usage

Just register the `AuthenticationService` on your environment:

```dart
@immutable
class DevelopmentEnvironment extends Environment {
  const DevelopmentEnvironment();

  @override
  void registerDependencies(RegisterDependenciesDelegate when, PlatformInfo platformInfo) {
    when<AuthenticationService>(
      (get) => AuthenticationService(
        appleRedirectUrl: platformInfo.nativePlatform.when(
          onAndroid: () => "redirect url when using android",
          onWeb: () => "redirect url when using web",
          orElse: () => null,
        ),
        appleServiceId: "apple sign in service id",
        googleClientId: platformInfo.nativePlatform.when(
          onAndroid: () => "google client id for android",
          oniOS: () => "google client id for ios",
          onWeb: () => "google client id for web",
          orElse: () => throw UnsupportedError("${platformInfo.nativePlatform} is not supported"),
        ),
      ),
    );

    // register the rest of your dependencies
  }
```

You can inherit `AuthenticationService` and override the methods `fetchPesistedPrincipal` and `persistPrincipal`
if you want to, for instance, save your authenticated user in your database.

## Principal

An authenticated user is called `Principal` and has the same properties of Firebase Authentication user: 
id, displayName, email, avatarURL (photoURL in firebase), creationTime and lastLogin.

lastLogin is a `PrincipalLogin` class with authProvider (Google or Apple), the current
device id, model, device, version (i.e.: Android 13), platform (ios, Android, etc.) and
last sign in time.
