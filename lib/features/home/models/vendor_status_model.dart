import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_status_model.freezed.dart';
part 'vendor_status_model.g.dart';

@freezed
class VendorStatusModel with _$VendorStatusModel {
  const factory VendorStatusModel({
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'is_onboarding_complete') @Default(false) bool isOnboardingComplete,
    @JsonKey(name: 'verification_status') @Default('pending') String verificationStatus, // pending, approved, rejected
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _VendorStatusModel;

  factory VendorStatusModel.fromJson(Map<String, dynamic> json) =>
      _$VendorStatusModelFromJson(json);
} 