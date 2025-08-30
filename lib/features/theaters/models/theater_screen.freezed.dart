// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_screen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TheaterScreen _$TheaterScreenFromJson(Map<String, dynamic> json) {
  return _TheaterScreen.fromJson(json);
}

/// @nodoc
mixin _$TheaterScreen {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_name')
  String get screenName => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_number')
  int get screenNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_capacity')
  int get totalCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'allowed_capacity')
  int get allowedCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'charges_extra_per_person')
  double get chargesExtraPerPerson => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_hourly_price')
  double get originalHourlyPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'discounted_hourly_price')
  double get discountedHourlyPrice => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterScreenCopyWith<TheaterScreen> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterScreenCopyWith<$Res> {
  factory $TheaterScreenCopyWith(
          TheaterScreen value, $Res Function(TheaterScreen) then) =
      _$TheaterScreenCopyWithImpl<$Res, TheaterScreen>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_name') String screenName,
      @JsonKey(name: 'screen_number') int screenNumber,
      @JsonKey(name: 'total_capacity') int totalCapacity,
      @JsonKey(name: 'allowed_capacity') int allowedCapacity,
      @JsonKey(name: 'charges_extra_per_person') double chargesExtraPerPerson,
      @JsonKey(name: 'video_url') String? videoUrl,
      List<String> images,
      @JsonKey(name: 'original_hourly_price') double originalHourlyPrice,
      @JsonKey(name: 'discounted_hourly_price') double discountedHourlyPrice,
      List<String> amenities,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$TheaterScreenCopyWithImpl<$Res, $Val extends TheaterScreen>
    implements $TheaterScreenCopyWith<$Res> {
  _$TheaterScreenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenName = null,
    Object? screenNumber = null,
    Object? totalCapacity = null,
    Object? allowedCapacity = null,
    Object? chargesExtraPerPerson = null,
    Object? videoUrl = freezed,
    Object? images = null,
    Object? originalHourlyPrice = null,
    Object? discountedHourlyPrice = null,
    Object? amenities = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      screenName: null == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String,
      screenNumber: null == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int,
      totalCapacity: null == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      allowedCapacity: null == allowedCapacity
          ? _value.allowedCapacity
          : allowedCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      chargesExtraPerPerson: null == chargesExtraPerPerson
          ? _value.chargesExtraPerPerson
          : chargesExtraPerPerson // ignore: cast_nullable_to_non_nullable
              as double,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      originalHourlyPrice: null == originalHourlyPrice
          ? _value.originalHourlyPrice
          : originalHourlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountedHourlyPrice: null == discountedHourlyPrice
          ? _value.discountedHourlyPrice
          : discountedHourlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
abstract class _$$TheaterScreenImplCopyWith<$Res>
    implements $TheaterScreenCopyWith<$Res> {
  factory _$$TheaterScreenImplCopyWith(
          _$TheaterScreenImpl value, $Res Function(_$TheaterScreenImpl) then) =
      __$$TheaterScreenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_name') String screenName,
      @JsonKey(name: 'screen_number') int screenNumber,
      @JsonKey(name: 'total_capacity') int totalCapacity,
      @JsonKey(name: 'allowed_capacity') int allowedCapacity,
      @JsonKey(name: 'charges_extra_per_person') double chargesExtraPerPerson,
      @JsonKey(name: 'video_url') String? videoUrl,
      List<String> images,
      @JsonKey(name: 'original_hourly_price') double originalHourlyPrice,
      @JsonKey(name: 'discounted_hourly_price') double discountedHourlyPrice,
      List<String> amenities,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$TheaterScreenImplCopyWithImpl<$Res>
    extends _$TheaterScreenCopyWithImpl<$Res, _$TheaterScreenImpl>
    implements _$$TheaterScreenImplCopyWith<$Res> {
  __$$TheaterScreenImplCopyWithImpl(
      _$TheaterScreenImpl _value, $Res Function(_$TheaterScreenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenName = null,
    Object? screenNumber = null,
    Object? totalCapacity = null,
    Object? allowedCapacity = null,
    Object? chargesExtraPerPerson = null,
    Object? videoUrl = freezed,
    Object? images = null,
    Object? originalHourlyPrice = null,
    Object? discountedHourlyPrice = null,
    Object? amenities = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TheaterScreenImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      screenName: null == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String,
      screenNumber: null == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int,
      totalCapacity: null == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      allowedCapacity: null == allowedCapacity
          ? _value.allowedCapacity
          : allowedCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      chargesExtraPerPerson: null == chargesExtraPerPerson
          ? _value.chargesExtraPerPerson
          : chargesExtraPerPerson // ignore: cast_nullable_to_non_nullable
              as double,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      originalHourlyPrice: null == originalHourlyPrice
          ? _value.originalHourlyPrice
          : originalHourlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountedHourlyPrice: null == discountedHourlyPrice
          ? _value.discountedHourlyPrice
          : discountedHourlyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      amenities: null == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
class _$TheaterScreenImpl implements _TheaterScreen {
  const _$TheaterScreenImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'screen_name') required this.screenName,
      @JsonKey(name: 'screen_number') required this.screenNumber,
      @JsonKey(name: 'total_capacity') this.totalCapacity = 0,
      @JsonKey(name: 'allowed_capacity') this.allowedCapacity = 0,
      @JsonKey(name: 'charges_extra_per_person')
      this.chargesExtraPerPerson = 0.0,
      @JsonKey(name: 'video_url') this.videoUrl,
      final List<String> images = const [],
      @JsonKey(name: 'original_hourly_price') this.originalHourlyPrice = 0.0,
      @JsonKey(name: 'discounted_hourly_price')
      this.discountedHourlyPrice = 0.0,
      final List<String> amenities = const [],
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _images = images,
        _amenities = amenities;

  factory _$TheaterScreenImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterScreenImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'screen_name')
  final String screenName;
  @override
  @JsonKey(name: 'screen_number')
  final int screenNumber;
  @override
  @JsonKey(name: 'total_capacity')
  final int totalCapacity;
  @override
  @JsonKey(name: 'allowed_capacity')
  final int allowedCapacity;
  @override
  @JsonKey(name: 'charges_extra_per_person')
  final double chargesExtraPerPerson;
  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'original_hourly_price')
  final double originalHourlyPrice;
  @override
  @JsonKey(name: 'discounted_hourly_price')
  final double discountedHourlyPrice;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TheaterScreen(id: $id, theaterId: $theaterId, screenName: $screenName, screenNumber: $screenNumber, totalCapacity: $totalCapacity, allowedCapacity: $allowedCapacity, chargesExtraPerPerson: $chargesExtraPerPerson, videoUrl: $videoUrl, images: $images, originalHourlyPrice: $originalHourlyPrice, discountedHourlyPrice: $discountedHourlyPrice, amenities: $amenities, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterScreenImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.screenName, screenName) ||
                other.screenName == screenName) &&
            (identical(other.screenNumber, screenNumber) ||
                other.screenNumber == screenNumber) &&
            (identical(other.totalCapacity, totalCapacity) ||
                other.totalCapacity == totalCapacity) &&
            (identical(other.allowedCapacity, allowedCapacity) ||
                other.allowedCapacity == allowedCapacity) &&
            (identical(other.chargesExtraPerPerson, chargesExtraPerPerson) ||
                other.chargesExtraPerPerson == chargesExtraPerPerson) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.originalHourlyPrice, originalHourlyPrice) ||
                other.originalHourlyPrice == originalHourlyPrice) &&
            (identical(other.discountedHourlyPrice, discountedHourlyPrice) ||
                other.discountedHourlyPrice == discountedHourlyPrice) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      theaterId,
      screenName,
      screenNumber,
      totalCapacity,
      allowedCapacity,
      chargesExtraPerPerson,
      videoUrl,
      const DeepCollectionEquality().hash(_images),
      originalHourlyPrice,
      discountedHourlyPrice,
      const DeepCollectionEquality().hash(_amenities),
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterScreenImplCopyWith<_$TheaterScreenImpl> get copyWith =>
      __$$TheaterScreenImplCopyWithImpl<_$TheaterScreenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterScreenImplToJson(
      this,
    );
  }
}

abstract class _TheaterScreen implements TheaterScreen {
  const factory _TheaterScreen(
      {required final String id,
      @JsonKey(name: 'theater_id') required final String theaterId,
      @JsonKey(name: 'screen_name') required final String screenName,
      @JsonKey(name: 'screen_number') required final int screenNumber,
      @JsonKey(name: 'total_capacity') final int totalCapacity,
      @JsonKey(name: 'allowed_capacity') final int allowedCapacity,
      @JsonKey(name: 'charges_extra_per_person')
      final double chargesExtraPerPerson,
      @JsonKey(name: 'video_url') final String? videoUrl,
      final List<String> images,
      @JsonKey(name: 'original_hourly_price') final double originalHourlyPrice,
      @JsonKey(name: 'discounted_hourly_price')
      final double discountedHourlyPrice,
      final List<String> amenities,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$TheaterScreenImpl;

  factory _TheaterScreen.fromJson(Map<String, dynamic> json) =
      _$TheaterScreenImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'screen_name')
  String get screenName;
  @override
  @JsonKey(name: 'screen_number')
  int get screenNumber;
  @override
  @JsonKey(name: 'total_capacity')
  int get totalCapacity;
  @override
  @JsonKey(name: 'allowed_capacity')
  int get allowedCapacity;
  @override
  @JsonKey(name: 'charges_extra_per_person')
  double get chargesExtraPerPerson;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  List<String> get images;
  @override
  @JsonKey(name: 'original_hourly_price')
  double get originalHourlyPrice;
  @override
  @JsonKey(name: 'discounted_hourly_price')
  double get discountedHourlyPrice;
  @override
  List<String> get amenities;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TheaterScreenImplCopyWith<_$TheaterScreenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
