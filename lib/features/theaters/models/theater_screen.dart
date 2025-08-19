import 'package:freezed_annotation/freezed_annotation.dart';

part 'theater_screen.freezed.dart';
part 'theater_screen.g.dart';

@freezed
class TheaterScreen with _$TheaterScreen {
  const factory TheaterScreen({
    required String id,
    @JsonKey(name: 'theater_id') required String theaterId,
    @JsonKey(name: 'screen_name') required String screenName,
    @JsonKey(name: 'screen_number') required int screenNumber,
    @JsonKey(name: 'total_capacity') @Default(0) int totalCapacity,
    @JsonKey(name: 'allowed_capacity') @Default(0) int allowedCapacity,
    @JsonKey(name: 'charges_extra_per_person') @Default(0.0) double chargesExtraPerPerson,
    @JsonKey(name: 'video_url') String? videoUrl,
    @Default([]) List<String> images,
    @JsonKey(name: 'original_hourly_price') @Default(0.0) double originalHourlyPrice,
    @JsonKey(name: 'discounted_hourly_price') @Default(0.0) double discountedHourlyPrice,
    @Default([]) List<String> amenities,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _TheaterScreen;

  factory TheaterScreen.fromJson(Map<String, dynamic> json) => _$TheaterScreenFromJson(json);
}