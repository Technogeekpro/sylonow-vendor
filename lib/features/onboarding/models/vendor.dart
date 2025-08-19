import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor.freezed.dart';
part 'vendor.g.dart';

@freezed
class Vendor with _$Vendor {
  const Vendor._();

  const factory Vendor({
    String? id,
    String? email,
    String? phone,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'business_name') String? businessName,
    @JsonKey(name: 'business_type') String? businessType,
    @JsonKey(name: 'vendor_type') @Default('decoration_provider') String vendorType,
    @JsonKey(name: 'experience_years') int? experienceYears,
    @JsonKey(name: 'location') Map<String, dynamic>? location,
    @JsonKey(name: 'service_area') String? serviceArea,
    @JsonKey(name: 'additional_address') String? additionalAddress,
    @JsonKey(name: 'fcm_token') String? fcmToken,
    @JsonKey(name: 'profile_image_url') String? profilePicture,
    @JsonKey(name: 'business_license_url') String? businessLicenseUrl,
    @JsonKey(name: 'identity_verification_url') String? identityVerificationUrl,
    @JsonKey(name: 'portfolio_images') List<String>? portfolioImages,
    String? bio,
    @JsonKey(name: 'availability_schedule') Map<String, dynamic>? availabilitySchedule,
    @Default(0.0) double rating,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'total_jobs_completed') @Default(0) int totalJobsCompleted,
    @JsonKey(name: 'verification_status') @Default('pending') String verificationStatus,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_online') @Default(true) bool isOnline,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'auth_user_id') String? authUserId,
    @JsonKey(name: 'is_onboarding_completed') @Default(false) bool isOnboardingComplete,
  }) = _Vendor;

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  @override
  bool get isVerified => verificationStatus == 'verified';

  // Generate a vendor ID from the actual ID
  @override
  String? get vendorId => id != null ? 'VND${id!.substring(0, 8).toUpperCase()}' : null;

  // Helper methods for vendor type checking
  @override
  bool get isTheaterProvider => vendorType == 'theater_provider';

  @override
  bool get isDecorationProvider => vendorType == 'decoration_provider';
} 