// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardDataImpl _$$DashboardDataImplFromJson(Map<String, dynamic> json) =>
    _$DashboardDataImpl(
      stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      latestPendingBooking: json['latest_pending_booking'] == null
          ? null
          : Booking.fromJson(
              json['latest_pending_booking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DashboardDataImplToJson(_$DashboardDataImpl instance) =>
    <String, dynamic>{
      'stats': instance.stats,
      'latest_pending_booking': instance.latestPendingBooking,
    };
