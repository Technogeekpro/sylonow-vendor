import 'package:freezed_annotation/freezed_annotation.dart';

part 'private_theater.freezed.dart';
part 'private_theater.g.dart';

@freezed
class PrivateTheater with _$PrivateTheater {
  const factory PrivateTheater({
    required String id,
    required String name,
    String? description,
    required String address,
    required String city,
    required String state,
    @JsonKey(name: 'pin_code') required String pinCode,
    double? latitude,
    double? longitude,
    int? capacity,
    @Default([]) List<String> amenities,
    @Default([]) List<String> images,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'hourly_rate') @Default(0.0) double hourlyRate,
    @Default(4.5) double rating,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'owner_id') String? ownerId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'available_time_slots') @Default([]) List<Map<String, dynamic>> availableTimeSlots,
    @JsonKey(name: 'booking_duration_hours') @Default(2) int bookingDurationHours,
    @JsonKey(name: 'advance_booking_days') @Default(30) int advanceBookingDays,
    @JsonKey(name: 'cancellation_policy') @Default('Free cancellation up to 24 hours before the booking') String cancellationPolicy,
  
  // Admin approval fields
  @JsonKey(name: 'approval_status') @Default('pending') String approvalStatus, // 'pending', 'approved', 'rejected'
  @JsonKey(name: 'approved_at') DateTime? approvedAt,
  @JsonKey(name: 'rejected_at') DateTime? rejectedAt,
  @JsonKey(name: 'admin_notes') String? adminNotes,
  @JsonKey(name: 'contact_name') String? contactName,
  @JsonKey(name: 'contact_phone') String? contactPhone,
  
  // Theater theme fields
  @JsonKey(name: 'theme_name') String? themeName,
  @JsonKey(name: 'theme_primary_color') String? themePrimaryColor,
  @JsonKey(name: 'theme_secondary_color') String? themeSecondaryColor,
  @JsonKey(name: 'theme_background_image') String? themeBackgroundImage,
  @JsonKey(name: 'extra_charges_per_person') @Default(0.0) double extraChargesPerPerson,
  }) = _PrivateTheater;

  factory PrivateTheater.fromJson(Map<String, dynamic> json) => _$PrivateTheaterFromJson(json);
}