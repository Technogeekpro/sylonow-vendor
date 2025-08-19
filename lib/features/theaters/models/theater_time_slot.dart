import 'package:freezed_annotation/freezed_annotation.dart';

part 'theater_time_slot.freezed.dart';
part 'theater_time_slot.g.dart';

@freezed
class TheaterTimeSlot with _$TheaterTimeSlot {
  const factory TheaterTimeSlot({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'screen_id') String? screenId,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'price_multiplier') @Default(1.0) double priceMultiplier,
    @JsonKey(name: 'base_price') @Default(0.0) double basePrice,
    @JsonKey(name: 'price_per_hour') @Default(0.0) double pricePerHour,
    @JsonKey(name: 'weekday_multiplier') @Default(1.0) double weekdayMultiplier,
    @JsonKey(name: 'weekend_multiplier') @Default(1.5) double weekendMultiplier,
    @JsonKey(name: 'holiday_multiplier') @Default(2.0) double holidayMultiplier,
    @JsonKey(name: 'max_duration_hours') int? maxDurationHours,
    @JsonKey(name: 'min_duration_hours') int? minDurationHours,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TheaterTimeSlot;

  factory TheaterTimeSlot.fromJson(Map<String, dynamic> json) => _$TheaterTimeSlotFromJson(json);
}