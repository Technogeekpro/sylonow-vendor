import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @JsonKey(name: 'service_listings_count') required int serviceListingsCount,
    @JsonKey(name: 'total_orders_count') required int totalOrdersCount,
    @JsonKey(name: 'gross_sales') required double grossSales,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
} 