// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      userId: json['user_id'] as String,
      serviceListingId: json['service_listing_id'] as String,
      serviceTitle: json['service_title'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      customerName: json['customer_name'] as String?,
      customerEmail: json['customer_email'] as String?,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      offerPrice: (json['offer_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'user_id': instance.userId,
      'service_listing_id': instance.serviceListingId,
      'service_title': instance.serviceTitle,
      'booking_date': instance.bookingDate.toIso8601String(),
      'total_amount': instance.totalAmount,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'customer_name': instance.customerName,
      'customer_email': instance.customerEmail,
      'original_price': instance.originalPrice,
      'offer_price': instance.offerPrice,
    };
