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
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_title': instance.serviceTitle,
      'booking_date': instance.bookingDate.toIso8601String(),
      'total_amount': instance.totalAmount,
      'status': instance.status,
    };
