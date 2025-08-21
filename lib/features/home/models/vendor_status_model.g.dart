// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorStatusModelImpl _$$VendorStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VendorStatusModelImpl(
      vendorId: json['vendor_id'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      isOnboardingComplete: json['is_onboarding_complete'] as bool? ?? false,
      verificationStatus: json['verification_status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$VendorStatusModelImplToJson(
        _$VendorStatusModelImpl instance) =>
    <String, dynamic>{
      'vendor_id': instance.vendorId,
      'is_verified': instance.isVerified,
      'is_onboarding_complete': instance.isOnboardingComplete,
      'verification_status': instance.verificationStatus,
      'rejection_reason': instance.rejectionReason,
      'last_login': instance.lastLogin?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
