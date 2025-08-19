// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorImpl _$$VendorImplFromJson(Map<String, dynamic> json) => _$VendorImpl(
      id: json['id'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      businessName: json['business_name'] as String?,
      businessType: json['business_type'] as String?,
      vendorType: json['vendor_type'] as String? ?? 'decoration_provider',
      experienceYears: (json['experience_years'] as num?)?.toInt(),
      location: json['location'] as Map<String, dynamic>?,
      serviceArea: json['service_area'] as String?,
      additionalAddress: json['additional_address'] as String?,
      fcmToken: json['fcm_token'] as String?,
      profilePicture: json['profile_image_url'] as String?,
      businessLicenseUrl: json['business_license_url'] as String?,
      identityVerificationUrl: json['identity_verification_url'] as String?,
      portfolioImages: (json['portfolio_images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bio: json['bio'] as String?,
      availabilitySchedule:
          json['availability_schedule'] as Map<String, dynamic>?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      totalJobsCompleted: (json['total_jobs_completed'] as num?)?.toInt() ?? 0,
      verificationStatus: json['verification_status'] as String? ?? 'pending',
      isActive: json['is_active'] as bool? ?? true,
      isOnline: json['is_online'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      authUserId: json['auth_user_id'] as String?,
      isOnboardingComplete: json['is_onboarding_completed'] as bool? ?? false,
    );

Map<String, dynamic> _$$VendorImplToJson(_$VendorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'full_name': instance.fullName,
      'business_name': instance.businessName,
      'business_type': instance.businessType,
      'vendor_type': instance.vendorType,
      'experience_years': instance.experienceYears,
      'location': instance.location,
      'service_area': instance.serviceArea,
      'additional_address': instance.additionalAddress,
      'fcm_token': instance.fcmToken,
      'profile_image_url': instance.profilePicture,
      'business_license_url': instance.businessLicenseUrl,
      'identity_verification_url': instance.identityVerificationUrl,
      'portfolio_images': instance.portfolioImages,
      'bio': instance.bio,
      'availability_schedule': instance.availabilitySchedule,
      'rating': instance.rating,
      'total_reviews': instance.totalReviews,
      'total_jobs_completed': instance.totalJobsCompleted,
      'verification_status': instance.verificationStatus,
      'is_active': instance.isActive,
      'is_online': instance.isOnline,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'auth_user_id': instance.authUserId,
      'is_onboarding_completed': instance.isOnboardingComplete,
    };
