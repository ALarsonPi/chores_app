// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Chart _$$_ChartFromJson(Map<String, dynamic> json) => _$_Chart(
      id: json['id'] as String,
      chartTitle: json['chartTitle'] as String,
      numberOfRings: json['numberOfRings'] as int,
      circleOneText: (json['circleOneText'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      circleTwoText: (json['circleTwoText'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      ownerIDs:
          (json['ownerIDs'] as List<dynamic>).map((e) => e as String).toList(),
      editorIDs:
          (json['editorIDs'] as List<dynamic>).map((e) => e as String).toList(),
      viewerIDs:
          (json['viewerIDs'] as List<dynamic>).map((e) => e as String).toList(),
      pendingIDs: (json['pendingIDs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      circleThreeText: (json['circleThreeText'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$_ChartToJson(_$_Chart instance) => <String, dynamic>{
      'id': instance.id,
      'chartTitle': instance.chartTitle,
      'numberOfRings': instance.numberOfRings,
      'circleOneText': instance.circleOneText,
      'circleTwoText': instance.circleTwoText,
      'ownerIDs': instance.ownerIDs,
      'editorIDs': instance.editorIDs,
      'viewerIDs': instance.viewerIDs,
      'pendingIDs': instance.pendingIDs,
      'circleThreeText': instance.circleThreeText,
    };
