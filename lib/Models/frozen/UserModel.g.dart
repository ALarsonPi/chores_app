// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      correlatedUserIDs: (json['correlatedUserIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      chartIDs: (json['chartIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      associatedTabNums: (json['associatedTabNums'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'correlatedUserIDs': instance.correlatedUserIDs,
      'chartIDs': instance.chartIDs,
      'associatedTabNums': instance.associatedTabNums,
    };
