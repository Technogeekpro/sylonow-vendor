// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceAreaImpl _$$ServiceAreaImplFromJson(Map<String, dynamic> json) =>
    _$ServiceAreaImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      areaName: json['area_name'] as String,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postal_code'] as String?,
      coordinates: json['coordinates'] as Map<String, dynamic>?,
      radiusKm: (json['radius_km'] as num?)?.toDouble(),
      isPrimary: json['is_primary'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceAreaImplToJson(_$ServiceAreaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'area_name': instance.areaName,
      'city': instance.city,
      'state': instance.state,
      'postal_code': instance.postalCode,
      'coordinates': instance.coordinates,
      'radius_km': instance.radiusKm,
      'is_primary': instance.isPrimary,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
