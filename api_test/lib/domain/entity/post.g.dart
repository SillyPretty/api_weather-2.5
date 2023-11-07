// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      name: json['name'] as String,
      main: json['main'] as Map<String, dynamic>,
      sys: json['sys'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'name': instance.name,
      'main': instance.main,
      'sys': instance.sys,
    };
