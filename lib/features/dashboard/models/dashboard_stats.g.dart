// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      serviceListingsCount: (json['service_listings_count'] as num).toInt(),
      totalOrdersCount: (json['total_orders_count'] as num).toInt(),
      grossSales: (json['gross_sales'] as num).toDouble(),
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
        _$DashboardStatsImpl instance) =>
    <String, dynamic>{
      'service_listings_count': instance.serviceListingsCount,
      'total_orders_count': instance.totalOrdersCount,
      'gross_sales': instance.grossSales,
    };
