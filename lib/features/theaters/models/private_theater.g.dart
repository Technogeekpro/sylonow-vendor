// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_theater.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrivateTheaterImpl _$$PrivateTheaterImplFromJson(Map<String, dynamic> json) =>
    _$PrivateTheaterImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pinCode: json['pin_code'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      capacity: (json['capacity'] as num?)?.toInt(),
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoUrl: json['video_url'] as String?,
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      ownerId: json['owner_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      availableTimeSlots: (json['available_time_slots'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      bookingDurationHours:
          (json['booking_duration_hours'] as num?)?.toInt() ?? 2,
      advanceBookingDays: (json['advance_booking_days'] as num?)?.toInt() ?? 30,
      cancellationPolicy: json['cancellation_policy'] as String? ??
          'Free cancellation up to 24 hours before the booking',
      approvalStatus: json['approval_status'] as String? ?? 'pending',
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      rejectedAt: json['rejected_at'] == null
          ? null
          : DateTime.parse(json['rejected_at'] as String),
      adminNotes: json['admin_notes'] as String?,
      contactName: json['contact_name'] as String?,
      contactPhone: json['contact_phone'] as String?,
      themeName: json['theme_name'] as String?,
      themePrimaryColor: json['theme_primary_color'] as String?,
      themeSecondaryColor: json['theme_secondary_color'] as String?,
      themeBackgroundImage: json['theme_background_image'] as String?,
      extraChargesPerPerson:
          (json['extra_charges_per_person'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$PrivateTheaterImplToJson(
        _$PrivateTheaterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'pin_code': instance.pinCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'capacity': instance.capacity,
      'amenities': instance.amenities,
      'images': instance.images,
      'video_url': instance.videoUrl,
      'hourly_rate': instance.hourlyRate,
      'rating': instance.rating,
      'total_reviews': instance.totalReviews,
      'is_active': instance.isActive,
      'owner_id': instance.ownerId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'available_time_slots': instance.availableTimeSlots,
      'booking_duration_hours': instance.bookingDurationHours,
      'advance_booking_days': instance.advanceBookingDays,
      'cancellation_policy': instance.cancellationPolicy,
      'approval_status': instance.approvalStatus,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'rejected_at': instance.rejectedAt?.toIso8601String(),
      'admin_notes': instance.adminNotes,
      'contact_name': instance.contactName,
      'contact_phone': instance.contactPhone,
      'theme_name': instance.themeName,
      'theme_primary_color': instance.themePrimaryColor,
      'theme_secondary_color': instance.themeSecondaryColor,
      'theme_background_image': instance.themeBackgroundImage,
      'extra_charges_per_person': instance.extraChargesPerPerson,
    };
