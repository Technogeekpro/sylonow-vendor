import 'package:freezed_annotation/freezed_annotation.dart';
import 'booking.dart';
import 'dashboard_stats.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    required DashboardStats stats,
    @JsonKey(name: 'latest_pending_booking') Booking? latestPendingBooking,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) => _$DashboardDataFromJson(json);
} 