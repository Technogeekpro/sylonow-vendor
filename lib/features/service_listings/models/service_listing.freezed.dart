// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceListing _$ServiceListingFromJson(Map<String, dynamic> json) {
  return _ServiceListing.fromJson(json);
}

/// @nodoc
mixin _$ServiceListing {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'listing_id')
  String get listingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError; // Basic Info
  String? get title => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'theme_tags')
  List<String> get themeTags =>
      throw _privateConstructorUsedError; // Service Environment
  @JsonKey(name: 'service_environment')
  List<String> get serviceEnvironment =>
      throw _privateConstructorUsedError; // Media Upload
  @JsonKey(name: 'cover_photo')
  String? get coverPhoto => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl =>
      throw _privateConstructorUsedError; // Pricing (add-ons moved to separate table)
  @JsonKey(name: 'original_price')
  double get originalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'offer_price')
  double get offerPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'promotional_tag')
  String? get promotionalTag => throw _privateConstructorUsedError; // Details
  String? get description => throw _privateConstructorUsedError;
  List<String> get inclusions => throw _privateConstructorUsedError;
  @JsonKey(name: 'customization_available')
  bool get customizationAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'customization_note')
  String? get customizationNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'setup_time')
  String get setupTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_notice')
  String get bookingNotice =>
      throw _privateConstructorUsedError; // Location (populate from vendor data)
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError; // Area
  List<String> get pincodes => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_types')
  List<String> get venueTypes =>
      throw _privateConstructorUsedError; // Status and metadata
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceListingCopyWith<ServiceListing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceListingCopyWith<$Res> {
  factory $ServiceListingCopyWith(
          ServiceListing value, $Res Function(ServiceListing) then) =
      _$ServiceListingCopyWithImpl<$Res, ServiceListing>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'listing_id') String listingId,
      @JsonKey(name: 'vendor_id') String vendorId,
      String? title,
      String? category,
      @JsonKey(name: 'theme_tags') List<String> themeTags,
      @JsonKey(name: 'service_environment') List<String> serviceEnvironment,
      @JsonKey(name: 'cover_photo') String? coverPhoto,
      List<String> photos,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'original_price') double originalPrice,
      @JsonKey(name: 'offer_price') double offerPrice,
      @JsonKey(name: 'promotional_tag') String? promotionalTag,
      String? description,
      List<String> inclusions,
      @JsonKey(name: 'customization_available') bool customizationAvailable,
      @JsonKey(name: 'customization_note') String? customizationNote,
      @JsonKey(name: 'setup_time') String setupTime,
      @JsonKey(name: 'booking_notice') String bookingNotice,
      double? latitude,
      double? longitude,
      List<String> pincodes,
      @JsonKey(name: 'venue_types') List<String> venueTypes,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$ServiceListingCopyWithImpl<$Res, $Val extends ServiceListing>
    implements $ServiceListingCopyWith<$Res> {
  _$ServiceListingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listingId = null,
    Object? vendorId = null,
    Object? title = freezed,
    Object? category = freezed,
    Object? themeTags = null,
    Object? serviceEnvironment = null,
    Object? coverPhoto = freezed,
    Object? photos = null,
    Object? videoUrl = freezed,
    Object? originalPrice = null,
    Object? offerPrice = null,
    Object? promotionalTag = freezed,
    Object? description = freezed,
    Object? inclusions = null,
    Object? customizationAvailable = null,
    Object? customizationNote = freezed,
    Object? setupTime = null,
    Object? bookingNotice = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? pincodes = null,
    Object? venueTypes = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      themeTags: null == themeTags
          ? _value.themeTags
          : themeTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      serviceEnvironment: null == serviceEnvironment
          ? _value.serviceEnvironment
          : serviceEnvironment // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverPhoto: freezed == coverPhoto
          ? _value.coverPhoto
          : coverPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      offerPrice: null == offerPrice
          ? _value.offerPrice
          : offerPrice // ignore: cast_nullable_to_non_nullable
              as double,
      promotionalTag: freezed == promotionalTag
          ? _value.promotionalTag
          : promotionalTag // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      inclusions: null == inclusions
          ? _value.inclusions
          : inclusions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      customizationAvailable: null == customizationAvailable
          ? _value.customizationAvailable
          : customizationAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      customizationNote: freezed == customizationNote
          ? _value.customizationNote
          : customizationNote // ignore: cast_nullable_to_non_nullable
              as String?,
      setupTime: null == setupTime
          ? _value.setupTime
          : setupTime // ignore: cast_nullable_to_non_nullable
              as String,
      bookingNotice: null == bookingNotice
          ? _value.bookingNotice
          : bookingNotice // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      pincodes: null == pincodes
          ? _value.pincodes
          : pincodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueTypes: null == venueTypes
          ? _value.venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceListingImplCopyWith<$Res>
    implements $ServiceListingCopyWith<$Res> {
  factory _$$ServiceListingImplCopyWith(_$ServiceListingImpl value,
          $Res Function(_$ServiceListingImpl) then) =
      __$$ServiceListingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'listing_id') String listingId,
      @JsonKey(name: 'vendor_id') String vendorId,
      String? title,
      String? category,
      @JsonKey(name: 'theme_tags') List<String> themeTags,
      @JsonKey(name: 'service_environment') List<String> serviceEnvironment,
      @JsonKey(name: 'cover_photo') String? coverPhoto,
      List<String> photos,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'original_price') double originalPrice,
      @JsonKey(name: 'offer_price') double offerPrice,
      @JsonKey(name: 'promotional_tag') String? promotionalTag,
      String? description,
      List<String> inclusions,
      @JsonKey(name: 'customization_available') bool customizationAvailable,
      @JsonKey(name: 'customization_note') String? customizationNote,
      @JsonKey(name: 'setup_time') String setupTime,
      @JsonKey(name: 'booking_notice') String bookingNotice,
      double? latitude,
      double? longitude,
      List<String> pincodes,
      @JsonKey(name: 'venue_types') List<String> venueTypes,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$ServiceListingImplCopyWithImpl<$Res>
    extends _$ServiceListingCopyWithImpl<$Res, _$ServiceListingImpl>
    implements _$$ServiceListingImplCopyWith<$Res> {
  __$$ServiceListingImplCopyWithImpl(
      _$ServiceListingImpl _value, $Res Function(_$ServiceListingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listingId = null,
    Object? vendorId = null,
    Object? title = freezed,
    Object? category = freezed,
    Object? themeTags = null,
    Object? serviceEnvironment = null,
    Object? coverPhoto = freezed,
    Object? photos = null,
    Object? videoUrl = freezed,
    Object? originalPrice = null,
    Object? offerPrice = null,
    Object? promotionalTag = freezed,
    Object? description = freezed,
    Object? inclusions = null,
    Object? customizationAvailable = null,
    Object? customizationNote = freezed,
    Object? setupTime = null,
    Object? bookingNotice = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? pincodes = null,
    Object? venueTypes = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ServiceListingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      themeTags: null == themeTags
          ? _value._themeTags
          : themeTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      serviceEnvironment: null == serviceEnvironment
          ? _value._serviceEnvironment
          : serviceEnvironment // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverPhoto: freezed == coverPhoto
          ? _value.coverPhoto
          : coverPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      offerPrice: null == offerPrice
          ? _value.offerPrice
          : offerPrice // ignore: cast_nullable_to_non_nullable
              as double,
      promotionalTag: freezed == promotionalTag
          ? _value.promotionalTag
          : promotionalTag // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      inclusions: null == inclusions
          ? _value._inclusions
          : inclusions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      customizationAvailable: null == customizationAvailable
          ? _value.customizationAvailable
          : customizationAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      customizationNote: freezed == customizationNote
          ? _value.customizationNote
          : customizationNote // ignore: cast_nullable_to_non_nullable
              as String?,
      setupTime: null == setupTime
          ? _value.setupTime
          : setupTime // ignore: cast_nullable_to_non_nullable
              as String,
      bookingNotice: null == bookingNotice
          ? _value.bookingNotice
          : bookingNotice // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      pincodes: null == pincodes
          ? _value._pincodes
          : pincodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      venueTypes: null == venueTypes
          ? _value._venueTypes
          : venueTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceListingImpl implements _ServiceListing {
  const _$ServiceListingImpl(
      {required this.id,
      @JsonKey(name: 'listing_id') required this.listingId,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      this.title,
      this.category,
      @JsonKey(name: 'theme_tags') final List<String> themeTags = const [],
      @JsonKey(name: 'service_environment')
      final List<String> serviceEnvironment = const [],
      @JsonKey(name: 'cover_photo') this.coverPhoto,
      final List<String> photos = const [],
      @JsonKey(name: 'video_url') this.videoUrl,
      @JsonKey(name: 'original_price') required this.originalPrice,
      @JsonKey(name: 'offer_price') required this.offerPrice,
      @JsonKey(name: 'promotional_tag') this.promotionalTag,
      this.description,
      final List<String> inclusions = const [],
      @JsonKey(name: 'customization_available')
      this.customizationAvailable = false,
      @JsonKey(name: 'customization_note') this.customizationNote,
      @JsonKey(name: 'setup_time') required this.setupTime,
      @JsonKey(name: 'booking_notice') required this.bookingNotice,
      this.latitude,
      this.longitude,
      final List<String> pincodes = const [],
      @JsonKey(name: 'venue_types') final List<String> venueTypes = const [],
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_featured') this.isFeatured = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _themeTags = themeTags,
        _serviceEnvironment = serviceEnvironment,
        _photos = photos,
        _inclusions = inclusions,
        _pincodes = pincodes,
        _venueTypes = venueTypes;

  factory _$ServiceListingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceListingImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'listing_id')
  final String listingId;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
// Basic Info
  @override
  final String? title;
  @override
  final String? category;
  final List<String> _themeTags;
  @override
  @JsonKey(name: 'theme_tags')
  List<String> get themeTags {
    if (_themeTags is EqualUnmodifiableListView) return _themeTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_themeTags);
  }

// Service Environment
  final List<String> _serviceEnvironment;
// Service Environment
  @override
  @JsonKey(name: 'service_environment')
  List<String> get serviceEnvironment {
    if (_serviceEnvironment is EqualUnmodifiableListView)
      return _serviceEnvironment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceEnvironment);
  }

// Media Upload
  @override
  @JsonKey(name: 'cover_photo')
  final String? coverPhoto;
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
// Pricing (add-ons moved to separate table)
  @override
  @JsonKey(name: 'original_price')
  final double originalPrice;
  @override
  @JsonKey(name: 'offer_price')
  final double offerPrice;
  @override
  @JsonKey(name: 'promotional_tag')
  final String? promotionalTag;
// Details
  @override
  final String? description;
  final List<String> _inclusions;
  @override
  @JsonKey()
  List<String> get inclusions {
    if (_inclusions is EqualUnmodifiableListView) return _inclusions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inclusions);
  }

  @override
  @JsonKey(name: 'customization_available')
  final bool customizationAvailable;
  @override
  @JsonKey(name: 'customization_note')
  final String? customizationNote;
  @override
  @JsonKey(name: 'setup_time')
  final String setupTime;
  @override
  @JsonKey(name: 'booking_notice')
  final String bookingNotice;
// Location (populate from vendor data)
  @override
  final double? latitude;
  @override
  final double? longitude;
// Area
  final List<String> _pincodes;
// Area
  @override
  @JsonKey()
  List<String> get pincodes {
    if (_pincodes is EqualUnmodifiableListView) return _pincodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pincodes);
  }

  final List<String> _venueTypes;
  @override
  @JsonKey(name: 'venue_types')
  List<String> get venueTypes {
    if (_venueTypes is EqualUnmodifiableListView) return _venueTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_venueTypes);
  }

// Status and metadata
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ServiceListing(id: $id, listingId: $listingId, vendorId: $vendorId, title: $title, category: $category, themeTags: $themeTags, serviceEnvironment: $serviceEnvironment, coverPhoto: $coverPhoto, photos: $photos, videoUrl: $videoUrl, originalPrice: $originalPrice, offerPrice: $offerPrice, promotionalTag: $promotionalTag, description: $description, inclusions: $inclusions, customizationAvailable: $customizationAvailable, customizationNote: $customizationNote, setupTime: $setupTime, bookingNotice: $bookingNotice, latitude: $latitude, longitude: $longitude, pincodes: $pincodes, venueTypes: $venueTypes, isActive: $isActive, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceListingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._themeTags, _themeTags) &&
            const DeepCollectionEquality()
                .equals(other._serviceEnvironment, _serviceEnvironment) &&
            (identical(other.coverPhoto, coverPhoto) ||
                other.coverPhoto == coverPhoto) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.offerPrice, offerPrice) ||
                other.offerPrice == offerPrice) &&
            (identical(other.promotionalTag, promotionalTag) ||
                other.promotionalTag == promotionalTag) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._inclusions, _inclusions) &&
            (identical(other.customizationAvailable, customizationAvailable) ||
                other.customizationAvailable == customizationAvailable) &&
            (identical(other.customizationNote, customizationNote) ||
                other.customizationNote == customizationNote) &&
            (identical(other.setupTime, setupTime) ||
                other.setupTime == setupTime) &&
            (identical(other.bookingNotice, bookingNotice) ||
                other.bookingNotice == bookingNotice) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._pincodes, _pincodes) &&
            const DeepCollectionEquality()
                .equals(other._venueTypes, _venueTypes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        listingId,
        vendorId,
        title,
        category,
        const DeepCollectionEquality().hash(_themeTags),
        const DeepCollectionEquality().hash(_serviceEnvironment),
        coverPhoto,
        const DeepCollectionEquality().hash(_photos),
        videoUrl,
        originalPrice,
        offerPrice,
        promotionalTag,
        description,
        const DeepCollectionEquality().hash(_inclusions),
        customizationAvailable,
        customizationNote,
        setupTime,
        bookingNotice,
        latitude,
        longitude,
        const DeepCollectionEquality().hash(_pincodes),
        const DeepCollectionEquality().hash(_venueTypes),
        isActive,
        isFeatured,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceListingImplCopyWith<_$ServiceListingImpl> get copyWith =>
      __$$ServiceListingImplCopyWithImpl<_$ServiceListingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceListingImplToJson(
      this,
    );
  }
}

abstract class _ServiceListing implements ServiceListing {
  const factory _ServiceListing(
          {required final String id,
          @JsonKey(name: 'listing_id') required final String listingId,
          @JsonKey(name: 'vendor_id') required final String vendorId,
          final String? title,
          final String? category,
          @JsonKey(name: 'theme_tags') final List<String> themeTags,
          @JsonKey(name: 'service_environment')
          final List<String> serviceEnvironment,
          @JsonKey(name: 'cover_photo') final String? coverPhoto,
          final List<String> photos,
          @JsonKey(name: 'video_url') final String? videoUrl,
          @JsonKey(name: 'original_price') required final double originalPrice,
          @JsonKey(name: 'offer_price') required final double offerPrice,
          @JsonKey(name: 'promotional_tag') final String? promotionalTag,
          final String? description,
          final List<String> inclusions,
          @JsonKey(name: 'customization_available')
          final bool customizationAvailable,
          @JsonKey(name: 'customization_note') final String? customizationNote,
          @JsonKey(name: 'setup_time') required final String setupTime,
          @JsonKey(name: 'booking_notice') required final String bookingNotice,
          final double? latitude,
          final double? longitude,
          final List<String> pincodes,
          @JsonKey(name: 'venue_types') final List<String> venueTypes,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'is_featured') final bool isFeatured,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$ServiceListingImpl;

  factory _ServiceListing.fromJson(Map<String, dynamic> json) =
      _$ServiceListingImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'listing_id')
  String get listingId;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override // Basic Info
  String? get title;
  @override
  String? get category;
  @override
  @JsonKey(name: 'theme_tags')
  List<String> get themeTags;
  @override // Service Environment
  @JsonKey(name: 'service_environment')
  List<String> get serviceEnvironment;
  @override // Media Upload
  @JsonKey(name: 'cover_photo')
  String? get coverPhoto;
  @override
  List<String> get photos;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override // Pricing (add-ons moved to separate table)
  @JsonKey(name: 'original_price')
  double get originalPrice;
  @override
  @JsonKey(name: 'offer_price')
  double get offerPrice;
  @override
  @JsonKey(name: 'promotional_tag')
  String? get promotionalTag;
  @override // Details
  String? get description;
  @override
  List<String> get inclusions;
  @override
  @JsonKey(name: 'customization_available')
  bool get customizationAvailable;
  @override
  @JsonKey(name: 'customization_note')
  String? get customizationNote;
  @override
  @JsonKey(name: 'setup_time')
  String get setupTime;
  @override
  @JsonKey(name: 'booking_notice')
  String get bookingNotice;
  @override // Location (populate from vendor data)
  double? get latitude;
  @override
  double? get longitude;
  @override // Area
  List<String> get pincodes;
  @override
  @JsonKey(name: 'venue_types')
  List<String> get venueTypes;
  @override // Status and metadata
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_featured')
  bool get isFeatured;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ServiceListingImplCopyWith<_$ServiceListingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
