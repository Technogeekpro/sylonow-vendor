import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_listing.freezed.dart';
part 'service_listing.g.dart';

@freezed
class ServiceListing with _$ServiceListing {
  const factory ServiceListing({
    required String id,
    @JsonKey(name: 'listing_id') required String listingId,
    @JsonKey(name: 'vendor_id') required String vendorId,
    
    // Basic Info
    String? title,
    String? category,
    @JsonKey(name: 'theme_tags') @Default([]) List<String> themeTags,
    
    // Service Environment
    @JsonKey(name: 'service_environment') @Default([]) List<String> serviceEnvironment,
    
    // Media Upload
    @JsonKey(name: 'cover_photo') String? coverPhoto,
    @Default([]) List<String> photos,
    @JsonKey(name: 'video_url') String? videoUrl,
    
    // Pricing (add-ons moved to separate table)
    @JsonKey(name: 'original_price') required double originalPrice,
    @JsonKey(name: 'offer_price') required double offerPrice,
    @JsonKey(name: 'promotional_tag') String? promotionalTag,
    
    // Details
    String? description,
    @Default([]) List<String> inclusions,
    @JsonKey(name: 'customization_available') @Default(false) bool customizationAvailable,
    @JsonKey(name: 'customization_note') String? customizationNote,
    @JsonKey(name: 'setup_time') required String setupTime,
    @JsonKey(name: 'booking_notice') required String bookingNotice,
    
    // Location (populate from vendor data)
    double? latitude,
    double? longitude,
    
    // Area
    @Default([]) List<String> pincodes,
    @JsonKey(name: 'venue_types') @Default([]) List<String> venueTypes,
    
    // Status and metadata
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ServiceListing;

  factory ServiceListing.fromJson(Map<String, dynamic> json) => _$ServiceListingFromJson(json);
} 