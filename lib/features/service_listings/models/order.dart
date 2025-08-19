import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'vendor_id') String? vendorId,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'service_listing_id') String? serviceListingId,
    @JsonKey(name: 'service_title') required String serviceTitle,
    @JsonKey(name: 'service_description') String? serviceDescription,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'booking_time') String? bookingTime,
    @JsonKey(name: 'total_amount') required double totalAmount,
    required String status,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(name: 'special_requirements') String? specialRequirements,
    @JsonKey(name: 'venue_address') String? venueAddress,
    @JsonKey(name: 'venue_coordinates') Map<String, dynamic>? venueCoordinates,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'advance_amount') double? advanceAmount,
    @JsonKey(name: 'remaining_amount') double? remainingAmount,
    @JsonKey(name: 'advance_payment_id') String? advancePaymentId,
    @JsonKey(name: 'remaining_payment_id') String? remainingPaymentId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'place_image_url') String? placeImageUrl,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}