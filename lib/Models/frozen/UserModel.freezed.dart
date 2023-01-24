// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'UserModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  List<String>? get correlatedUserIDs => throw _privateConstructorUsedError;
  List<String>? get chartIDs => throw _privateConstructorUsedError;
  List<int>? get associatedTabNums => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String? name,
      String? email,
      String? password,
      List<String>? correlatedUserIDs,
      List<String>? chartIDs,
      List<int>? associatedTabNums});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? correlatedUserIDs = freezed,
    Object? chartIDs = freezed,
    Object? associatedTabNums = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      chartIDs: freezed == chartIDs
          ? _value.chartIDs
          : chartIDs // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      associatedTabNums: freezed == associatedTabNums
          ? _value.associatedTabNums
          : associatedTabNums // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$$_UserModelCopyWith(
          _$_UserModel value, $Res Function(_$_UserModel) then) =
      __$$_UserModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? name,
      String? email,
      String? password,
      List<String>? correlatedUserIDs,
      List<String>? chartIDs,
      List<int>? associatedTabNums});
}

/// @nodoc
class __$$_UserModelCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$_UserModel>
    implements _$$_UserModelCopyWith<$Res> {
  __$$_UserModelCopyWithImpl(
      _$_UserModel _value, $Res Function(_$_UserModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? correlatedUserIDs = freezed,
    Object? chartIDs = freezed,
    Object? associatedTabNums = freezed,
  }) {
    return _then(_$_UserModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      chartIDs: freezed == chartIDs
          ? _value._chartIDs
          : chartIDs // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      associatedTabNums: freezed == associatedTabNums
          ? _value._associatedTabNums
          : associatedTabNums // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_UserModel extends _UserModel {
  _$_UserModel(
      {required this.id,
      this.name,
      this.email,
      this.password,
      final List<String>? correlatedUserIDs,
      final List<String>? chartIDs,
      final List<int>? associatedTabNums})
      : _correlatedUserIDs = correlatedUserIDs,
        _chartIDs = chartIDs,
        _associatedTabNums = associatedTabNums,
        super._();

  factory _$_UserModel.fromJson(Map<String, dynamic> json) =>
      _$$_UserModelFromJson(json);

  @override
  final String id;
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

  final List<String>? _chartIDs;
  @override
  List<String>? get chartIDs {
    final value = _chartIDs;
    if (value == null) return null;
    if (_chartIDs is EqualUnmodifiableListView) return _chartIDs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _associatedTabNums;
  @override
  List<int>? get associatedTabNums {
    final value = _associatedTabNums;
    if (value == null) return null;
    if (_associatedTabNums is EqualUnmodifiableListView)
      return _associatedTabNums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, password: $password, correlatedUserIDs: $correlatedUserIDs, chartIDs: $chartIDs, associatedTabNums: $associatedTabNums)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality()
                .equals(other._correlatedUserIDs, _correlatedUserIDs) &&
            const DeepCollectionEquality().equals(other._chartIDs, _chartIDs) &&
            const DeepCollectionEquality()
                .equals(other._associatedTabNums, _associatedTabNums));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      email,
      password,
      const DeepCollectionEquality().hash(_correlatedUserIDs),
      const DeepCollectionEquality().hash(_chartIDs),
      const DeepCollectionEquality().hash(_associatedTabNums));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserModelCopyWith<_$_UserModel> get copyWith =>
      __$$_UserModelCopyWithImpl<_$_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserModelToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  factory _UserModel(
      {required final String id,
      final String? name,
      final String? email,
      final String? password,
      final List<String>? correlatedUserIDs,
      final List<String>? chartIDs,
      final List<int>? associatedTabNums}) = _$_UserModel;
  _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$_UserModel.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String? get email;
  @override
  String? get password;
  @override
  List<String>? get correlatedUserIDs;
  @override
  List<String>? get chartIDs;
  @override
  List<int>? get associatedTabNums;
  @override
  @JsonKey(ignore: true)
  _$$_UserModelCopyWith<_$_UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}
