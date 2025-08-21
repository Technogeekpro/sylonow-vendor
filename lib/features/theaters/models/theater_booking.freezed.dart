// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TheaterBooking _$TheaterBookingFromJson(Map<String, dynamic> json) {
  return _TheaterBooking.fromJson(json);
}

/// @nodoc
mixin _$TheaterBooking {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String get theaterId => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_slot_id')
  String? get timeSlotId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_id')
  String? get paymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_status')
  String get bookingStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_count')
  int get guestCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_requests')
  String? get specialRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_name')
  String get contactName => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_phone')
  String get contactPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_email')
  String? get contactEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'celebration_name')
  String? get celebrationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'number_of_people')
  int get numberOfPeople => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Related data (joined from other tables)
  @JsonKey(name: 'theater_name')
  String? get theaterName => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_name')
  String? get screenName => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_number')
  int? get screenNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterBookingCopyWith<TheaterBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterBookingCopyWith<$Res> {
  factory $TheaterBookingCopyWith(
          TheaterBooking value, $Res Function(TheaterBooking) then) =
      _$TheaterBookingCopyWithImpl<$Res, TheaterBooking>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'time_slot_id') String? timeSlotId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'payment_id') String? paymentId,
      @JsonKey(name: 'booking_status') String bookingStatus,
      @JsonKey(name: 'guest_count') int guestCount,
      @JsonKey(name: 'special_requests') String? specialRequests,
      @JsonKey(name: 'contact_name') String contactName,
      @JsonKey(name: 'contact_phone') String contactPhone,
      @JsonKey(name: 'contact_email') String? contactEmail,
      @JsonKey(name: 'celebration_name') String? celebrationName,
      @JsonKey(name: 'number_of_people') int numberOfPeople,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'theater_name') String? theaterName,
      @JsonKey(name: 'screen_name') String? screenName,
      @JsonKey(name: 'screen_number') int? screenNumber});
}

/// @nodoc
class _$TheaterBookingCopyWithImpl<$Res, $Val extends TheaterBooking>
    implements $TheaterBookingCopyWith<$Res> {
  _$TheaterBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? timeSlotId = freezed,
    Object? userId = null,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? totalAmount = null,
    Object? paymentStatus = null,
    Object? paymentId = freezed,
    Object? bookingStatus = null,
    Object? guestCount = null,
    Object? specialRequests = freezed,
    Object? contactName = null,
    Object? contactPhone = null,
    Object? contactEmail = freezed,
    Object? celebrationName = freezed,
    Object? numberOfPeople = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? theaterName = freezed,
    Object? screenName = freezed,
    Object? screenNumber = freezed,
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
      timeSlotId: freezed == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingStatus: null == bookingStatus
          ? _value.bookingStatus
          : bookingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      guestCount: null == guestCount
          ? _value.guestCount
          : guestCount // ignore: cast_nullable_to_non_nullable
              as int,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      celebrationName: freezed == celebrationName
          ? _value.celebrationName
          : celebrationName // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfPeople: null == numberOfPeople
          ? _value.numberOfPeople
          : numberOfPeople // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      theaterName: freezed == theaterName
          ? _value.theaterName
          : theaterName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenName: freezed == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenNumber: freezed == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TheaterBookingImplCopyWith<$Res>
    implements $TheaterBookingCopyWith<$Res> {
  factory _$$TheaterBookingImplCopyWith(_$TheaterBookingImpl value,
          $Res Function(_$TheaterBookingImpl) then) =
      __$$TheaterBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'theater_id') String theaterId,
      @JsonKey(name: 'time_slot_id') String? timeSlotId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'payment_id') String? paymentId,
      @JsonKey(name: 'booking_status') String bookingStatus,
      @JsonKey(name: 'guest_count') int guestCount,
      @JsonKey(name: 'special_requests') String? specialRequests,
      @JsonKey(name: 'contact_name') String contactName,
      @JsonKey(name: 'contact_phone') String contactPhone,
      @JsonKey(name: 'contact_email') String? contactEmail,
      @JsonKey(name: 'celebration_name') String? celebrationName,
      @JsonKey(name: 'number_of_people') int numberOfPeople,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'theater_name') String? theaterName,
      @JsonKey(name: 'screen_name') String? screenName,
      @JsonKey(name: 'screen_number') int? screenNumber});
}

/// @nodoc
class __$$TheaterBookingImplCopyWithImpl<$Res>
    extends _$TheaterBookingCopyWithImpl<$Res, _$TheaterBookingImpl>
    implements _$$TheaterBookingImplCopyWith<$Res> {
  __$$TheaterBookingImplCopyWithImpl(
      _$TheaterBookingImpl _value, $Res Function(_$TheaterBookingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theaterId = null,
    Object? timeSlotId = freezed,
    Object? userId = null,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? totalAmount = null,
    Object? paymentStatus = null,
    Object? paymentId = freezed,
    Object? bookingStatus = null,
    Object? guestCount = null,
    Object? specialRequests = freezed,
    Object? contactName = null,
    Object? contactPhone = null,
    Object? contactEmail = freezed,
    Object? celebrationName = freezed,
    Object? numberOfPeople = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? theaterName = freezed,
    Object? screenName = freezed,
    Object? screenNumber = freezed,
  }) {
    return _then(_$TheaterBookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: null == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSlotId: freezed == timeSlotId
          ? _value.timeSlotId
          : timeSlotId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingStatus: null == bookingStatus
          ? _value.bookingStatus
          : bookingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      guestCount: null == guestCount
          ? _value.guestCount
          : guestCount // ignore: cast_nullable_to_non_nullable
              as int,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      contactName: null == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String,
      contactPhone: null == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      celebrationName: freezed == celebrationName
          ? _value.celebrationName
          : celebrationName // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfPeople: null == numberOfPeople
          ? _value.numberOfPeople
          : numberOfPeople // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      theaterName: freezed == theaterName
          ? _value.theaterName
          : theaterName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenName: freezed == screenName
          ? _value.screenName
          : screenName // ignore: cast_nullable_to_non_nullable
              as String?,
      screenNumber: freezed == screenNumber
          ? _value.screenNumber
          : screenNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TheaterBookingImpl implements _TheaterBooking {
  const _$TheaterBookingImpl(
      {required this.id,
      @JsonKey(name: 'theater_id') required this.theaterId,
      @JsonKey(name: 'time_slot_id') this.timeSlotId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'payment_status') this.paymentStatus = 'pending',
      @JsonKey(name: 'payment_id') this.paymentId,
      @JsonKey(name: 'booking_status') this.bookingStatus = 'confirmed',
      @JsonKey(name: 'guest_count') this.guestCount = 1,
      @JsonKey(name: 'special_requests') this.specialRequests,
      @JsonKey(name: 'contact_name') required this.contactName,
      @JsonKey(name: 'contact_phone') required this.contactPhone,
      @JsonKey(name: 'contact_email') this.contactEmail,
      @JsonKey(name: 'celebration_name') this.celebrationName,
      @JsonKey(name: 'number_of_people') this.numberOfPeople = 2,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'theater_name') this.theaterName,
      @JsonKey(name: 'screen_name') this.screenName,
      @JsonKey(name: 'screen_number') this.screenNumber});

  factory _$TheaterBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterBookingImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'theater_id')
  final String theaterId;
  @override
  @JsonKey(name: 'time_slot_id')
  final String? timeSlotId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'booking_date')
  final DateTime bookingDate;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  @JsonKey(name: 'payment_id')
  final String? paymentId;
  @override
  @JsonKey(name: 'booking_status')
  final String bookingStatus;
  @override
  @JsonKey(name: 'guest_count')
  final int guestCount;
  @override
  @JsonKey(name: 'special_requests')
  final String? specialRequests;
  @override
  @JsonKey(name: 'contact_name')
  final String contactName;
  @override
  @JsonKey(name: 'contact_phone')
  final String contactPhone;
  @override
  @JsonKey(name: 'contact_email')
  final String? contactEmail;
  @override
  @JsonKey(name: 'celebration_name')
  final String? celebrationName;
  @override
  @JsonKey(name: 'number_of_people')
  final int numberOfPeople;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// Related data (joined from other tables)
  @override
  @JsonKey(name: 'theater_name')
  final String? theaterName;
  @override
  @JsonKey(name: 'screen_name')
  final String? screenName;
  @override
  @JsonKey(name: 'screen_number')
  final int? screenNumber;

  @override
  String toString() {
    return 'TheaterBooking(id: $id, theaterId: $theaterId, timeSlotId: $timeSlotId, userId: $userId, bookingDate: $bookingDate, startTime: $startTime, endTime: $endTime, totalAmount: $totalAmount, paymentStatus: $paymentStatus, paymentId: $paymentId, bookingStatus: $bookingStatus, guestCount: $guestCount, specialRequests: $specialRequests, contactName: $contactName, contactPhone: $contactPhone, contactEmail: $contactEmail, celebrationName: $celebrationName, numberOfPeople: $numberOfPeople, createdAt: $createdAt, updatedAt: $updatedAt, theaterName: $theaterName, screenName: $screenName, screenNumber: $screenNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.timeSlotId, timeSlotId) ||
                other.timeSlotId == timeSlotId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.bookingStatus, bookingStatus) ||
                other.bookingStatus == bookingStatus) &&
            (identical(other.guestCount, guestCount) ||
                other.guestCount == guestCount) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.celebrationName, celebrationName) ||
                other.celebrationName == celebrationName) &&
            (identical(other.numberOfPeople, numberOfPeople) ||
                other.numberOfPeople == numberOfPeople) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.theaterName, theaterName) ||
                other.theaterName == theaterName) &&
            (identical(other.screenName, screenName) ||
                other.screenName == screenName) &&
            (identical(other.screenNumber, screenNumber) ||
                other.screenNumber == screenNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        theaterId,
        timeSlotId,
        userId,
        bookingDate,
        startTime,
        endTime,
        totalAmount,
        paymentStatus,
        paymentId,
        bookingStatus,
        guestCount,
        specialRequests,
        contactName,
        contactPhone,
        contactEmail,
        celebrationName,
        numberOfPeople,
        createdAt,
        updatedAt,
        theaterName,
        screenName,
        screenNumber
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterBookingImplCopyWith<_$TheaterBookingImpl> get copyWith =>
      __$$TheaterBookingImplCopyWithImpl<_$TheaterBookingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterBookingImplToJson(
      this,
    );
  }
}

abstract class _TheaterBooking implements TheaterBooking {
  const factory _TheaterBooking(
          {required final String id,
          @JsonKey(name: 'theater_id') required final String theaterId,
          @JsonKey(name: 'time_slot_id') final String? timeSlotId,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'booking_date') required final DateTime bookingDate,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          @JsonKey(name: 'total_amount') required final double totalAmount,
          @JsonKey(name: 'payment_status') final String paymentStatus,
          @JsonKey(name: 'payment_id') final String? paymentId,
          @JsonKey(name: 'booking_status') final String bookingStatus,
          @JsonKey(name: 'guest_count') final int guestCount,
          @JsonKey(name: 'special_requests') final String? specialRequests,
          @JsonKey(name: 'contact_name') required final String contactName,
          @JsonKey(name: 'contact_phone') required final String contactPhone,
          @JsonKey(name: 'contact_email') final String? contactEmail,
          @JsonKey(name: 'celebration_name') final String? celebrationName,
          @JsonKey(name: 'number_of_people') final int numberOfPeople,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'theater_name') final String? theaterName,
          @JsonKey(name: 'screen_name') final String? screenName,
          @JsonKey(name: 'screen_number') final int? screenNumber}) =
      _$TheaterBookingImpl;

  factory _TheaterBooking.fromJson(Map<String, dynamic> json) =
      _$TheaterBookingImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'theater_id')
  String get theaterId;
  @override
  @JsonKey(name: 'time_slot_id')
  String? get timeSlotId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  @JsonKey(name: 'payment_id')
  String? get paymentId;
  @override
  @JsonKey(name: 'booking_status')
  String get bookingStatus;
  @override
  @JsonKey(name: 'guest_count')
  int get guestCount;
  @override
  @JsonKey(name: 'special_requests')
  String? get specialRequests;
  @override
  @JsonKey(name: 'contact_name')
  String get contactName;
  @override
  @JsonKey(name: 'contact_phone')
  String get contactPhone;
  @override
  @JsonKey(name: 'contact_email')
  String? get contactEmail;
  @override
  @JsonKey(name: 'celebration_name')
  String? get celebrationName;
  @override
  @JsonKey(name: 'number_of_people')
  int get numberOfPeople;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override // Related data (joined from other tables)
  @JsonKey(name: 'theater_name')
  String? get theaterName;
  @override
  @JsonKey(name: 'screen_name')
  String? get screenName;
  @override
  @JsonKey(name: 'screen_number')
  int? get screenNumber;
  @override
  @JsonKey(ignore: true)
  _$$TheaterBookingImplCopyWith<_$TheaterBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
