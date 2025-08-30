// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardOrder _$DashboardOrderFromJson(Map<String, dynamic> json) {
  return _DashboardOrder.fromJson(json);
}

/// @nodoc
mixin _$DashboardOrder {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_title')
  String get serviceTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_time')
  String? get bookingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_address')
  String? get venueAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_until_booking')
  int? get daysUntilBooking => throw _privateConstructorUsedError;
  @JsonKey(name: 'urgency_level')
  OrderUrgency get urgencyLevel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardOrderCopyWith<DashboardOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardOrderCopyWith<$Res> {
  factory $DashboardOrderCopyWith(
          DashboardOrder value, $Res Function(DashboardOrder) then) =
      _$DashboardOrderCopyWithImpl<$Res, DashboardOrder>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'booking_time') String? bookingTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'payment_status') String? paymentStatus,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'venue_address') String? venueAddress,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'days_until_booking') int? daysUntilBooking,
      @JsonKey(name: 'urgency_level') OrderUrgency urgencyLevel});
}

/// @nodoc
class _$DashboardOrderCopyWithImpl<$Res, $Val extends DashboardOrder>
    implements $DashboardOrderCopyWith<$Res> {
  _$DashboardOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? serviceTitle = null,
    Object? bookingDate = null,
    Object? bookingTime = freezed,
    Object? totalAmount = null,
    Object? status = null,
    Object? paymentStatus = freezed,
    Object? specialRequirements = freezed,
    Object? venueAddress = freezed,
    Object? createdAt = null,
    Object? daysUntilBooking = freezed,
    Object? urgencyLevel = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceTitle: null == serviceTitle
          ? _value.serviceTitle
          : serviceTitle // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingTime: freezed == bookingTime
          ? _value.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daysUntilBooking: freezed == daysUntilBooking
          ? _value.daysUntilBooking
          : daysUntilBooking // ignore: cast_nullable_to_non_nullable
              as int?,
      urgencyLevel: null == urgencyLevel
          ? _value.urgencyLevel
          : urgencyLevel // ignore: cast_nullable_to_non_nullable
              as OrderUrgency,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardOrderImplCopyWith<$Res>
    implements $DashboardOrderCopyWith<$Res> {
  factory _$$DashboardOrderImplCopyWith(_$DashboardOrderImpl value,
          $Res Function(_$DashboardOrderImpl) then) =
      __$$DashboardOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'booking_time') String? bookingTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'payment_status') String? paymentStatus,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'venue_address') String? venueAddress,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'days_until_booking') int? daysUntilBooking,
      @JsonKey(name: 'urgency_level') OrderUrgency urgencyLevel});
}

/// @nodoc
class __$$DashboardOrderImplCopyWithImpl<$Res>
    extends _$DashboardOrderCopyWithImpl<$Res, _$DashboardOrderImpl>
    implements _$$DashboardOrderImplCopyWith<$Res> {
  __$$DashboardOrderImplCopyWithImpl(
      _$DashboardOrderImpl _value, $Res Function(_$DashboardOrderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? serviceTitle = null,
    Object? bookingDate = null,
    Object? bookingTime = freezed,
    Object? totalAmount = null,
    Object? status = null,
    Object? paymentStatus = freezed,
    Object? specialRequirements = freezed,
    Object? venueAddress = freezed,
    Object? createdAt = null,
    Object? daysUntilBooking = freezed,
    Object? urgencyLevel = null,
  }) {
    return _then(_$DashboardOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceTitle: null == serviceTitle
          ? _value.serviceTitle
          : serviceTitle // ignore: cast_nullable_to_non_nullable
              as String,
      bookingDate: null == bookingDate
          ? _value.bookingDate
          : bookingDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingTime: freezed == bookingTime
          ? _value.bookingTime
          : bookingTime // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daysUntilBooking: freezed == daysUntilBooking
          ? _value.daysUntilBooking
          : daysUntilBooking // ignore: cast_nullable_to_non_nullable
              as int?,
      urgencyLevel: null == urgencyLevel
          ? _value.urgencyLevel
          : urgencyLevel // ignore: cast_nullable_to_non_nullable
              as OrderUrgency,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardOrderImpl implements _DashboardOrder {
  const _$DashboardOrderImpl(
      {required this.id,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'customer_name') required this.customerName,
      @JsonKey(name: 'customer_phone') this.customerPhone,
      @JsonKey(name: 'service_title') required this.serviceTitle,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'booking_time') this.bookingTime,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      required this.status,
      @JsonKey(name: 'payment_status') this.paymentStatus,
      @JsonKey(name: 'special_requirements') this.specialRequirements,
      @JsonKey(name: 'venue_address') this.venueAddress,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'days_until_booking') this.daysUntilBooking,
      @JsonKey(name: 'urgency_level') this.urgencyLevel = OrderUrgency.normal});

  factory _$DashboardOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardOrderImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'customer_name')
  final String customerName;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
  @override
  @JsonKey(name: 'service_title')
  final String serviceTitle;
  @override
  @JsonKey(name: 'booking_date')
  final DateTime bookingDate;
  @override
  @JsonKey(name: 'booking_time')
  final String? bookingTime;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  final String status;
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
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'days_until_booking')
  final int? daysUntilBooking;
  @override
  @JsonKey(name: 'urgency_level')
  final OrderUrgency urgencyLevel;

  @override
  String toString() {
    return 'DashboardOrder(id: $id, vendorId: $vendorId, customerName: $customerName, customerPhone: $customerPhone, serviceTitle: $serviceTitle, bookingDate: $bookingDate, bookingTime: $bookingTime, totalAmount: $totalAmount, status: $status, paymentStatus: $paymentStatus, specialRequirements: $specialRequirements, venueAddress: $venueAddress, createdAt: $createdAt, daysUntilBooking: $daysUntilBooking, urgencyLevel: $urgencyLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.serviceTitle, serviceTitle) ||
                other.serviceTitle == serviceTitle) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.bookingTime, bookingTime) ||
                other.bookingTime == bookingTime) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.specialRequirements, specialRequirements) ||
                other.specialRequirements == specialRequirements) &&
            (identical(other.venueAddress, venueAddress) ||
                other.venueAddress == venueAddress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.daysUntilBooking, daysUntilBooking) ||
                other.daysUntilBooking == daysUntilBooking) &&
            (identical(other.urgencyLevel, urgencyLevel) ||
                other.urgencyLevel == urgencyLevel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vendorId,
      customerName,
      customerPhone,
      serviceTitle,
      bookingDate,
      bookingTime,
      totalAmount,
      status,
      paymentStatus,
      specialRequirements,
      venueAddress,
      createdAt,
      daysUntilBooking,
      urgencyLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardOrderImplCopyWith<_$DashboardOrderImpl> get copyWith =>
      __$$DashboardOrderImplCopyWithImpl<_$DashboardOrderImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardOrderImplToJson(
      this,
    );
  }
}

abstract class _DashboardOrder implements DashboardOrder {
  const factory _DashboardOrder(
      {required final String id,
      @JsonKey(name: 'vendor_id') required final String vendorId,
      @JsonKey(name: 'customer_name') required final String customerName,
      @JsonKey(name: 'customer_phone') final String? customerPhone,
      @JsonKey(name: 'service_title') required final String serviceTitle,
      @JsonKey(name: 'booking_date') required final DateTime bookingDate,
      @JsonKey(name: 'booking_time') final String? bookingTime,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      required final String status,
      @JsonKey(name: 'payment_status') final String? paymentStatus,
      @JsonKey(name: 'special_requirements') final String? specialRequirements,
      @JsonKey(name: 'venue_address') final String? venueAddress,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'days_until_booking') final int? daysUntilBooking,
      @JsonKey(name: 'urgency_level')
      final OrderUrgency urgencyLevel}) = _$DashboardOrderImpl;

  factory _DashboardOrder.fromJson(Map<String, dynamic> json) =
      _$DashboardOrderImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'customer_name')
  String get customerName;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override
  @JsonKey(name: 'service_title')
  String get serviceTitle;
  @override
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate;
  @override
  @JsonKey(name: 'booking_time')
  String? get bookingTime;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  String get status;
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
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'days_until_booking')
  int? get daysUntilBooking;
  @override
  @JsonKey(name: 'urgency_level')
  OrderUrgency get urgencyLevel;
  @override
  @JsonKey(ignore: true)
  _$$DashboardOrderImplCopyWith<_$DashboardOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderActionResult {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  DashboardOrder? get updatedOrder => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderActionResultCopyWith<OrderActionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderActionResultCopyWith<$Res> {
  factory $OrderActionResultCopyWith(
          OrderActionResult value, $Res Function(OrderActionResult) then) =
      _$OrderActionResultCopyWithImpl<$Res, OrderActionResult>;
  @useResult
  $Res call({bool success, String? message, DashboardOrder? updatedOrder});

  $DashboardOrderCopyWith<$Res>? get updatedOrder;
}

/// @nodoc
class _$OrderActionResultCopyWithImpl<$Res, $Val extends OrderActionResult>
    implements $OrderActionResultCopyWith<$Res> {
  _$OrderActionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? updatedOrder = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedOrder: freezed == updatedOrder
          ? _value.updatedOrder
          : updatedOrder // ignore: cast_nullable_to_non_nullable
              as DashboardOrder?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DashboardOrderCopyWith<$Res>? get updatedOrder {
    if (_value.updatedOrder == null) {
      return null;
    }

    return $DashboardOrderCopyWith<$Res>(_value.updatedOrder!, (value) {
      return _then(_value.copyWith(updatedOrder: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderActionResultImplCopyWith<$Res>
    implements $OrderActionResultCopyWith<$Res> {
  factory _$$OrderActionResultImplCopyWith(_$OrderActionResultImpl value,
          $Res Function(_$OrderActionResultImpl) then) =
      __$$OrderActionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? message, DashboardOrder? updatedOrder});

  @override
  $DashboardOrderCopyWith<$Res>? get updatedOrder;
}

/// @nodoc
class __$$OrderActionResultImplCopyWithImpl<$Res>
    extends _$OrderActionResultCopyWithImpl<$Res, _$OrderActionResultImpl>
    implements _$$OrderActionResultImplCopyWith<$Res> {
  __$$OrderActionResultImplCopyWithImpl(_$OrderActionResultImpl _value,
      $Res Function(_$OrderActionResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? updatedOrder = freezed,
  }) {
    return _then(_$OrderActionResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedOrder: freezed == updatedOrder
          ? _value.updatedOrder
          : updatedOrder // ignore: cast_nullable_to_non_nullable
              as DashboardOrder?,
    ));
  }
}

/// @nodoc

class _$OrderActionResultImpl implements _OrderActionResult {
  const _$OrderActionResultImpl(
      {required this.success, this.message, this.updatedOrder});

  @override
  final bool success;
  @override
  final String? message;
  @override
  final DashboardOrder? updatedOrder;

  @override
  String toString() {
    return 'OrderActionResult(success: $success, message: $message, updatedOrder: $updatedOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderActionResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.updatedOrder, updatedOrder) ||
                other.updatedOrder == updatedOrder));
  }

  @override
  int get hashCode => Object.hash(runtimeType, success, message, updatedOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderActionResultImplCopyWith<_$OrderActionResultImpl> get copyWith =>
      __$$OrderActionResultImplCopyWithImpl<_$OrderActionResultImpl>(
          this, _$identity);
}

abstract class _OrderActionResult implements OrderActionResult {
  const factory _OrderActionResult(
      {required final bool success,
      final String? message,
      final DashboardOrder? updatedOrder}) = _$OrderActionResultImpl;

  @override
  bool get success;
  @override
  String? get message;
  @override
  DashboardOrder? get updatedOrder;
  @override
  @JsonKey(ignore: true)
  _$$OrderActionResultImplCopyWith<_$OrderActionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
