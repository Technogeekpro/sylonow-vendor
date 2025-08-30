// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_on.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddOnImpl _$$AddOnImplFromJson(Map<String, dynamic> json) => _$AddOnImpl(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      isFree: json['is_free'] as bool? ?? false,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$AddOnImplToJson(_$AddOnImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'is_free': instance.isFree,
      'description': instance.description,
    };
