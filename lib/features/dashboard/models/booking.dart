import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    @JsonKey(name: 'service_title') required String serviceTitle,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'total_amount') required double totalAmount,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
} 