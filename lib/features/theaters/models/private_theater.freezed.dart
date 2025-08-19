// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'private_theater.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrivateTheater _$PrivateTheaterFromJson(Map<String, dynamic> json) {
  return _PrivateTheater.fromJson(json);
}

/// @nodoc
mixin _$PrivateTheater {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'pin_code')
  String get pinCode => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'hourly_rate')
  double get hourlyRate => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reviews')
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String? get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_time_slots')
  List<Map<String, dynamic>> get availableTimeSlots =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_duration_hours')
  int get bookingDurationHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'advance_booking_days')
  int get advanceBookingDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancellation_policy')
  String get cancellationPolicy =>
      throw _privateConstructorUsedError; // Admin approval fields
  @JsonKey(name: 'approval_status')
  String get approvalStatus =>
      throw _privateConstructorUsedError; // 'pending', 'approved', 'rejected'
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejected_at')
  DateTime? get rejectedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_notes')
  String? get adminNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_name')
  String? get contactName => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_phone')
  String? get contactPhone =>
      throw _privateConstructorUsedError; // Theater theme fields
  @JsonKey(name: 'theme_name')
  String? get themeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'theme_primary_color')
  String? get themePrimaryColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'theme_secondary_color')
  String? get themeSecondaryColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'theme_background_image')
  String? get themeBackgroundImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'extra_charges_per_person')
  double get extraChargesPerPerson => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrivateTheaterCopyWith<PrivateTheater> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivateTheaterCopyWith<$Res> {
  factory $PrivateTheaterCopyWith(
          PrivateTheater value, $Res Function(PrivateTheater) then) =
      _$PrivateTheaterCopyWithImpl<$Res, PrivateTheater>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String address,
      String city,
      String state,
      @JsonKey(name: 'pin_code') String pinCode,
      double? latitude,
      double? longitude,
      int? capacity,
      List<String> amenities,
      List<String> images,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'hourly_rate') double hourlyRate,
      double rating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'owner_id') String? ownerId,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'available_time_slots')
      List<Map<String, dynamic>> availableTimeSlots,
      @JsonKey(name: 'booking_duration_hours') int bookingDurationHours,
      @JsonKey(name: 'advance_booking_days') int advanceBookingDays,
      @JsonKey(name: 'cancellation_policy') String cancellationPolicy,
      @JsonKey(name: 'approval_status') String approvalStatus,
      @JsonKey(name: 'approved_at') DateTime? approvedAt,
      @JsonKey(name: 'rejected_at') DateTime? rejectedAt,
      @JsonKey(name: 'admin_notes') String? adminNotes,
      @JsonKey(name: 'contact_name') String? contactName,
      @JsonKey(name: 'contact_phone') String? contactPhone,
      @JsonKey(name: 'theme_name') String? themeName,
      @JsonKey(name: 'theme_primary_color') String? themePrimaryColor,
      @JsonKey(name: 'theme_secondary_color') String? themeSecondaryColor,
      @JsonKey(name: 'theme_background_image') String? themeBackgroundImage,
      @JsonKey(name: 'extra_charges_per_person') double extraChargesPerPerson});
}

/// @nodoc
class _$PrivateTheaterCopyWithImpl<$Res, $Val extends PrivateTheater>
    implements $PrivateTheaterCopyWith<$Res> {
  _$PrivateTheaterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? pinCode = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? capacity = freezed,
    Object? amenities = null,
    Object? images = null,
    Object? videoUrl = freezed,
    Object? hourlyRate = null,
    Object? rating = null,
    Object? totalReviews = null,
    Object? isActive = null,
    Object? ownerId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? availableTimeSlots = null,
    Object? bookingDurationHours = null,
    Object? advanceBookingDays = null,
    Object? cancellationPolicy = null,
    Object? approvalStatus = null,
    Object? approvedAt = freezed,
    Object? rejectedAt = freezed,
    Object? adminNotes = freezed,
    Object? contactName = freezed,
    Object? contactPhone = freezed,
    Object? themeName = freezed,
    Object? themePrimaryColor = freezed,
    Object? themeSecondaryColor = freezed,
    Object? themeBackgroundImage = freezed,
    Object? extraChargesPerPerson = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      pinCode: null == pinCode
          ? _value.pinCode
          : pinCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableTimeSlots: null == availableTimeSlots
          ? _value.availableTimeSlots
          : availableTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      bookingDurationHours: null == bookingDurationHours
          ? _value.bookingDurationHours
          : bookingDurationHours // ignore: cast_nullable_to_non_nullable
              as int,
      advanceBookingDays: null == advanceBookingDays
          ? _value.advanceBookingDays
          : advanceBookingDays // ignore: cast_nullable_to_non_nullable
              as int,
      cancellationPolicy: null == cancellationPolicy
          ? _value.cancellationPolicy
          : cancellationPolicy // ignore: cast_nullable_to_non_nullable
              as String,
      approvalStatus: null == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as String,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: freezed == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      themeName: freezed == themeName
          ? _value.themeName
          : themeName // ignore: cast_nullable_to_non_nullable
              as String?,
      themePrimaryColor: freezed == themePrimaryColor
          ? _value.themePrimaryColor
          : themePrimaryColor // ignore: cast_nullable_to_non_nullable
              as String?,
      themeSecondaryColor: freezed == themeSecondaryColor
          ? _value.themeSecondaryColor
          : themeSecondaryColor // ignore: cast_nullable_to_non_nullable
              as String?,
      themeBackgroundImage: freezed == themeBackgroundImage
          ? _value.themeBackgroundImage
          : themeBackgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      extraChargesPerPerson: null == extraChargesPerPerson
          ? _value.extraChargesPerPerson
          : extraChargesPerPerson // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivateTheaterImplCopyWith<$Res>
    implements $PrivateTheaterCopyWith<$Res> {
  factory _$$PrivateTheaterImplCopyWith(_$PrivateTheaterImpl value,
          $Res Function(_$PrivateTheaterImpl) then) =
      __$$PrivateTheaterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String address,
      String city,
      String state,
      @JsonKey(name: 'pin_code') String pinCode,
      double? latitude,
      double? longitude,
      int? capacity,
      List<String> amenities,
      List<String> images,
      @JsonKey(name: 'video_url') String? videoUrl,
      @JsonKey(name: 'hourly_rate') double hourlyRate,
      double rating,
      @JsonKey(name: 'total_reviews') int totalReviews,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'owner_id') String? ownerId,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'available_time_slots')
      List<Map<String, dynamic>> availableTimeSlots,
      @JsonKey(name: 'booking_duration_hours') int bookingDurationHours,
      @JsonKey(name: 'advance_booking_days') int advanceBookingDays,
      @JsonKey(name: 'cancellation_policy') String cancellationPolicy,
      @JsonKey(name: 'approval_status') String approvalStatus,
      @JsonKey(name: 'approved_at') DateTime? approvedAt,
      @JsonKey(name: 'rejected_at') DateTime? rejectedAt,
      @JsonKey(name: 'admin_notes') String? adminNotes,
      @JsonKey(name: 'contact_name') String? contactName,
      @JsonKey(name: 'contact_phone') String? contactPhone,
      @JsonKey(name: 'theme_name') String? themeName,
      @JsonKey(name: 'theme_primary_color') String? themePrimaryColor,
      @JsonKey(name: 'theme_secondary_color') String? themeSecondaryColor,
      @JsonKey(name: 'theme_background_image') String? themeBackgroundImage,
      @JsonKey(name: 'extra_charges_per_person') double extraChargesPerPerson});
}

/// @nodoc
class __$$PrivateTheaterImplCopyWithImpl<$Res>
    extends _$PrivateTheaterCopyWithImpl<$Res, _$PrivateTheaterImpl>
    implements _$$PrivateTheaterImplCopyWith<$Res> {
  __$$PrivateTheaterImplCopyWithImpl(
      _$PrivateTheaterImpl _value, $Res Function(_$PrivateTheaterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? pinCode = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? capacity = freezed,
    Object? amenities = null,
    Object? images = null,
    Object? videoUrl = freezed,
    Object? hourlyRate = null,
    Object? rating = null,
    Object? totalReviews = null,
    Object? isActive = null,
    Object? ownerId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? availableTimeSlots = null,
    Object? bookingDurationHours = null,
    Object? advanceBookingDays = null,
    Object? cancellationPolicy = null,
    Object? approvalStatus = null,
    Object? approvedAt = freezed,
    Object? rejectedAt = freezed,
    Object? adminNotes = freezed,
    Object? contactName = freezed,
    Object? contactPhone = freezed,
    Object? themeName = freezed,
    Object? themePrimaryColor = freezed,
    Object? themeSecondaryColor = freezed,
    Object? themeBackgroundImage = freezed,
    Object? extraChargesPerPerson = null,
  }) {
    return _then(_$PrivateTheaterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      pinCode: null == pinCode
          ? _value.pinCode
          : pinCode // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      amenities: null == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hourlyRate: null == hourlyRate
          ? _value.hourlyRate
          : hourlyRate // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableTimeSlots: null == availableTimeSlots
          ? _value._availableTimeSlots
          : availableTimeSlots // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      bookingDurationHours: null == bookingDurationHours
          ? _value.bookingDurationHours
          : bookingDurationHours // ignore: cast_nullable_to_non_nullable
              as int,
      advanceBookingDays: null == advanceBookingDays
          ? _value.advanceBookingDays
          : advanceBookingDays // ignore: cast_nullable_to_non_nullable
              as int,
      cancellationPolicy: null == cancellationPolicy
          ? _value.cancellationPolicy
          : cancellationPolicy // ignore: cast_nullable_to_non_nullable
              as String,
      approvalStatus: null == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as String,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: freezed == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      themeName: freezed == themeName
          ? _value.themeName
          : themeName // ignore: cast_nullable_to_non_nullable
              as String?,
      themePrimaryColor: freezed == themePrimaryColor
          ? _value.themePrimaryColor
          : themePrimaryColor // ignore: cast_nullable_to_non_nullable
              as String?,
      themeSecondaryColor: freezed == themeSecondaryColor
          ? _value.themeSecondaryColor
          : themeSecondaryColor // ignore: cast_nullable_to_non_nullable
              as String?,
      themeBackgroundImage: freezed == themeBackgroundImage
          ? _value.themeBackgroundImage
          : themeBackgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      extraChargesPerPerson: null == extraChargesPerPerson
          ? _value.extraChargesPerPerson
          : extraChargesPerPerson // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivateTheaterImpl implements _PrivateTheater {
  const _$PrivateTheaterImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.address,
      required this.city,
      required this.state,
      @JsonKey(name: 'pin_code') required this.pinCode,
      this.latitude,
      this.longitude,
      this.capacity,
      final List<String> amenities = const [],
      final List<String> images = const [],
      @JsonKey(name: 'video_url') this.videoUrl,
      @JsonKey(name: 'hourly_rate') this.hourlyRate = 0.0,
      this.rating = 4.5,
      @JsonKey(name: 'total_reviews') this.totalReviews = 0,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'owner_id') this.ownerId,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'available_time_slots')
      final List<Map<String, dynamic>> availableTimeSlots = const [],
      @JsonKey(name: 'booking_duration_hours') this.bookingDurationHours = 2,
      @JsonKey(name: 'advance_booking_days') this.advanceBookingDays = 30,
      @JsonKey(name: 'cancellation_policy') this.cancellationPolicy =
          'Free cancellation up to 24 hours before the booking',
      @JsonKey(name: 'approval_status') this.approvalStatus = 'pending',
      @JsonKey(name: 'approved_at') this.approvedAt,
      @JsonKey(name: 'rejected_at') this.rejectedAt,
      @JsonKey(name: 'admin_notes') this.adminNotes,
      @JsonKey(name: 'contact_name') this.contactName,
      @JsonKey(name: 'contact_phone') this.contactPhone,
      @JsonKey(name: 'theme_name') this.themeName,
      @JsonKey(name: 'theme_primary_color') this.themePrimaryColor,
      @JsonKey(name: 'theme_secondary_color') this.themeSecondaryColor,
      @JsonKey(name: 'theme_background_image') this.themeBackgroundImage,
      @JsonKey(name: 'extra_charges_per_person')
      this.extraChargesPerPerson = 0.0})
      : _amenities = amenities,
        _images = images,
        _availableTimeSlots = availableTimeSlots;

  factory _$PrivateTheaterImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivateTheaterImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String address;
  @override
  final String city;
  @override
  final String state;
  @override
  @JsonKey(name: 'pin_code')
  final String pinCode;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final int? capacity;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @override
  @JsonKey(name: 'hourly_rate')
  final double hourlyRate;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'owner_id')
  final String? ownerId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<Map<String, dynamic>> _availableTimeSlots;
  @override
  @JsonKey(name: 'available_time_slots')
  List<Map<String, dynamic>> get availableTimeSlots {
    if (_availableTimeSlots is EqualUnmodifiableListView)
      return _availableTimeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTimeSlots);
  }

  @override
  @JsonKey(name: 'booking_duration_hours')
  final int bookingDurationHours;
  @override
  @JsonKey(name: 'advance_booking_days')
  final int advanceBookingDays;
  @override
  @JsonKey(name: 'cancellation_policy')
  final String cancellationPolicy;
// Admin approval fields
  @override
  @JsonKey(name: 'approval_status')
  final String approvalStatus;
// 'pending', 'approved', 'rejected'
  @override
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;
  @override
  @JsonKey(name: 'rejected_at')
  final DateTime? rejectedAt;
  @override
  @JsonKey(name: 'admin_notes')
  final String? adminNotes;
  @override
  @JsonKey(name: 'contact_name')
  final String? contactName;
  @override
  @JsonKey(name: 'contact_phone')
  final String? contactPhone;
// Theater theme fields
  @override
  @JsonKey(name: 'theme_name')
  final String? themeName;
  @override
  @JsonKey(name: 'theme_primary_color')
  final String? themePrimaryColor;
  @override
  @JsonKey(name: 'theme_secondary_color')
  final String? themeSecondaryColor;
  @override
  @JsonKey(name: 'theme_background_image')
  final String? themeBackgroundImage;
  @override
  @JsonKey(name: 'extra_charges_per_person')
  final double extraChargesPerPerson;

  @override
  String toString() {
    return 'PrivateTheater(id: $id, name: $name, description: $description, address: $address, city: $city, state: $state, pinCode: $pinCode, latitude: $latitude, longitude: $longitude, capacity: $capacity, amenities: $amenities, images: $images, videoUrl: $videoUrl, hourlyRate: $hourlyRate, rating: $rating, totalReviews: $totalReviews, isActive: $isActive, ownerId: $ownerId, createdAt: $createdAt, updatedAt: $updatedAt, availableTimeSlots: $availableTimeSlots, bookingDurationHours: $bookingDurationHours, advanceBookingDays: $advanceBookingDays, cancellationPolicy: $cancellationPolicy, approvalStatus: $approvalStatus, approvedAt: $approvedAt, rejectedAt: $rejectedAt, adminNotes: $adminNotes, contactName: $contactName, contactPhone: $contactPhone, themeName: $themeName, themePrimaryColor: $themePrimaryColor, themeSecondaryColor: $themeSecondaryColor, themeBackgroundImage: $themeBackgroundImage, extraChargesPerPerson: $extraChargesPerPerson)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivateTheaterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.pinCode, pinCode) || other.pinCode == pinCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._availableTimeSlots, _availableTimeSlots) &&
            (identical(other.bookingDurationHours, bookingDurationHours) ||
                other.bookingDurationHours == bookingDurationHours) &&
            (identical(other.advanceBookingDays, advanceBookingDays) ||
                other.advanceBookingDays == advanceBookingDays) &&
            (identical(other.cancellationPolicy, cancellationPolicy) ||
                other.cancellationPolicy == cancellationPolicy) &&
            (identical(other.approvalStatus, approvalStatus) ||
                other.approvalStatus == approvalStatus) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.rejectedAt, rejectedAt) ||
                other.rejectedAt == rejectedAt) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.themeName, themeName) ||
                other.themeName == themeName) &&
            (identical(other.themePrimaryColor, themePrimaryColor) ||
                other.themePrimaryColor == themePrimaryColor) &&
            (identical(other.themeSecondaryColor, themeSecondaryColor) ||
                other.themeSecondaryColor == themeSecondaryColor) &&
            (identical(other.themeBackgroundImage, themeBackgroundImage) ||
                other.themeBackgroundImage == themeBackgroundImage) &&
            (identical(other.extraChargesPerPerson, extraChargesPerPerson) ||
                other.extraChargesPerPerson == extraChargesPerPerson));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        address,
        city,
        state,
        pinCode,
        latitude,
        longitude,
        capacity,
        const DeepCollectionEquality().hash(_amenities),
        const DeepCollectionEquality().hash(_images),
        videoUrl,
        hourlyRate,
        rating,
        totalReviews,
        isActive,
        ownerId,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_availableTimeSlots),
        bookingDurationHours,
        advanceBookingDays,
        cancellationPolicy,
        approvalStatus,
        approvedAt,
        rejectedAt,
        adminNotes,
        contactName,
        contactPhone,
        themeName,
        themePrimaryColor,
        themeSecondaryColor,
        themeBackgroundImage,
        extraChargesPerPerson
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivateTheaterImplCopyWith<_$PrivateTheaterImpl> get copyWith =>
      __$$PrivateTheaterImplCopyWithImpl<_$PrivateTheaterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivateTheaterImplToJson(
      this,
    );
  }
}

abstract class _PrivateTheater implements PrivateTheater {
  const factory _PrivateTheater(
      {required final String id,
      required final String name,
      final String? description,
      required final String address,
      required final String city,
      required final String state,
      @JsonKey(name: 'pin_code') required final String pinCode,
      final double? latitude,
      final double? longitude,
      final int? capacity,
      final List<String> amenities,
      final List<String> images,
      @JsonKey(name: 'video_url') final String? videoUrl,
      @JsonKey(name: 'hourly_rate') final double hourlyRate,
      final double rating,
      @JsonKey(name: 'total_reviews') final int totalReviews,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'owner_id') final String? ownerId,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'available_time_slots')
      final List<Map<String, dynamic>> availableTimeSlots,
      @JsonKey(name: 'booking_duration_hours') final int bookingDurationHours,
      @JsonKey(name: 'advance_booking_days') final int advanceBookingDays,
      @JsonKey(name: 'cancellation_policy') final String cancellationPolicy,
      @JsonKey(name: 'approval_status') final String approvalStatus,
      @JsonKey(name: 'approved_at') final DateTime? approvedAt,
      @JsonKey(name: 'rejected_at') final DateTime? rejectedAt,
      @JsonKey(name: 'admin_notes') final String? adminNotes,
      @JsonKey(name: 'contact_name') final String? contactName,
      @JsonKey(name: 'contact_phone') final String? contactPhone,
      @JsonKey(name: 'theme_name') final String? themeName,
      @JsonKey(name: 'theme_primary_color') final String? themePrimaryColor,
      @JsonKey(name: 'theme_secondary_color') final String? themeSecondaryColor,
      @JsonKey(name: 'theme_background_image')
      final String? themeBackgroundImage,
      @JsonKey(name: 'extra_charges_per_person')
      final double extraChargesPerPerson}) = _$PrivateTheaterImpl;

  factory _PrivateTheater.fromJson(Map<String, dynamic> json) =
      _$PrivateTheaterImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String get address;
  @override
  String get city;
  @override
  String get state;
  @override
  @JsonKey(name: 'pin_code')
  String get pinCode;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  int? get capacity;
  @override
  List<String> get amenities;
  @override
  List<String> get images;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  @JsonKey(name: 'hourly_rate')
  double get hourlyRate;
  @override
  double get rating;
  @override
  @JsonKey(name: 'total_reviews')
  int get totalReviews;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'owner_id')
  String? get ownerId;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'available_time_slots')
  List<Map<String, dynamic>> get availableTimeSlots;
  @override
  @JsonKey(name: 'booking_duration_hours')
  int get bookingDurationHours;
  @override
  @JsonKey(name: 'advance_booking_days')
  int get advanceBookingDays;
  @override
  @JsonKey(name: 'cancellation_policy')
  String get cancellationPolicy;
  @override // Admin approval fields
  @JsonKey(name: 'approval_status')
  String get approvalStatus;
  @override // 'pending', 'approved', 'rejected'
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt;
  @override
  @JsonKey(name: 'rejected_at')
  DateTime? get rejectedAt;
  @override
  @JsonKey(name: 'admin_notes')
  String? get adminNotes;
  @override
  @JsonKey(name: 'contact_name')
  String? get contactName;
  @override
  @JsonKey(name: 'contact_phone')
  String? get contactPhone;
  @override // Theater theme fields
  @JsonKey(name: 'theme_name')
  String? get themeName;
  @override
  @JsonKey(name: 'theme_primary_color')
  String? get themePrimaryColor;
  @override
  @JsonKey(name: 'theme_secondary_color')
  String? get themeSecondaryColor;
  @override
  @JsonKey(name: 'theme_background_image')
  String? get themeBackgroundImage;
  @override
  @JsonKey(name: 'extra_charges_per_person')
  double get extraChargesPerPerson;
  @override
  @JsonKey(ignore: true)
  _$$PrivateTheaterImplCopyWith<_$PrivateTheaterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
