import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_order.freezed.dart';
part 'dashboard_order.g.dart';

enum OrderUrgency {
  @JsonValue('urgent')
  urgent,
  @JsonValue('soon')
  soon,
  @JsonValue('normal')
  normal,
}

enum OrderAction {
  accept,
  reject,
  view,
}

@freezed
class DashboardOrder with _$DashboardOrder {
  const factory DashboardOrder({
    required String id,
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    @JsonKey(name: 'service_title') required String serviceTitle,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'booking_time') String? bookingTime,
    @JsonKey(name: 'total_amount') required double totalAmount,
    required String status,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'special_requirements') String? specialRequirements,
    @JsonKey(name: 'venue_address') String? venueAddress,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'days_until_booking') int? daysUntilBooking,
    @JsonKey(name: 'urgency_level') @Default(OrderUrgency.normal) OrderUrgency urgencyLevel,
  }) = _DashboardOrder;

  factory DashboardOrder.fromJson(Map<String, dynamic> json) => _$DashboardOrderFromJson(json);
}

@freezed
class OrderActionResult with _$OrderActionResult {
  const factory OrderActionResult({
    required bool success,
    String? message,
    DashboardOrder? updatedOrder,
  }) = _OrderActionResult;
}