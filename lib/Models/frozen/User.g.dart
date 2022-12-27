// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String,
      chart1ID: json['chart1ID'] as String?,
      chart2ID: json['chart2ID'] as String?,
      chart3ID: json['chart3ID'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      correlatedUserIDs: (json['correlatedUserIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'chart1ID': instance.chart1ID,
      'chart2ID': instance.chart2ID,
      'chart3ID': instance.chart3ID,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'correlatedUserIDs': instance.correlatedUserIDs,
    };
