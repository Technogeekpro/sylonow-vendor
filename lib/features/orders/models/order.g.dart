// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      serviceTitle: json['service_title'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      customerEmail: json['customer_email'] as String?,
      bookingTime: json['booking_time'] as String?,
      paymentStatus: json['payment_status'] as String?,
      specialRequirements: json['special_requirements'] as String?,
      venueAddress: json['venue_address'] as String?,
      durationHours: (json['duration_hours'] as num?)?.toInt(),
      advanceAmount: (json['advance_amount'] as num?)?.toDouble(),
      remainingAmount: (json['remaining_amount'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_title': instance.serviceTitle,
      'booking_date': instance.bookingDate.toIso8601String(),
      'total_amount': instance.totalAmount,
      'status': instance.status,
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'customer_email': instance.customerEmail,
      'booking_time': instance.bookingTime,
      'payment_status': instance.paymentStatus,
      'special_requirements': instance.specialRequirements,
      'venue_address': instance.venueAddress,
      'duration_hours': instance.durationHours,
      'advance_amount': instance.advanceAmount,
      'remaining_amount': instance.remainingAmount,
      'created_at': instance.createdAt?.toIso8601String(),
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };
