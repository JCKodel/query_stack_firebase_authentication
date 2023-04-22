// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'principal_login.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PrincipalLogin {
  AuthProvider get authProvider => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get device => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  NativePlatform get nativePlatform => throw _privateConstructorUsedError;
  DateTime get signInTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PrincipalLoginCopyWith<PrincipalLogin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrincipalLoginCopyWith<$Res> {
  factory $PrincipalLoginCopyWith(
          PrincipalLogin value, $Res Function(PrincipalLogin) then) =
      _$PrincipalLoginCopyWithImpl<$Res, PrincipalLogin>;
  @useResult
  $Res call(
      {AuthProvider authProvider,
      String deviceId,
      String model,
      String device,
      String version,
      NativePlatform nativePlatform,
      DateTime signInTime});
}

/// @nodoc
class _$PrincipalLoginCopyWithImpl<$Res, $Val extends PrincipalLogin>
    implements $PrincipalLoginCopyWith<$Res> {
  _$PrincipalLoginCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authProvider = null,
    Object? deviceId = null,
    Object? model = null,
    Object? device = null,
    Object? version = null,
    Object? nativePlatform = null,
    Object? signInTime = null,
  }) {
    return _then(_value.copyWith(
      authProvider: null == authProvider
          ? _value.authProvider
          : authProvider // ignore: cast_nullable_to_non_nullable
              as AuthProvider,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      nativePlatform: null == nativePlatform
          ? _value.nativePlatform
          : nativePlatform // ignore: cast_nullable_to_non_nullable
              as NativePlatform,
      signInTime: null == signInTime
          ? _value.signInTime
          : signInTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PrincipalLoginCopyWith<$Res>
    implements $PrincipalLoginCopyWith<$Res> {
  factory _$$_PrincipalLoginCopyWith(
          _$_PrincipalLogin value, $Res Function(_$_PrincipalLogin) then) =
      __$$_PrincipalLoginCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthProvider authProvider,
      String deviceId,
      String model,
      String device,
      String version,
      NativePlatform nativePlatform,
      DateTime signInTime});
}

/// @nodoc
class __$$_PrincipalLoginCopyWithImpl<$Res>
    extends _$PrincipalLoginCopyWithImpl<$Res, _$_PrincipalLogin>
    implements _$$_PrincipalLoginCopyWith<$Res> {
  __$$_PrincipalLoginCopyWithImpl(
      _$_PrincipalLogin _value, $Res Function(_$_PrincipalLogin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authProvider = null,
    Object? deviceId = null,
    Object? model = null,
    Object? device = null,
    Object? version = null,
    Object? nativePlatform = null,
    Object? signInTime = null,
  }) {
    return _then(_$_PrincipalLogin(
      authProvider: null == authProvider
          ? _value.authProvider
          : authProvider // ignore: cast_nullable_to_non_nullable
              as AuthProvider,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      nativePlatform: null == nativePlatform
          ? _value.nativePlatform
          : nativePlatform // ignore: cast_nullable_to_non_nullable
              as NativePlatform,
      signInTime: null == signInTime
          ? _value.signInTime
          : signInTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_PrincipalLogin implements _PrincipalLogin {
  const _$_PrincipalLogin(
      {required this.authProvider,
      required this.deviceId,
      required this.model,
      required this.device,
      required this.version,
      required this.nativePlatform,
      required this.signInTime});

  @override
  final AuthProvider authProvider;
  @override
  final String deviceId;
  @override
  final String model;
  @override
  final String device;
  @override
  final String version;
  @override
  final NativePlatform nativePlatform;
  @override
  final DateTime signInTime;

  @override
  String toString() {
    return 'PrincipalLogin(authProvider: $authProvider, deviceId: $deviceId, model: $model, device: $device, version: $version, nativePlatform: $nativePlatform, signInTime: $signInTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PrincipalLogin &&
            (identical(other.authProvider, authProvider) ||
                other.authProvider == authProvider) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.nativePlatform, nativePlatform) ||
                other.nativePlatform == nativePlatform) &&
            (identical(other.signInTime, signInTime) ||
                other.signInTime == signInTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authProvider, deviceId, model,
      device, version, nativePlatform, signInTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PrincipalLoginCopyWith<_$_PrincipalLogin> get copyWith =>
      __$$_PrincipalLoginCopyWithImpl<_$_PrincipalLogin>(this, _$identity);
}

abstract class _PrincipalLogin implements PrincipalLogin {
  const factory _PrincipalLogin(
      {required final AuthProvider authProvider,
      required final String deviceId,
      required final String model,
      required final String device,
      required final String version,
      required final NativePlatform nativePlatform,
      required final DateTime signInTime}) = _$_PrincipalLogin;

  @override
  AuthProvider get authProvider;
  @override
  String get deviceId;
  @override
  String get model;
  @override
  String get device;
  @override
  String get version;
  @override
  NativePlatform get nativePlatform;
  @override
  DateTime get signInTime;
  @override
  @JsonKey(ignore: true)
  _$$_PrincipalLoginCopyWith<_$_PrincipalLogin> get copyWith =>
      throw _privateConstructorUsedError;
}
