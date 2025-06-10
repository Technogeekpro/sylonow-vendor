// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorImpl _$$VendorImplFromJson(Map<String, dynamic> json) => _$VendorImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String?,
      mobileNumber: json['mobile_number'] as String,
      fullName: json['full_name'] as String,
      serviceArea: json['service_area'] as String?,
      pincode: json['pincode'] as String?,
      serviceType: json['service_type'] as String?,
      profilePicture: json['profile_picture'] as String?,
      aadhaarFrontImage: json['aadhaar_front_image'] as String?,
      aadhaarBackImage: json['aadhaar_back_image'] as String?,
      panCardImage: json['pan_card_image'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isOnboardingComplete: json['is_onboarding_complete'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      authUserId: json['auth_user_id'] as String?,
      fcmToken: json['fcm_token'] as String?,
      businessName: json['business_name'] as String?,
      aadhaarNumber: json['aadhaar_number'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,
      bankIfscCode: json['bank_ifsc_code'] as String?,
      gstNumber: json['gst_number'] as String?,
    );

Map<String, dynamic> _$$VendorImplToJson(_$VendorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'mobile_number': instance.mobileNumber,
      'full_name': instance.fullName,
      'service_area': instance.serviceArea,
      'pincode': instance.pincode,
      'service_type': instance.serviceType,
      'profile_picture': instance.profilePicture,
      'aadhaar_front_image': instance.aadhaarFrontImage,
      'aadhaar_back_image': instance.aadhaarBackImage,
      'pan_card_image': instance.panCardImage,
      'is_verified': instance.isVerified,
      'is_onboarding_complete': instance.isOnboardingComplete,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'auth_user_id': instance.authUserId,
      'fcm_token': instance.fcmToken,
      'business_name': instance.businessName,
      'aadhaar_number': instance.aadhaarNumber,
      'bank_account_number': instance.bankAccountNumber,
      'bank_ifsc_code': instance.bankIfscCode,
      'gst_number': instance.gstNumber,
    };
