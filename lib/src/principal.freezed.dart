// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'principal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Principal {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get avatarURL => throw _privateConstructorUsedError;
  DateTime get creationTime => throw _privateConstructorUsedError;
  PrincipalLogin get lastLogin => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PrincipalCopyWith<Principal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrincipalCopyWith<$Res> {
  factory $PrincipalCopyWith(Principal value, $Res Function(Principal) then) =
      _$PrincipalCopyWithImpl<$Res, Principal>;
  @useResult
  $Res call(
      {String id,
      String displayName,
      String email,
      String avatarURL,
      DateTime creationTime,
      PrincipalLogin lastLogin});

  $PrincipalLoginCopyWith<$Res> get lastLogin;
}

/// @nodoc
class _$PrincipalCopyWithImpl<$Res, $Val extends Principal>
    implements $PrincipalCopyWith<$Res> {
  _$PrincipalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? email = null,
    Object? avatarURL = null,
    Object? creationTime = null,
    Object? lastLogin = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarURL: null == avatarURL
          ? _value.avatarURL
          : avatarURL // ignore: cast_nullable_to_non_nullable
              as String,
      creationTime: null == creationTime
          ? _value.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLogin: null == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as PrincipalLogin,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PrincipalLoginCopyWith<$Res> get lastLogin {
    return $PrincipalLoginCopyWith<$Res>(_value.lastLogin, (value) {
      return _then(_value.copyWith(lastLogin: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PrincipalCopyWith<$Res> implements $PrincipalCopyWith<$Res> {
  factory _$$_PrincipalCopyWith(
          _$_Principal value, $Res Function(_$_Principal) then) =
      __$$_PrincipalCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String displayName,
      String email,
      String avatarURL,
      DateTime creationTime,
      PrincipalLogin lastLogin});

  @override
  $PrincipalLoginCopyWith<$Res> get lastLogin;
}

/// @nodoc
class __$$_PrincipalCopyWithImpl<$Res>
    extends _$PrincipalCopyWithImpl<$Res, _$_Principal>
    implements _$$_PrincipalCopyWith<$Res> {
  __$$_PrincipalCopyWithImpl(
      _$_Principal _value, $Res Function(_$_Principal) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? email = null,
    Object? avatarURL = null,
    Object? creationTime = null,
    Object? lastLogin = null,
  }) {
    return _then(_$_Principal(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatarURL: null == avatarURL
          ? _value.avatarURL
          : avatarURL // ignore: cast_nullable_to_non_nullable
              as String,
      creationTime: null == creationTime
          ? _value.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLogin: null == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as PrincipalLogin,
    ));
  }
}

/// @nodoc

class _$_Principal extends _Principal {
  const _$_Principal(
      {required this.id,
      required this.displayName,
      required this.email,
      required this.avatarURL,
      required this.creationTime,
      required this.lastLogin})
      : super._();

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String avatarURL;
  @override
  final DateTime creationTime;
  @override
  final PrincipalLogin lastLogin;

  @override
  String toString() {
    return 'Principal(id: $id, displayName: $displayName, email: $email, avatarURL: $avatarURL, creationTime: $creationTime, lastLogin: $lastLogin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Principal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarURL, avatarURL) ||
                other.avatarURL == avatarURL) &&
            (identical(other.creationTime, creationTime) ||
                other.creationTime == creationTime) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, displayName, email, avatarURL, creationTime, lastLogin);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PrincipalCopyWith<_$_Principal> get copyWith =>
      __$$_PrincipalCopyWithImpl<_$_Principal>(this, _$identity);
}

abstract class _Principal extends Principal {
  const factory _Principal(
      {required final String id,
      required final String displayName,
      required final String email,
      required final String avatarURL,
      required final DateTime creationTime,
      required final PrincipalLogin lastLogin}) = _$_Principal;
  const _Principal._() : super._();

  @override
  String get id;
  @override
  String get displayName;
  @override
  String get email;
  @override
  String get avatarURL;
  @override
  DateTime get creationTime;
  @override
  PrincipalLogin get lastLogin;
  @override
  @JsonKey(ignore: true)
  _$$_PrincipalCopyWith<_$_Principal> get copyWith =>
      throw _privateConstructorUsedError;
}
