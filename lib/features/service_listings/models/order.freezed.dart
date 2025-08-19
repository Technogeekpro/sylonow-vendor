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
  @JsonKey(name: 'vendor_id')
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_email')
  String? get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_listing_id')
  String? get serviceListingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_title')
  String get serviceTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_description')
  String? get serviceDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  DateTime get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_time')
  String? get bookingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_address')
  String? get venueAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'venue_coordinates')
  Map<String, dynamic>? get venueCoordinates =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'advance_amount')
  double? get advanceAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_amount')
  double? get remainingAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'advance_payment_id')
  String? get advancePaymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_payment_id')
  String? get remainingPaymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'place_image_url')
  String? get placeImageUrl => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'service_listing_id') String? serviceListingId,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'service_description') String? serviceDescription,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'booking_time') String? bookingTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'venue_address') String? venueAddress,
      @JsonKey(name: 'venue_coordinates')
      Map<String, dynamic>? venueCoordinates,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'advance_amount') double? advanceAmount,
      @JsonKey(name: 'remaining_amount') double? remainingAmount,
      @JsonKey(name: 'advance_payment_id') String? advancePaymentId,
      @JsonKey(name: 'remaining_payment_id') String? remainingPaymentId,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'place_image_url') String? placeImageUrl});
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
    Object? vendorId = freezed,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? serviceListingId = freezed,
    Object? serviceTitle = null,
    Object? serviceDescription = freezed,
    Object? bookingDate = null,
    Object? bookingTime = freezed,
    Object? totalAmount = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? specialRequirements = freezed,
    Object? venueAddress = freezed,
    Object? venueCoordinates = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? advanceAmount = freezed,
    Object? remainingAmount = freezed,
    Object? advancePaymentId = freezed,
    Object? remainingPaymentId = freezed,
    Object? userId = freezed,
    Object? placeImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceListingId: freezed == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceTitle: null == serviceTitle
          ? _value.serviceTitle
          : serviceTitle // ignore: cast_nullable_to_non_nullable
              as String,
      serviceDescription: freezed == serviceDescription
          ? _value.serviceDescription
          : serviceDescription // ignore: cast_nullable_to_non_nullable
              as String?,
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
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      specialRequirements: freezed == specialRequirements
          ? _value.specialRequirements
          : specialRequirements // ignore: cast_nullable_to_non_nullable
              as String?,
      venueAddress: freezed == venueAddress
          ? _value.venueAddress
          : venueAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      venueCoordinates: freezed == venueCoordinates
          ? _value.venueCoordinates
          : venueCoordinates // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      advanceAmount: freezed == advanceAmount
          ? _value.advanceAmount
          : advanceAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingAmount: freezed == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      advancePaymentId: freezed == advancePaymentId
          ? _value.advancePaymentId
          : advancePaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingPaymentId: freezed == remainingPaymentId
          ? _value.remainingPaymentId
          : remainingPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      placeImageUrl: freezed == placeImageUrl
          ? _value.placeImageUrl
          : placeImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'service_listing_id') String? serviceListingId,
      @JsonKey(name: 'service_title') String serviceTitle,
      @JsonKey(name: 'service_description') String? serviceDescription,
      @JsonKey(name: 'booking_date') DateTime bookingDate,
      @JsonKey(name: 'booking_time') String? bookingTime,
      @JsonKey(name: 'total_amount') double totalAmount,
      String status,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'special_requirements') String? specialRequirements,
      @JsonKey(name: 'venue_address') String? venueAddress,
      @JsonKey(name: 'venue_coordinates')
      Map<String, dynamic>? venueCoordinates,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'advance_amount') double? advanceAmount,
      @JsonKey(name: 'remaining_amount') double? remainingAmount,
      @JsonKey(name: 'advance_payment_id') String? advancePaymentId,
      @JsonKey(name: 'remaining_payment_id') String? remainingPaymentId,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'place_image_url') String? placeImageUrl});
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
    Object? vendorId = freezed,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? customerEmail = freezed,
    Object? serviceListingId = freezed,
    Object? serviceTitle = null,
    Object? serviceDescription = freezed,
    Object? bookingDate = null,
    Object? bookingTime = freezed,
    Object? totalAmount = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? specialRequirements = freezed,
    Object? venueAddress = freezed,
    Object? venueCoordinates = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? advanceAmount = freezed,
    Object? remainingAmount = freezed,
    Object? advancePaymentId = freezed,
    Object? remainingPaymentId = freezed,
    Object? userId = freezed,
    Object? placeImageUrl = freezed,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceListingId: freezed == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceTitle: null == serviceTitle
          ? _value.serviceTitle
          : serviceTitle // ignore: cast_nullable_to_non_nullable
              as String,
      serviceDescription: freezed == serviceDescription
          ? _value.serviceDescription
          : serviceDescription // ignore: cast_nullable_to_non_nullable
              as String?,
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
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      specialRequirements: freezed == specialRequirements
          ? _value.specialRequirements
          : specialRequirements // ignore: cast_nullable_to_non_nullable
              as String?,
      venueAddress: freezed == venueAddress
          ? _value.venueAddress
          : venueAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      venueCoordinates: freezed == venueCoordinates
          ? _value._venueCoordinates
          : venueCoordinates // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      advanceAmount: freezed == advanceAmount
          ? _value.advanceAmount
          : advanceAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingAmount: freezed == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      advancePaymentId: freezed == advancePaymentId
          ? _value.advancePaymentId
          : advancePaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingPaymentId: freezed == remainingPaymentId
          ? _value.remainingPaymentId
          : remainingPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      placeImageUrl: freezed == placeImageUrl
          ? _value.placeImageUrl
          : placeImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl(
      {required this.id,
      @JsonKey(name: 'vendor_id') this.vendorId,
      @JsonKey(name: 'customer_name') required this.customerName,
      @JsonKey(name: 'customer_phone') this.customerPhone,
      @JsonKey(name: 'customer_email') this.customerEmail,
      @JsonKey(name: 'service_listing_id') this.serviceListingId,
      @JsonKey(name: 'service_title') required this.serviceTitle,
      @JsonKey(name: 'service_description') this.serviceDescription,
      @JsonKey(name: 'booking_date') required this.bookingDate,
      @JsonKey(name: 'booking_time') this.bookingTime,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      required this.status,
      @JsonKey(name: 'payment_status') required this.paymentStatus,
      @JsonKey(name: 'special_requirements') this.specialRequirements,
      @JsonKey(name: 'venue_address') this.venueAddress,
      @JsonKey(name: 'venue_coordinates')
      final Map<String, dynamic>? venueCoordinates,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'advance_amount') this.advanceAmount,
      @JsonKey(name: 'remaining_amount') this.remainingAmount,
      @JsonKey(name: 'advance_payment_id') this.advancePaymentId,
      @JsonKey(name: 'remaining_payment_id') this.remainingPaymentId,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'place_image_url') this.placeImageUrl})
      : _venueCoordinates = venueCoordinates;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vendor_id')
  final String? vendorId;
  @override
  @JsonKey(name: 'customer_name')
  final String customerName;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
  @override
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  @override
  @JsonKey(name: 'service_listing_id')
  final String? serviceListingId;
  @override
  @JsonKey(name: 'service_title')
  final String serviceTitle;
  @override
  @JsonKey(name: 'service_description')
  final String? serviceDescription;
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
  final String paymentStatus;
  @override
  @JsonKey(name: 'special_requirements')
  final String? specialRequirements;
  @override
  @JsonKey(name: 'venue_address')
  final String? venueAddress;
  final Map<String, dynamic>? _venueCoordinates;
  @override
  @JsonKey(name: 'venue_coordinates')
  Map<String, dynamic>? get venueCoordinates {
    final value = _venueCoordinates;
    if (value == null) return null;
    if (_venueCoordinates is EqualUnmodifiableMapView) return _venueCoordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'advance_amount')
  final double? advanceAmount;
  @override
  @JsonKey(name: 'remaining_amount')
  final double? remainingAmount;
  @override
  @JsonKey(name: 'advance_payment_id')
  final String? advancePaymentId;
  @override
  @JsonKey(name: 'remaining_payment_id')
  final String? remainingPaymentId;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'place_image_url')
  final String? placeImageUrl;

  @override
  String toString() {
    return 'Order(id: $id, vendorId: $vendorId, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, serviceListingId: $serviceListingId, serviceTitle: $serviceTitle, serviceDescription: $serviceDescription, bookingDate: $bookingDate, bookingTime: $bookingTime, totalAmount: $totalAmount, status: $status, paymentStatus: $paymentStatus, specialRequirements: $specialRequirements, venueAddress: $venueAddress, venueCoordinates: $venueCoordinates, createdAt: $createdAt, updatedAt: $updatedAt, advanceAmount: $advanceAmount, remainingAmount: $remainingAmount, advancePaymentId: $advancePaymentId, remainingPaymentId: $remainingPaymentId, userId: $userId, placeImageUrl: $placeImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.serviceListingId, serviceListingId) ||
                other.serviceListingId == serviceListingId) &&
            (identical(other.serviceTitle, serviceTitle) ||
                other.serviceTitle == serviceTitle) &&
            (identical(other.serviceDescription, serviceDescription) ||
                other.serviceDescription == serviceDescription) &&
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
            const DeepCollectionEquality()
                .equals(other._venueCoordinates, _venueCoordinates) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.advanceAmount, advanceAmount) ||
                other.advanceAmount == advanceAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.advancePaymentId, advancePaymentId) ||
                other.advancePaymentId == advancePaymentId) &&
            (identical(other.remainingPaymentId, remainingPaymentId) ||
                other.remainingPaymentId == remainingPaymentId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.placeImageUrl, placeImageUrl) ||
                other.placeImageUrl == placeImageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        vendorId,
        customerName,
        customerPhone,
        customerEmail,
        serviceListingId,
        serviceTitle,
        serviceDescription,
        bookingDate,
        bookingTime,
        totalAmount,
        status,
        paymentStatus,
        specialRequirements,
        venueAddress,
        const DeepCollectionEquality().hash(_venueCoordinates),
        createdAt,
        updatedAt,
        advanceAmount,
        remainingAmount,
        advancePaymentId,
        remainingPaymentId,
        userId,
        placeImageUrl
      ]);

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
      @JsonKey(name: 'vendor_id') final String? vendorId,
      @JsonKey(name: 'customer_name') required final String customerName,
      @JsonKey(name: 'customer_phone') final String? customerPhone,
      @JsonKey(name: 'customer_email') final String? customerEmail,
      @JsonKey(name: 'service_listing_id') final String? serviceListingId,
      @JsonKey(name: 'service_title') required final String serviceTitle,
      @JsonKey(name: 'service_description') final String? serviceDescription,
      @JsonKey(name: 'booking_date') required final DateTime bookingDate,
      @JsonKey(name: 'booking_time') final String? bookingTime,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      required final String status,
      @JsonKey(name: 'payment_status') required final String paymentStatus,
      @JsonKey(name: 'special_requirements') final String? specialRequirements,
      @JsonKey(name: 'venue_address') final String? venueAddress,
      @JsonKey(name: 'venue_coordinates')
      final Map<String, dynamic>? venueCoordinates,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'advance_amount') final double? advanceAmount,
      @JsonKey(name: 'remaining_amount') final double? remainingAmount,
      @JsonKey(name: 'advance_payment_id') final String? advancePaymentId,
      @JsonKey(name: 'remaining_payment_id') final String? remainingPaymentId,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'place_image_url')
      final String? placeImageUrl}) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vendor_id')
  String? get vendorId;
  @override
  @JsonKey(name: 'customer_name')
  String get customerName;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override
  @JsonKey(name: 'customer_email')
  String? get customerEmail;
  @override
  @JsonKey(name: 'service_listing_id')
  String? get serviceListingId;
  @override
  @JsonKey(name: 'service_title')
  String get serviceTitle;
  @override
  @JsonKey(name: 'service_description')
  String? get serviceDescription;
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
  String get paymentStatus;
  @override
  @JsonKey(name: 'special_requirements')
  String? get specialRequirements;
  @override
  @JsonKey(name: 'venue_address')
  String? get venueAddress;
  @override
  @JsonKey(name: 'venue_coordinates')
  Map<String, dynamic>? get venueCoordinates;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'advance_amount')
  double? get advanceAmount;
  @override
  @JsonKey(name: 'remaining_amount')
  double? get remainingAmount;
  @override
  @JsonKey(name: 'advance_payment_id')
  String? get advancePaymentId;
  @override
  @JsonKey(name: 'remaining_payment_id')
  String? get remainingPaymentId;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'place_image_url')
  String? get placeImageUrl;
  @override
  @JsonKey(ignore: true)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
