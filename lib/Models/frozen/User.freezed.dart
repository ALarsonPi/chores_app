// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'User.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String? get chart1ID => throw _privateConstructorUsedError;
  String? get chart2ID => throw _privateConstructorUsedError;
  String? get chart3ID => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  List<String>? get correlatedUserIDs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String? chart1ID,
      String? chart2ID,
      String? chart3ID,
      String? name,
      String? email,
      String? password,
      List<String>? correlatedUserIDs});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chart1ID = freezed,
    Object? chart2ID = freezed,
    Object? chart3ID = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? correlatedUserIDs = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chart1ID: freezed == chart1ID
          ? _value.chart1ID
          : chart1ID // ignore: cast_nullable_to_non_nullable
              as String?,
      chart2ID: freezed == chart2ID
          ? _value.chart2ID
          : chart2ID // ignore: cast_nullable_to_non_nullable
              as String?,
      chart3ID: freezed == chart3ID
          ? _value.chart3ID
          : chart3ID // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      correlatedUserIDs: freezed == correlatedUserIDs
          ? _value.correlatedUserIDs
          : correlatedUserIDs // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? chart1ID,
      String? chart2ID,
      String? chart3ID,
      String? name,
      String? email,
      String? password,
      List<String>? correlatedUserIDs});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chart1ID = freezed,
    Object? chart2ID = freezed,
    Object? chart3ID = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? correlatedUserIDs = freezed,
  }) {
    return _then(_$_User(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chart1ID: freezed == chart1ID
          ? _value.chart1ID
          : chart1ID // ignore: cast_nullable_to_non_nullable
              as String?,
      chart2ID: freezed == chart2ID
          ? _value.chart2ID
          : chart2ID // ignore: cast_nullable_to_non_nullable
              as String?,
      chart3ID: freezed == chart3ID
          ? _value.chart3ID
          : chart3ID // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      correlatedUserIDs: freezed == correlatedUserIDs
          ? _value._correlatedUserIDs
          : correlatedUserIDs // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_User extends _User {
  _$_User(
      {required this.id,
      this.chart1ID,
      this.chart2ID,
      this.chart3ID,
      this.name,
      this.email,
      this.password,
      final List<String>? correlatedUserIDs})
      : _correlatedUserIDs = correlatedUserIDs,
        super._();

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String id;
  @override
  final String? chart1ID;
  @override
  final String? chart2ID;
  @override
  final String? chart3ID;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? password;
  final List<String>? _correlatedUserIDs;
  @override
  List<String>? get correlatedUserIDs {
    final value = _correlatedUserIDs;
    if (value == null) return null;
    if (_correlatedUserIDs is EqualUnmodifiableListView)
      return _correlatedUserIDs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'User(id: $id, chart1ID: $chart1ID, chart2ID: $chart2ID, chart3ID: $chart3ID, name: $name, email: $email, password: $password, correlatedUserIDs: $correlatedUserIDs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chart1ID, chart1ID) ||
                other.chart1ID == chart1ID) &&
            (identical(other.chart2ID, chart2ID) ||
                other.chart2ID == chart2ID) &&
            (identical(other.chart3ID, chart3ID) ||
                other.chart3ID == chart3ID) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality()
                .equals(other._correlatedUserIDs, _correlatedUserIDs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      chart1ID,
      chart2ID,
      chart3ID,
      name,
      email,
      password,
      const DeepCollectionEquality().hash(_correlatedUserIDs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User extends User {
  factory _User(
      {required final String id,
      final String? chart1ID,
      final String? chart2ID,
      final String? chart3ID,
      final String? name,
      final String? email,
      final String? password,
      final List<String>? correlatedUserIDs}) = _$_User;
  _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get id;
  @override
  String? get chart1ID;
  @override
  String? get chart2ID;
  @override
  String? get chart3ID;
  @override
  String? get name;
  @override
  String? get email;
  @override
  String? get password;
  @override
  List<String>? get correlatedUserIDs;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
