import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor.freezed.dart';
part 'vendor.g.dart';

@freezed
class Vendor with _$Vendor {
  const Vendor._();

  const factory Vendor({
    required String id,
    String? phone,
    String? email,
    @JsonKey(name: 'vendor_id') String? vendorId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'service_area') String? serviceArea,
    String? pincode,
    @JsonKey(name: 'service_type') String? serviceType,
    @JsonKey(name: 'profile_picture') String? profilePicture,
    @JsonKey(name: 'aadhaar_front_image') String? aadhaarFrontImage,
    @JsonKey(name: 'aadhaar_back_image') String? aadhaarBackImage,
    @JsonKey(name: 'pan_card_image') String? panCardImage,
    @JsonKey(name: 'verification_status') @Default('pending') String verificationStatus,
    @JsonKey(name: 'is_onboarding_complete') @Default(false) bool isOnboardingComplete,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'auth_user_id') String? authUserId,
    @JsonKey(name: 'fcm_token') String? fcmToken,
    @JsonKey(name: 'business_name') String? businessName,
    @JsonKey(name: 'aadhaar_number') String? aadhaarNumber,
    @JsonKey(name: 'bank_account_number') String? bankAccountNumber,
    @JsonKey(name: 'bank_ifsc_code') String? bankIfscCode,
    @JsonKey(name: 'gst_number') String? gstNumber,
  }) = _Vendor;

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  @override
  bool get isVerified => verificationStatus == 'verified';
} 