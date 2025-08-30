// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_time_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TheaterTimeSlotImpl _$$TheaterTimeSlotImplFromJson(
        Map<String, dynamic> json) =>
    _$TheaterTimeSlotImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      screenId: json['screen_id'] as String?,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
      priceMultiplier: (json['price_multiplier'] as num?)?.toDouble() ?? 1.0,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
      pricePerHour: (json['price_per_hour'] as num?)?.toDouble() ?? 0.0,
      weekdayMultiplier:
          (json['weekday_multiplier'] as num?)?.toDouble() ?? 1.0,
      weekendMultiplier:
          (json['weekend_multiplier'] as num?)?.toDouble() ?? 1.5,
      holidayMultiplier:
          (json['holiday_multiplier'] as num?)?.toDouble() ?? 2.0,
      maxDurationHours: (json['max_duration_hours'] as num?)?.toInt(),
      minDurationHours: (json['min_duration_hours'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TheaterTimeSlotImplToJson(
        _$TheaterTimeSlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'screen_id': instance.screenId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'is_available': instance.isAvailable,
      'price_multiplier': instance.priceMultiplier,
      'base_price': instance.basePrice,
      'price_per_hour': instance.pricePerHour,
      'weekday_multiplier': instance.weekdayMultiplier,
      'weekend_multiplier': instance.weekendMultiplier,
      'holiday_multiplier': instance.holidayMultiplier,
      'max_duration_hours': instance.maxDurationHours,
      'min_duration_hours': instance.minDurationHours,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
