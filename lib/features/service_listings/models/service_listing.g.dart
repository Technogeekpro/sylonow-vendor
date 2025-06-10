// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceListingImpl _$$ServiceListingImplFromJson(Map<String, dynamic> json) =>
    _$ServiceListingImpl(
      id: json['id'] as String,
      listingId: json['listing_id'] as String,
      vendorId: json['vendor_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      themeTags: (json['theme_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      serviceEnvironment: (json['service_environment'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      coverPhoto: json['cover_photo'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoUrl: json['video_url'] as String?,
      originalPrice: (json['original_price'] as num).toDouble(),
      offerPrice: (json['offer_price'] as num).toDouble(),
      addOns: (json['add_ons'] as List<dynamic>?)
              ?.map((e) => AddOn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      promotionalTag: json['promotional_tag'] as String?,
      description: json['description'] as String?,
      inclusions: (json['inclusions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      customizationAvailable: json['customization_available'] as bool? ?? false,
      customizationNote: json['customization_note'] as String?,
      setupTime: json['setup_time'] as String,
      bookingNotice: json['booking_notice'] as String,
      pincodes: (json['pincodes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      venueTypes: (json['venue_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceListingImplToJson(
        _$ServiceListingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listing_id': instance.listingId,
      'vendor_id': instance.vendorId,
      'title': instance.title,
      'category': instance.category,
      'theme_tags': instance.themeTags,
      'service_environment': instance.serviceEnvironment,
      'cover_photo': instance.coverPhoto,
      'photos': instance.photos,
      'video_url': instance.videoUrl,
      'original_price': instance.originalPrice,
      'offer_price': instance.offerPrice,
      'add_ons': instance.addOns,
      'promotional_tag': instance.promotionalTag,
      'description': instance.description,
      'inclusions': instance.inclusions,
      'customization_available': instance.customizationAvailable,
      'customization_note': instance.customizationNote,
      'setup_time': instance.setupTime,
      'booking_notice': instance.bookingNotice,
      'pincodes': instance.pincodes,
      'venue_types': instance.venueTypes,
      'is_active': instance.isActive,
      'is_featured': instance.isFeatured,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
