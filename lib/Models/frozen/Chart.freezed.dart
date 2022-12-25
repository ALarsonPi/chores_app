// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'Chart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Chart _$ChartFromJson(Map<String, dynamic> json) {
  return _Chart.fromJson(json);
}

/// @nodoc
mixin _$Chart {
  String get id => throw _privateConstructorUsedError;
  String get chartTitle => throw _privateConstructorUsedError;
  int get numberOfRings => throw _privateConstructorUsedError;
  List<String> get circleOneText => throw _privateConstructorUsedError;
  List<String> get circleTwoText => throw _privateConstructorUsedError;
  List<String>? get circleThreeText => throw _privateConstructorUsedError;
  int? get chartColorIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChartCopyWith<Chart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartCopyWith<$Res> {
  factory $ChartCopyWith(Chart value, $Res Function(Chart) then) =
      _$ChartCopyWithImpl<$Res, Chart>;
  @useResult
  $Res call(
      {String id,
      String chartTitle,
      int numberOfRings,
      List<String> circleOneText,
      List<String> circleTwoText,
      List<String>? circleThreeText,
      int? chartColorIndex});
}

/// @nodoc
class _$ChartCopyWithImpl<$Res, $Val extends Chart>
    implements $ChartCopyWith<$Res> {
  _$ChartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chartTitle = null,
    Object? numberOfRings = null,
    Object? circleOneText = null,
    Object? circleTwoText = null,
    Object? circleThreeText = freezed,
    Object? chartColorIndex = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chartTitle: null == chartTitle
          ? _value.chartTitle
          : chartTitle // ignore: cast_nullable_to_non_nullable
              as String,
      numberOfRings: null == numberOfRings
          ? _value.numberOfRings
          : numberOfRings // ignore: cast_nullable_to_non_nullable
              as int,
      circleOneText: null == circleOneText
          ? _value.circleOneText
          : circleOneText // ignore: cast_nullable_to_non_nullable
              as List<String>,
      circleTwoText: null == circleTwoText
          ? _value.circleTwoText
          : circleTwoText // ignore: cast_nullable_to_non_nullable
              as List<String>,
      circleThreeText: freezed == circleThreeText
          ? _value.circleThreeText
          : circleThreeText // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      chartColorIndex: freezed == chartColorIndex
          ? _value.chartColorIndex
          : chartColorIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChartCopyWith<$Res> implements $ChartCopyWith<$Res> {
  factory _$$_ChartCopyWith(_$_Chart value, $Res Function(_$_Chart) then) =
      __$$_ChartCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String chartTitle,
      int numberOfRings,
      List<String> circleOneText,
      List<String> circleTwoText,
      List<String>? circleThreeText,
      int? chartColorIndex});
}

/// @nodoc
class __$$_ChartCopyWithImpl<$Res> extends _$ChartCopyWithImpl<$Res, _$_Chart>
    implements _$$_ChartCopyWith<$Res> {
  __$$_ChartCopyWithImpl(_$_Chart _value, $Res Function(_$_Chart) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chartTitle = null,
    Object? numberOfRings = null,
    Object? circleOneText = null,
    Object? circleTwoText = null,
    Object? circleThreeText = freezed,
    Object? chartColorIndex = freezed,
  }) {
    return _then(_$_Chart(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chartTitle: null == chartTitle
          ? _value.chartTitle
          : chartTitle // ignore: cast_nullable_to_non_nullable
              as String,
      numberOfRings: null == numberOfRings
          ? _value.numberOfRings
          : numberOfRings // ignore: cast_nullable_to_non_nullable
              as int,
      circleOneText: null == circleOneText
          ? _value._circleOneText
          : circleOneText // ignore: cast_nullable_to_non_nullable
              as List<String>,
      circleTwoText: null == circleTwoText
          ? _value._circleTwoText
          : circleTwoText // ignore: cast_nullable_to_non_nullable
              as List<String>,
      circleThreeText: freezed == circleThreeText
          ? _value._circleThreeText
          : circleThreeText // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      chartColorIndex: freezed == chartColorIndex
          ? _value.chartColorIndex
          : chartColorIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Chart extends _Chart {
  _$_Chart(
      {required this.id,
      required this.chartTitle,
      required this.numberOfRings,
      required final List<String> circleOneText,
      required final List<String> circleTwoText,
      final List<String>? circleThreeText,
      this.chartColorIndex})
      : _circleOneText = circleOneText,
        _circleTwoText = circleTwoText,
        _circleThreeText = circleThreeText,
        super._();

  factory _$_Chart.fromJson(Map<String, dynamic> json) =>
      _$$_ChartFromJson(json);

  @override
  final String id;
  @override
  final String chartTitle;
  @override
  final int numberOfRings;
  final List<String> _circleOneText;
  @override
  List<String> get circleOneText {
    if (_circleOneText is EqualUnmodifiableListView) return _circleOneText;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_circleOneText);
  }

  final List<String> _circleTwoText;
  @override
  List<String> get circleTwoText {
    if (_circleTwoText is EqualUnmodifiableListView) return _circleTwoText;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_circleTwoText);
  }

  final List<String>? _circleThreeText;
  @override
  List<String>? get circleThreeText {
    final value = _circleThreeText;
    if (value == null) return null;
    if (_circleThreeText is EqualUnmodifiableListView) return _circleThreeText;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? chartColorIndex;

  @override
  String toString() {
    return 'Chart(id: $id, chartTitle: $chartTitle, numberOfRings: $numberOfRings, circleOneText: $circleOneText, circleTwoText: $circleTwoText, circleThreeText: $circleThreeText, chartColorIndex: $chartColorIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Chart &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chartTitle, chartTitle) ||
                other.chartTitle == chartTitle) &&
            (identical(other.numberOfRings, numberOfRings) ||
                other.numberOfRings == numberOfRings) &&
            const DeepCollectionEquality()
                .equals(other._circleOneText, _circleOneText) &&
            const DeepCollectionEquality()
                .equals(other._circleTwoText, _circleTwoText) &&
            const DeepCollectionEquality()
                .equals(other._circleThreeText, _circleThreeText) &&
            (identical(other.chartColorIndex, chartColorIndex) ||
                other.chartColorIndex == chartColorIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      chartTitle,
      numberOfRings,
      const DeepCollectionEquality().hash(_circleOneText),
      const DeepCollectionEquality().hash(_circleTwoText),
      const DeepCollectionEquality().hash(_circleThreeText),
      chartColorIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChartCopyWith<_$_Chart> get copyWith =>
      __$$_ChartCopyWithImpl<_$_Chart>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChartToJson(
      this,
    );
  }
}

abstract class _Chart extends Chart {
  factory _Chart(
      {required final String id,
      required final String chartTitle,
      required final int numberOfRings,
      required final List<String> circleOneText,
      required final List<String> circleTwoText,
      final List<String>? circleThreeText,
      final int? chartColorIndex}) = _$_Chart;
  _Chart._() : super._();

  factory _Chart.fromJson(Map<String, dynamic> json) = _$_Chart.fromJson;

  @override
  String get id;
  @override
  String get chartTitle;
  @override
  int get numberOfRings;
  @override
  List<String> get circleOneText;
  @override
  List<String> get circleTwoText;
  @override
  List<String>? get circleThreeText;
  @override
  int? get chartColorIndex;
  @override
  @JsonKey(ignore: true)
  _$$_ChartCopyWith<_$_Chart> get copyWith =>
      throw _privateConstructorUsedError;
}
