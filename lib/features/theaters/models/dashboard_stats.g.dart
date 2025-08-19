// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      vendorId: json['vendor_id'] as String,
      fullName: json['full_name'] as String?,
      totalTheaters: (json['total_theaters'] as num?)?.toInt() ?? 0,
      activeTheaters: (json['active_theaters'] as num?)?.toInt() ?? 0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      pendingOrders: (json['pending_orders'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completed_orders'] as num?)?.toInt() ?? 0,
      grossSales: (json['gross_sales'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      monthlyEarnings: (json['monthly_earnings'] as num?)?.toDouble() ?? 0.0,
      ordersThisWeek: (json['orders_this_week'] as num?)?.toInt() ?? 0,
      ordersToday: (json['orders_today'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
        _$DashboardStatsImpl instance) =>
    <String, dynamic>{
      'vendor_id': instance.vendorId,
      'full_name': instance.fullName,
      'total_theaters': instance.totalTheaters,
      'active_theaters': instance.activeTheaters,
      'total_orders': instance.totalOrders,
      'pending_orders': instance.pendingOrders,
      'completed_orders': instance.completedOrders,
      'gross_sales': instance.grossSales,
      'total_earnings': instance.totalEarnings,
      'monthly_earnings': instance.monthlyEarnings,
      'orders_this_week': instance.ordersThisWeek,
      'orders_today': instance.ordersToday,
    };
