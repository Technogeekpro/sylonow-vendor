import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'total_theaters') @Default(0) int totalTheaters,
    @JsonKey(name: 'active_theaters') @Default(0) int activeTheaters,
    @JsonKey(name: 'total_orders') @Default(0) int totalOrders,
    @JsonKey(name: 'pending_orders') @Default(0) int pendingOrders,
    @JsonKey(name: 'completed_orders') @Default(0) int completedOrders,
    @JsonKey(name: 'gross_sales') @Default(0.0) double grossSales,
    @JsonKey(name: 'total_earnings') @Default(0.0) double totalEarnings,
    @JsonKey(name: 'monthly_earnings') @Default(0.0) double monthlyEarnings,
    @JsonKey(name: 'orders_this_week') @Default(0) int ordersThisWeek,
    @JsonKey(name: 'orders_today') @Default(0) int ordersToday,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
}