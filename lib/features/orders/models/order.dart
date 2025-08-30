import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'service_title') required String serviceTitle,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'total_amount') required double totalAmount,
    required String status,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'booking_time') String? bookingTime,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'special_requirements') String? specialRequirements,
    @JsonKey(name: 'venue_address') String? venueAddress,
    @JsonKey(name: 'duration_hours') int? durationHours,
    @JsonKey(name: 'advance_amount') double? advanceAmount,
    @JsonKey(name: 'remaining_amount') double? remainingAmount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
} 