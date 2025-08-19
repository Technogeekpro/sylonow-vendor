// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_title')
  String get serviceTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_email')
  String? get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_time')
  String? get bookingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_address')
  String? get venueAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_hours')
  int? get durationHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'advance_amount')
  double? get advanceAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_amount')
  double? get remainingAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'customer_name') String? customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'booking_time') String? bookingTime,
      @JsonKey(name: 'payment_status') String? paymentStatus,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'venue_address') String? venueAddress,
      @JsonKey(name: 'duration_hours') int? durationHours,
      @JsonKey(name: 'advance_amount') double? advanceAmount,
      @JsonKey(name: 'remaining_amount') double? remainingAmount,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceTitle = null,
    Object? bookingDate = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? bookingTime = freezed,
    Object? paymentStatus = freezed,
    Object? specialRequirements = freezed,
    Object? venueAddress = freezed,
    Object? durationHours = freezed,
    Object? advanceAmount = freezed,
    Object? remainingAmount = freezed,
    Object? createdAt = freezed,
    Object? confirmedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceTitle: null == serviceTitle
          ? _value.serviceTitle
          : serviceTitle // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingTime: freezed == bookingTime
          ? _value.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      specialRequirements: freezed == specialRequirements
          ? _value.specialRequirements
          : specialRequirements // ignore: cast_nullable_to_non_nullable
              as String?,
      venueAddress: freezed == venueAddress
          ? _value.venueAddress
          : venueAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      durationHours: freezed == durationHours
          ? _value.durationHours
          : durationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      advanceAmount: freezed == advanceAmount
          ? _value.advanceAmount
          : advanceAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingAmount: freezed == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'customer_name') String? customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'booking_time') String? bookingTime,
      @JsonKey(name: 'payment_status') String? paymentStatus,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'venue_address') String? venueAddress,
      @JsonKey(name: 'duration_hours') int? durationHours,
      @JsonKey(name: 'advance_amount') double? advanceAmount,
      @JsonKey(name: 'remaining_amount') double? remainingAmount,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt});
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceTitle = null,
    Object? bookingDate = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? bookingTime = freezed,
    Object? paymentStatus = freezed,
    Object? specialRequirements = freezed,
    Object? venueAddress = freezed,
    Object? durationHours = freezed,
    Object? advanceAmount = freezed,
    Object? remainingAmount = freezed,
    Object? createdAt = freezed,
    Object? confirmedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceTitle: null == serviceTitle
          ? _value.serviceTitle
          : serviceTitle // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingTime: freezed == bookingTime
          ? _value.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      specialRequirements: freezed == specialRequirements
          ? _value.specialRequirements
          : specialRequirements // ignore: cast_nullable_to_non_nullable
              as String?,
      venueAddress: freezed == venueAddress
          ? _value.venueAddress
          : venueAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      durationHours: freezed == durationHours
          ? _value.durationHours
          : durationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      advanceAmount: freezed == advanceAmount
          ? _value.advanceAmount
          : advanceAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingAmount: freezed == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl(
      {required this.id,
      @JsonKey(name: 'service_title') required this.serviceTitle,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      required this.status,
      @JsonKey(name: 'customer_name') this.customerName,
      @JsonKey(name: 'customer_phone') this.customerPhone,
      @JsonKey(name: 'customer_email') this.customerEmail,
      @JsonKey(name: 'booking_time') this.bookingTime,
      @JsonKey(name: 'payment_status') this.paymentStatus,
      @JsonKey(name: 'special_requirements') this.specialRequirements,
      @JsonKey(name: 'venue_address') this.venueAddress,
      @JsonKey(name: 'duration_hours') this.durationHours,
      @JsonKey(name: 'advance_amount') this.advanceAmount,
      @JsonKey(name: 'remaining_amount') this.remainingAmount,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'confirmed_at') this.confirmedAt,
      @JsonKey(name: 'completed_at') this.completedAt});

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'service_title')
  final String serviceTitle;
  @override
  @JsonKey(name: 'booking_date')
  final DateTime bookingDate;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  final String status;
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
  @override
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  @override
  @JsonKey(name: 'booking_time')
  final String? bookingTime;
  @override
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @override
  @JsonKey(name: 'special_requirements')
  final String? specialRequirements;
  @override
  @JsonKey(name: 'venue_address')
  final String? venueAddress;
  @override
  @JsonKey(name: 'duration_hours')
  final int? durationHours;
  @override
  @JsonKey(name: 'advance_amount')
  final double? advanceAmount;
  @override
  @JsonKey(name: 'remaining_amount')
  final double? remainingAmount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'confirmed_at')
  final DateTime? confirmedAt;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @override
  String toString() {
    return 'Order(id: $id, serviceTitle: $serviceTitle, bookingDate: $bookingDate, totalAmount: $totalAmount, status: $status, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, bookingTime: $bookingTime, paymentStatus: $paymentStatus, specialRequirements: $specialRequirements, venueAddress: $venueAddress, durationHours: $durationHours, advanceAmount: $advanceAmount, remainingAmount: $remainingAmount, createdAt: $createdAt, confirmedAt: $confirmedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceTitle, serviceTitle) ||
                other.serviceTitle == serviceTitle) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.bookingTime, bookingTime) ||
                other.bookingTime == bookingTime) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.specialRequirements, specialRequirements) ||
                other.specialRequirements == specialRequirements) &&
            (identical(other.venueAddress, venueAddress) ||
                other.venueAddress == venueAddress) &&
            (identical(other.durationHours, durationHours) ||
                other.durationHours == durationHours) &&
            (identical(other.advanceAmount, advanceAmount) ||
                other.advanceAmount == advanceAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      serviceTitle,
      bookingDate,
      totalAmount,
      status,
      customerName,
      customerPhone,
      customerEmail,
      bookingTime,
      paymentStatus,
      specialRequirements,
      venueAddress,
      durationHours,
      advanceAmount,
      remainingAmount,
      createdAt,
      confirmedAt,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(
      this,
    );
  }
}

abstract class _Order implements Order {
  const factory _Order(
      {required final String id,
      @JsonKey(name: 'service_title') required final String serviceTitle,
      @JsonKey(name: 'booking_date') required final DateTime bookingDate,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      required final String status,
      @JsonKey(name: 'customer_name') final String? customerName,
      @JsonKey(name: 'customer_phone') final String? customerPhone,
      @JsonKey(name: 'customer_email') final String? customerEmail,
      @JsonKey(name: 'booking_time') final String? bookingTime,
      @JsonKey(name: 'payment_status') final String? paymentStatus,
      @JsonKey(name: 'special_requirements') final String? specialRequirements,
      @JsonKey(name: 'venue_address') final String? venueAddress,
      @JsonKey(name: 'duration_hours') final int? durationHours,
      @JsonKey(name: 'advance_amount') final double? advanceAmount,
      @JsonKey(name: 'remaining_amount') final double? remainingAmount,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'confirmed_at') final DateTime? confirmedAt,
      @JsonKey(name: 'completed_at')
      final DateTime? completedAt}) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'service_title')
  String get serviceTitle;
  @override
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  String get status;
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override
  @JsonKey(name: 'customer_email')
  String? get customerEmail;
  @override
  @JsonKey(name: 'booking_time')
  String? get bookingTime;
  @override
  @JsonKey(name: 'payment_status')
  String? get paymentStatus;
  @override
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements;
  @override
  @JsonKey(name: 'venue_address')
  String? get venueAddress;
  @override
  @JsonKey(name: 'duration_hours')
  int? get durationHours;
  @override
  @JsonKey(name: 'advance_amount')
  double? get advanceAmount;
  @override
  @JsonKey(name: 'remaining_amount')
  double? get remainingAmount;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
