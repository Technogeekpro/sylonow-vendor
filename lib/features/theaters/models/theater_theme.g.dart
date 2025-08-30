// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TheaterThemeImpl _$$TheaterThemeImplFromJson(Map<String, dynamic> json) =>
    _$TheaterThemeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      backgroundImageUrl: json['backgroundImageUrl'] as String,
      previewImageUrl: json['previewImageUrl'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$TheaterThemeImplToJson(_$TheaterThemeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'backgroundImageUrl': instance.backgroundImageUrl,
      'previewImageUrl': instance.previewImageUrl,
      'isActive': instance.isActive,
    };
