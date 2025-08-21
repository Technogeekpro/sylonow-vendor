// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TheaterScreenImpl _$$TheaterScreenImplFromJson(Map<String, dynamic> json) =>
    _$TheaterScreenImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      screenName: json['screen_name'] as String,
      screenNumber: (json['screen_number'] as num).toInt(),
      totalCapacity: (json['total_capacity'] as num?)?.toInt() ?? 0,
      allowedCapacity: (json['allowed_capacity'] as num?)?.toInt() ?? 0,
      chargesExtraPerPerson:
          (json['charges_extra_per_person'] as num?)?.toDouble() ?? 0.0,
      videoUrl: json['video_url'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      originalHourlyPrice:
          (json['original_hourly_price'] as num?)?.toDouble() ?? 0.0,
      discountedHourlyPrice:
          (json['discounted_hourly_price'] as num?)?.toDouble() ?? 0.0,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TheaterScreenImplToJson(_$TheaterScreenImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'screen_name': instance.screenName,
      'screen_number': instance.screenNumber,
      'total_capacity': instance.totalCapacity,
      'allowed_capacity': instance.allowedCapacity,
      'charges_extra_per_person': instance.chargesExtraPerPerson,
      'video_url': instance.videoUrl,
      'images': instance.images,
      'original_hourly_price': instance.originalHourlyPrice,
      'discounted_hourly_price': instance.discountedHourlyPrice,
      'amenities': instance.amenities,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
