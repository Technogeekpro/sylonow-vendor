// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Vendor _$VendorFromJson(Map<String, dynamic> json) {
  return _Vendor.fromJson(json);
}

/// @nodoc
mixin _$Vendor {
  String? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_name')
  String? get businessName => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_type')
  String? get businessType => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_type')
  String get vendorType => throw _privateConstructorUsedError;
  @JsonKey(name: 'experience_years')
  int? get experienceYears => throw _privateConstructorUsedError;
  @JsonKey(name: 'location')
  Map<String, dynamic>? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_area')
  String? get serviceArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'additional_address')
  String? get additionalAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'fcm_token')
  String? get fcmToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image_url')
  String? get profilePicture => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_license_url')
  String? get businessLicenseUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'identity_verification_url')
  String? get identityVerificationUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'portfolio_images')
  List<String>? get portfolioImages => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'availability_schedule')
  Map<String, dynamic>? get availabilitySchedule =>
      throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reviews')
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_jobs_completed')
  int get totalJobsCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'verification_status')
  String get verificationStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_online')
  bool get isOnline => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'auth_user_id')
  String? get authUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_onboarding_completed')
  bool get isOnboardingComplete => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VendorCopyWith<Vendor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorCopyWith<$Res> {
  factory $VendorCopyWith(Vendor value, $Res Function(Vendor) then) =
      _$VendorCopyWithImpl<$Res, Vendor>;
  @useResult
  $Res call(
      {String? id,
      String? email,
      String? phone,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'business_name') String? businessName,
      @JsonKey(name: 'business_type') String? businessType,
      @JsonKey(name: 'vendor_type') String vendorType,
      @JsonKey(name: 'experience_years') int? experienceYears,
      @JsonKey(name: 'location') Map<String, dynamic>? location,
      @JsonKey(name: 'service_area') String? serviceArea,
      @JsonKey(name: 'additional_address') String? additionalAddress,
      @JsonKey(name: 'fcm_token') String? fcmToken,
      @JsonKey(name: 'profile_image_url') String? profilePicture,
      @JsonKey(name: 'business_license_url') String? businessLicenseUrl,
      @JsonKey(name: 'identity_verification_url')
      String? identityVerificationUrl,
      @JsonKey(name: 'portfolio_images') List<String>? portfolioImages,
      String? bio,
      @JsonKey(name: 'availability_schedule')
      Map<String, dynamic>? availabilitySchedule,
      double rating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'total_jobs_completed') int totalJobsCompleted,
      @JsonKey(name: 'verification_status') String verificationStatus,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_online') bool isOnline,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'auth_user_id') String? authUserId,
      @JsonKey(name: 'is_onboarding_completed') bool isOnboardingComplete});
}

/// @nodoc
class _$VendorCopyWithImpl<$Res, $Val extends Vendor>
    implements $VendorCopyWith<$Res> {
  _$VendorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? businessName = freezed,
    Object? businessType = freezed,
    Object? vendorType = null,
    Object? experienceYears = freezed,
    Object? location = freezed,
    Object? serviceArea = freezed,
    Object? additionalAddress = freezed,
    Object? fcmToken = freezed,
    Object? profilePicture = freezed,
    Object? businessLicenseUrl = freezed,
    Object? identityVerificationUrl = freezed,
    Object? portfolioImages = freezed,
    Object? bio = freezed,
    Object? availabilitySchedule = freezed,
    Object? rating = null,
    Object? totalReviews = null,
    Object? totalJobsCompleted = null,
    Object? verificationStatus = null,
    Object? isActive = null,
    Object? isOnline = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? authUserId = freezed,
    Object? isOnboardingComplete = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorType: null == vendorType
          ? _value.vendorType
          : vendorType // ignore: cast_nullable_to_non_nullable
              as String,
      experienceYears: freezed == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      serviceArea: freezed == serviceArea
          ? _value.serviceArea
          : serviceArea // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalAddress: freezed == additionalAddress
          ? _value.additionalAddress
          : additionalAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      businessLicenseUrl: freezed == businessLicenseUrl
          ? _value.businessLicenseUrl
          : businessLicenseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      identityVerificationUrl: freezed == identityVerificationUrl
          ? _value.identityVerificationUrl
          : identityVerificationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioImages: freezed == portfolioImages
          ? _value.portfolioImages
          : portfolioImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      availabilitySchedule: freezed == availabilitySchedule
          ? _value.availabilitySchedule
          : availabilitySchedule // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalJobsCompleted: null == totalJobsCompleted
          ? _value.totalJobsCompleted
          : totalJobsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      authUserId: freezed == authUserId
          ? _value.authUserId
          : authUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnboardingComplete: null == isOnboardingComplete
          ? _value.isOnboardingComplete
          : isOnboardingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VendorImplCopyWith<$Res> implements $VendorCopyWith<$Res> {
  factory _$$VendorImplCopyWith(
          _$VendorImpl value, $Res Function(_$VendorImpl) then) =
      __$$VendorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? email,
      String? phone,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'business_name') String? businessName,
      @JsonKey(name: 'business_type') String? businessType,
      @JsonKey(name: 'vendor_type') String vendorType,
      @JsonKey(name: 'experience_years') int? experienceYears,
      @JsonKey(name: 'location') Map<String, dynamic>? location,
      @JsonKey(name: 'service_area') String? serviceArea,
      @JsonKey(name: 'additional_address') String? additionalAddress,
      @JsonKey(name: 'fcm_token') String? fcmToken,
      @JsonKey(name: 'profile_image_url') String? profilePicture,
      @JsonKey(name: 'business_license_url') String? businessLicenseUrl,
      @JsonKey(name: 'identity_verification_url')
      String? identityVerificationUrl,
      @JsonKey(name: 'portfolio_images') List<String>? portfolioImages,
      String? bio,
      @JsonKey(name: 'availability_schedule')
      Map<String, dynamic>? availabilitySchedule,
      double rating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'total_jobs_completed') int totalJobsCompleted,
      @JsonKey(name: 'verification_status') String verificationStatus,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_online') bool isOnline,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'auth_user_id') String? authUserId,
      @JsonKey(name: 'is_onboarding_completed') bool isOnboardingComplete});
}

/// @nodoc
class __$$VendorImplCopyWithImpl<$Res>
    extends _$VendorCopyWithImpl<$Res, _$VendorImpl>
    implements _$$VendorImplCopyWith<$Res> {
  __$$VendorImplCopyWithImpl(
      _$VendorImpl _value, $Res Function(_$VendorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? businessName = freezed,
    Object? businessType = freezed,
    Object? vendorType = null,
    Object? experienceYears = freezed,
    Object? location = freezed,
    Object? serviceArea = freezed,
    Object? additionalAddress = freezed,
    Object? fcmToken = freezed,
    Object? profilePicture = freezed,
    Object? businessLicenseUrl = freezed,
    Object? identityVerificationUrl = freezed,
    Object? portfolioImages = freezed,
    Object? bio = freezed,
    Object? availabilitySchedule = freezed,
    Object? rating = null,
    Object? totalReviews = null,
    Object? totalJobsCompleted = null,
    Object? verificationStatus = null,
    Object? isActive = null,
    Object? isOnline = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? authUserId = freezed,
    Object? isOnboardingComplete = null,
  }) {
    return _then(_$VendorImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessType: freezed == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorType: null == vendorType
          ? _value.vendorType
          : vendorType // ignore: cast_nullable_to_non_nullable
              as String,
      experienceYears: freezed == experienceYears
          ? _value.experienceYears
          : experienceYears // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      serviceArea: freezed == serviceArea
          ? _value.serviceArea
          : serviceArea // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalAddress: freezed == additionalAddress
          ? _value.additionalAddress
          : additionalAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      businessLicenseUrl: freezed == businessLicenseUrl
          ? _value.businessLicenseUrl
          : businessLicenseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      identityVerificationUrl: freezed == identityVerificationUrl
          ? _value.identityVerificationUrl
          : identityVerificationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioImages: freezed == portfolioImages
          ? _value._portfolioImages
          : portfolioImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      availabilitySchedule: freezed == availabilitySchedule
          ? _value._availabilitySchedule
          : availabilitySchedule // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalJobsCompleted: null == totalJobsCompleted
          ? _value.totalJobsCompleted
          : totalJobsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      authUserId: freezed == authUserId
          ? _value.authUserId
          : authUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      isOnboardingComplete: null == isOnboardingComplete
          ? _value.isOnboardingComplete
          : isOnboardingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorImpl extends _Vendor {
  const _$VendorImpl(
      {this.id,
      this.email,
      this.phone,
      @JsonKey(name: 'full_name') this.fullName,
      @JsonKey(name: 'business_name') this.businessName,
      @JsonKey(name: 'business_type') this.businessType,
      @JsonKey(name: 'vendor_type') this.vendorType = 'decoration_provider',
      @JsonKey(name: 'experience_years') this.experienceYears,
      @JsonKey(name: 'location') final Map<String, dynamic>? location,
      @JsonKey(name: 'service_area') this.serviceArea,
      @JsonKey(name: 'additional_address') this.additionalAddress,
      @JsonKey(name: 'fcm_token') this.fcmToken,
      @JsonKey(name: 'profile_image_url') this.profilePicture,
      @JsonKey(name: 'business_license_url') this.businessLicenseUrl,
      @JsonKey(name: 'identity_verification_url') this.identityVerificationUrl,
      @JsonKey(name: 'portfolio_images') final List<String>? portfolioImages,
      this.bio,
      @JsonKey(name: 'availability_schedule')
      final Map<String, dynamic>? availabilitySchedule,
      this.rating = 0.0,
      @JsonKey(name: 'total_reviews') this.totalReviews = 0,
      @JsonKey(name: 'total_jobs_completed') this.totalJobsCompleted = 0,
      @JsonKey(name: 'verification_status') this.verificationStatus = 'pending',
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_online') this.isOnline = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'auth_user_id') this.authUserId,
      @JsonKey(name: 'is_onboarding_completed')
      this.isOnboardingComplete = false})
      : _location = location,
        _portfolioImages = portfolioImages,
        _availabilitySchedule = availabilitySchedule,
        super._();

  factory _$VendorImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorImplFromJson(json);

  @override
  final String? id;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  @JsonKey(name: 'business_name')
  final String? businessName;
  @override
  @JsonKey(name: 'business_type')
  final String? businessType;
  @override
  @JsonKey(name: 'vendor_type')
  final String vendorType;
  @override
  @JsonKey(name: 'experience_years')
  final int? experienceYears;
  final Map<String, dynamic>? _location;
  @override
  @JsonKey(name: 'location')
  Map<String, dynamic>? get location {
    final value = _location;
    if (value == null) return null;
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'service_area')
  final String? serviceArea;
  @override
  @JsonKey(name: 'additional_address')
  final String? additionalAddress;
  @override
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;
  @override
  @JsonKey(name: 'profile_image_url')
  final String? profilePicture;
  @override
  @JsonKey(name: 'business_license_url')
  final String? businessLicenseUrl;
  @override
  @JsonKey(name: 'identity_verification_url')
  final String? identityVerificationUrl;
  final List<String>? _portfolioImages;
  @override
  @JsonKey(name: 'portfolio_images')
  List<String>? get portfolioImages {
    final value = _portfolioImages;
    if (value == null) return null;
    if (_portfolioImages is EqualUnmodifiableListView) return _portfolioImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? bio;
  final Map<String, dynamic>? _availabilitySchedule;
  @override
  @JsonKey(name: 'availability_schedule')
  Map<String, dynamic>? get availabilitySchedule {
    final value = _availabilitySchedule;
    if (value == null) return null;
    if (_availabilitySchedule is EqualUnmodifiableMapView)
      return _availabilitySchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  @override
  @JsonKey(name: 'total_jobs_completed')
  final int totalJobsCompleted;
  @override
  @JsonKey(name: 'verification_status')
  final String verificationStatus;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_online')
  final bool isOnline;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'auth_user_id')
  final String? authUserId;
  @override
  @JsonKey(name: 'is_onboarding_completed')
  final bool isOnboardingComplete;

  @override
  String toString() {
    return 'Vendor(id: $id, email: $email, phone: $phone, fullName: $fullName, businessName: $businessName, businessType: $businessType, vendorType: $vendorType, experienceYears: $experienceYears, location: $location, serviceArea: $serviceArea, additionalAddress: $additionalAddress, fcmToken: $fcmToken, profilePicture: $profilePicture, businessLicenseUrl: $businessLicenseUrl, identityVerificationUrl: $identityVerificationUrl, portfolioImages: $portfolioImages, bio: $bio, availabilitySchedule: $availabilitySchedule, rating: $rating, totalReviews: $totalReviews, totalJobsCompleted: $totalJobsCompleted, verificationStatus: $verificationStatus, isActive: $isActive, isOnline: $isOnline, createdAt: $createdAt, updatedAt: $updatedAt, authUserId: $authUserId, isOnboardingComplete: $isOnboardingComplete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessType, businessType) ||
                other.businessType == businessType) &&
            (identical(other.vendorType, vendorType) ||
                other.vendorType == vendorType) &&
            (identical(other.experienceYears, experienceYears) ||
                other.experienceYears == experienceYears) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.serviceArea, serviceArea) ||
                other.serviceArea == serviceArea) &&
            (identical(other.additionalAddress, additionalAddress) ||
                other.additionalAddress == additionalAddress) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.businessLicenseUrl, businessLicenseUrl) ||
                other.businessLicenseUrl == businessLicenseUrl) &&
            (identical(
                    other.identityVerificationUrl, identityVerificationUrl) ||
                other.identityVerificationUrl == identityVerificationUrl) &&
            const DeepCollectionEquality()
                .equals(other._portfolioImages, _portfolioImages) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._availabilitySchedule, _availabilitySchedule) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.totalJobsCompleted, totalJobsCompleted) ||
                other.totalJobsCompleted == totalJobsCompleted) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.authUserId, authUserId) ||
                other.authUserId == authUserId) &&
            (identical(other.isOnboardingComplete, isOnboardingComplete) ||
                other.isOnboardingComplete == isOnboardingComplete));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        email,
        phone,
        fullName,
        businessName,
        businessType,
        vendorType,
        experienceYears,
        const DeepCollectionEquality().hash(_location),
        serviceArea,
        additionalAddress,
        fcmToken,
        profilePicture,
        businessLicenseUrl,
        identityVerificationUrl,
        const DeepCollectionEquality().hash(_portfolioImages),
        bio,
        const DeepCollectionEquality().hash(_availabilitySchedule),
        rating,
        totalReviews,
        totalJobsCompleted,
        verificationStatus,
        isActive,
        isOnline,
        createdAt,
        updatedAt,
        authUserId,
        isOnboardingComplete
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorImplCopyWith<_$VendorImpl> get copyWith =>
      __$$VendorImplCopyWithImpl<_$VendorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorImplToJson(
      this,
    );
  }
}

abstract class _Vendor extends Vendor {
  const factory _Vendor(
      {final String? id,
      final String? email,
      final String? phone,
      @JsonKey(name: 'full_name') final String? fullName,
      @JsonKey(name: 'business_name') final String? businessName,
      @JsonKey(name: 'business_type') final String? businessType,
      @JsonKey(name: 'vendor_type') final String vendorType,
      @JsonKey(name: 'experience_years') final int? experienceYears,
      @JsonKey(name: 'location') final Map<String, dynamic>? location,
      @JsonKey(name: 'service_area') final String? serviceArea,
      @JsonKey(name: 'additional_address') final String? additionalAddress,
      @JsonKey(name: 'fcm_token') final String? fcmToken,
      @JsonKey(name: 'profile_image_url') final String? profilePicture,
      @JsonKey(name: 'business_license_url') final String? businessLicenseUrl,
      @JsonKey(name: 'identity_verification_url')
      final String? identityVerificationUrl,
      @JsonKey(name: 'portfolio_images') final List<String>? portfolioImages,
      final String? bio,
      @JsonKey(name: 'availability_schedule')
      final Map<String, dynamic>? availabilitySchedule,
      final double rating,
      @JsonKey(name: 'total_reviews') final int totalReviews,
      @JsonKey(name: 'total_jobs_completed') final int totalJobsCompleted,
      @JsonKey(name: 'verification_status') final String verificationStatus,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'is_online') final bool isOnline,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'auth_user_id') final String? authUserId,
      @JsonKey(name: 'is_onboarding_completed')
      final bool isOnboardingComplete}) = _$VendorImpl;
  const _Vendor._() : super._();

  factory _Vendor.fromJson(Map<String, dynamic> json) = _$VendorImpl.fromJson;

  @override
  String? get id;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  @JsonKey(name: 'business_name')
  String? get businessName;
  @override
  @JsonKey(name: 'business_type')
  String? get businessType;
  @override
  @JsonKey(name: 'vendor_type')
  String get vendorType;
  @override
  @JsonKey(name: 'experience_years')
  int? get experienceYears;
  @override
  @JsonKey(name: 'location')
  Map<String, dynamic>? get location;
  @override
  @JsonKey(name: 'service_area')
  String? get serviceArea;
  @override
  @JsonKey(name: 'additional_address')
  String? get additionalAddress;
  @override
  @JsonKey(name: 'fcm_token')
  String? get fcmToken;
  @override
  @JsonKey(name: 'profile_image_url')
  String? get profilePicture;
  @override
  @JsonKey(name: 'business_license_url')
  String? get businessLicenseUrl;
  @override
  @JsonKey(name: 'identity_verification_url')
  String? get identityVerificationUrl;
  @override
  @JsonKey(name: 'portfolio_images')
  List<String>? get portfolioImages;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'availability_schedule')
  Map<String, dynamic>? get availabilitySchedule;
  @override
  double get rating;
  @override
  @JsonKey(name: 'total_reviews')
  int get totalReviews;
  @override
  @JsonKey(name: 'total_jobs_completed')
  int get totalJobsCompleted;
  @override
  @JsonKey(name: 'verification_status')
  String get verificationStatus;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_online')
  bool get isOnline;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'auth_user_id')
  String? get authUserId;
  @override
  @JsonKey(name: 'is_onboarding_completed')
  bool get isOnboardingComplete;
  @override
  @JsonKey(ignore: true)
  _$$VendorImplCopyWith<_$VendorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
