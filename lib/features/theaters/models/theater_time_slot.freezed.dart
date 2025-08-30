// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_time_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TheaterTimeSlot _$TheaterTimeSlotFromJson(Map<String, dynamic> json) {
  return _TheaterTimeSlot.fromJson(json);
}

/// @nodoc
mixin _$TheaterTimeSlot {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_id')
  String? get screenId => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_multiplier')
  double get priceMultiplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'base_price')
  double get basePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_per_hour')
  double get pricePerHour => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekday_multiplier')
  double get weekdayMultiplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekend_multiplier')
  double get weekendMultiplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'holiday_multiplier')
  double get holidayMultiplier => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_duration_hours')
  int? get maxDurationHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_duration_hours')
  int? get minDurationHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterTimeSlotCopyWith<TheaterTimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterTimeSlotCopyWith<$Res> {
  factory $TheaterTimeSlotCopyWith(
          TheaterTimeSlot value, $Res Function(TheaterTimeSlot) then) =
      _$TheaterTimeSlotCopyWithImpl<$Res, TheaterTimeSlot>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_id') String? screenId,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'price_multiplier') double priceMultiplier,
      @JsonKey(name: 'base_price') double basePrice,
      @JsonKey(name: 'price_per_hour') double pricePerHour,
      @JsonKey(name: 'weekday_multiplier') double weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier') double weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier') double holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') int? maxDurationHours,
      @JsonKey(name: 'min_duration_hours') int? minDurationHours,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$TheaterTimeSlotCopyWithImpl<$Res, $Val extends TheaterTimeSlot>
    implements $TheaterTimeSlotCopyWith<$Res> {
  _$TheaterTimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenId = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAvailable = null,
    Object? priceMultiplier = null,
    Object? basePrice = null,
    Object? pricePerHour = null,
    Object? weekdayMultiplier = null,
    Object? weekendMultiplier = null,
    Object? holidayMultiplier = null,
    Object? maxDurationHours = freezed,
    Object? minDurationHours = freezed,
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
      screenId: freezed == screenId
          ? _value.screenId
          : screenId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      priceMultiplier: null == priceMultiplier
          ? _value.priceMultiplier
          : priceMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as double,
      weekdayMultiplier: null == weekdayMultiplier
          ? _value.weekdayMultiplier
          : weekdayMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      weekendMultiplier: null == weekendMultiplier
          ? _value.weekendMultiplier
          : weekendMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      holidayMultiplier: null == holidayMultiplier
          ? _value.holidayMultiplier
          : holidayMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      maxDurationHours: freezed == maxDurationHours
          ? _value.maxDurationHours
          : maxDurationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      minDurationHours: freezed == minDurationHours
          ? _value.minDurationHours
          : minDurationHours // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$TheaterTimeSlotImplCopyWith<$Res>
    implements $TheaterTimeSlotCopyWith<$Res> {
  factory _$$TheaterTimeSlotImplCopyWith(_$TheaterTimeSlotImpl value,
          $Res Function(_$TheaterTimeSlotImpl) then) =
      __$$TheaterTimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'screen_id') String? screenId,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'price_multiplier') double priceMultiplier,
      @JsonKey(name: 'base_price') double basePrice,
      @JsonKey(name: 'price_per_hour') double pricePerHour,
      @JsonKey(name: 'weekday_multiplier') double weekdayMultiplier,
      @JsonKey(name: 'weekend_multiplier') double weekendMultiplier,
      @JsonKey(name: 'holiday_multiplier') double holidayMultiplier,
      @JsonKey(name: 'max_duration_hours') int? maxDurationHours,
      @JsonKey(name: 'min_duration_hours') int? minDurationHours,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$TheaterTimeSlotImplCopyWithImpl<$Res>
    extends _$TheaterTimeSlotCopyWithImpl<$Res, _$TheaterTimeSlotImpl>
    implements _$$TheaterTimeSlotImplCopyWith<$Res> {
  __$$TheaterTimeSlotImplCopyWithImpl(
      _$TheaterTimeSlotImpl _value, $Res Function(_$TheaterTimeSlotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? screenId = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAvailable = null,
    Object? priceMultiplier = null,
    Object? basePrice = null,
    Object? pricePerHour = null,
    Object? weekdayMultiplier = null,
    Object? weekendMultiplier = null,
    Object? holidayMultiplier = null,
    Object? maxDurationHours = freezed,
    Object? minDurationHours = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TheaterTimeSlotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      screenId: freezed == screenId
          ? _value.screenId
          : screenId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      priceMultiplier: null == priceMultiplier
          ? _value.priceMultiplier
          : priceMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      basePrice: null == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as double,
      weekdayMultiplier: null == weekdayMultiplier
          ? _value.weekdayMultiplier
          : weekdayMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      weekendMultiplier: null == weekendMultiplier
          ? _value.weekendMultiplier
          : weekendMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      holidayMultiplier: null == holidayMultiplier
          ? _value.holidayMultiplier
          : holidayMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      maxDurationHours: freezed == maxDurationHours
          ? _value.maxDurationHours
          : maxDurationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      minDurationHours: freezed == minDurationHours
          ? _value.minDurationHours
          : minDurationHours // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$TheaterTimeSlotImpl implements _TheaterTimeSlot {
  const _$TheaterTimeSlotImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'screen_id') this.screenId,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'is_available') this.isAvailable = true,
      @JsonKey(name: 'price_multiplier') this.priceMultiplier = 1.0,
      @JsonKey(name: 'base_price') this.basePrice = 0.0,
      @JsonKey(name: 'price_per_hour') this.pricePerHour = 0.0,
      @JsonKey(name: 'weekday_multiplier') this.weekdayMultiplier = 1.0,
      @JsonKey(name: 'weekend_multiplier') this.weekendMultiplier = 1.5,
      @JsonKey(name: 'holiday_multiplier') this.holidayMultiplier = 2.0,
      @JsonKey(name: 'max_duration_hours') this.maxDurationHours,
      @JsonKey(name: 'min_duration_hours') this.minDurationHours,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$TheaterTimeSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterTimeSlotImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'screen_id')
  final String? screenId;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'price_multiplier')
  final double priceMultiplier;
  @override
  @JsonKey(name: 'base_price')
  final double basePrice;
  @override
  @JsonKey(name: 'price_per_hour')
  final double pricePerHour;
  @override
  @JsonKey(name: 'weekday_multiplier')
  final double weekdayMultiplier;
  @override
  @JsonKey(name: 'weekend_multiplier')
  final double weekendMultiplier;
  @override
  @JsonKey(name: 'holiday_multiplier')
  final double holidayMultiplier;
  @override
  @JsonKey(name: 'max_duration_hours')
  final int? maxDurationHours;
  @override
  @JsonKey(name: 'min_duration_hours')
  final int? minDurationHours;
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
    return 'TheaterTimeSlot(id: $id, theaterId: $theaterId, screenId: $screenId, startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable, priceMultiplier: $priceMultiplier, basePrice: $basePrice, pricePerHour: $pricePerHour, weekdayMultiplier: $weekdayMultiplier, weekendMultiplier: $weekendMultiplier, holidayMultiplier: $holidayMultiplier, maxDurationHours: $maxDurationHours, minDurationHours: $minDurationHours, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterTimeSlotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.screenId, screenId) ||
                other.screenId == screenId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.priceMultiplier, priceMultiplier) ||
                other.priceMultiplier == priceMultiplier) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            (identical(other.weekdayMultiplier, weekdayMultiplier) ||
                other.weekdayMultiplier == weekdayMultiplier) &&
            (identical(other.weekendMultiplier, weekendMultiplier) ||
                other.weekendMultiplier == weekendMultiplier) &&
            (identical(other.holidayMultiplier, holidayMultiplier) ||
                other.holidayMultiplier == holidayMultiplier) &&
            (identical(other.maxDurationHours, maxDurationHours) ||
                other.maxDurationHours == maxDurationHours) &&
            (identical(other.minDurationHours, minDurationHours) ||
                other.minDurationHours == minDurationHours) &&
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
      screenId,
      startTime,
      endTime,
      isAvailable,
      priceMultiplier,
      basePrice,
      pricePerHour,
      weekdayMultiplier,
      weekendMultiplier,
      holidayMultiplier,
      maxDurationHours,
      minDurationHours,
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterTimeSlotImplCopyWith<_$TheaterTimeSlotImpl> get copyWith =>
      __$$TheaterTimeSlotImplCopyWithImpl<_$TheaterTimeSlotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterTimeSlotImplToJson(
      this,
    );
  }
}

abstract class _TheaterTimeSlot implements TheaterTimeSlot {
  const factory _TheaterTimeSlot(
          {required final String id,
          @JsonKey(name: 'theater_id') required final String theaterId,
          @JsonKey(name: 'screen_id') final String? screenId,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          @JsonKey(name: 'is_available') final bool isAvailable,
          @JsonKey(name: 'price_multiplier') final double priceMultiplier,
          @JsonKey(name: 'base_price') final double basePrice,
          @JsonKey(name: 'price_per_hour') final double pricePerHour,
          @JsonKey(name: 'weekday_multiplier') final double weekdayMultiplier,
          @JsonKey(name: 'weekend_multiplier') final double weekendMultiplier,
          @JsonKey(name: 'holiday_multiplier') final double holidayMultiplier,
          @JsonKey(name: 'max_duration_hours') final int? maxDurationHours,
          @JsonKey(name: 'min_duration_hours') final int? minDurationHours,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$TheaterTimeSlotImpl;

  factory _TheaterTimeSlot.fromJson(Map<String, dynamic> json) =
      _$TheaterTimeSlotImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'screen_id')
  String? get screenId;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'price_multiplier')
  double get priceMultiplier;
  @override
  @JsonKey(name: 'base_price')
  double get basePrice;
  @override
  @JsonKey(name: 'price_per_hour')
  double get pricePerHour;
  @override
  @JsonKey(name: 'weekday_multiplier')
  double get weekdayMultiplier;
  @override
  @JsonKey(name: 'weekend_multiplier')
  double get weekendMultiplier;
  @override
  @JsonKey(name: 'holiday_multiplier')
  double get holidayMultiplier;
  @override
  @JsonKey(name: 'max_duration_hours')
  int? get maxDurationHours;
  @override
  @JsonKey(name: 'min_duration_hours')
  int? get minDurationHours;
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
  _$$TheaterTimeSlotImplCopyWith<_$TheaterTimeSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
