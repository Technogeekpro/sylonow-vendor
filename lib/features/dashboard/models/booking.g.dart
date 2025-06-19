// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      serviceTitle: json['service_title'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_title': instance.serviceTitle,
      'booking_date': instance.bookingDate.toIso8601String(),
      'total_amount': instance.totalAmount,
    };
