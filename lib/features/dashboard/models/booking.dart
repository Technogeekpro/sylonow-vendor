import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'service_listing_id') required String serviceListingId,
    @JsonKey(name: 'service_title') required String serviceTitle,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'total_amount') required double totalAmount,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'original_price') double? originalPrice,
    @JsonKey(name: 'offer_price') double? offerPrice,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
} 