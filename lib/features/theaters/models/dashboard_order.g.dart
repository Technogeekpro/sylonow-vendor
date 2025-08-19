// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardOrderImpl _$$DashboardOrderImplFromJson(Map<String, dynamic> json) =>
    _$DashboardOrderImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String?,
      serviceTitle: json['service_title'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      bookingTime: json['booking_time'] as String?,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String?,
      specialRequirements: json['special_requirements'] as String?,
      venueAddress: json['venue_address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      daysUntilBooking: (json['days_until_booking'] as num?)?.toInt(),
      urgencyLevel:
          $enumDecodeNullable(_$OrderUrgencyEnumMap, json['urgency_level']) ??
              OrderUrgency.normal,
    );

Map<String, dynamic> _$$DashboardOrderImplToJson(
        _$DashboardOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'service_title': instance.serviceTitle,
      'booking_date': instance.bookingDate.toIso8601String(),
      'booking_time': instance.bookingTime,
      'total_amount': instance.totalAmount,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'special_requirements': instance.specialRequirements,
      'venue_address': instance.venueAddress,
      'created_at': instance.createdAt.toIso8601String(),
      'days_until_booking': instance.daysUntilBooking,
      'urgency_level': _$OrderUrgencyEnumMap[instance.urgencyLevel]!,
    };

const _$OrderUrgencyEnumMap = {
  OrderUrgency.urgent: 'urgent',
  OrderUrgency.soon: 'soon',
  OrderUrgency.normal: 'normal',
};
