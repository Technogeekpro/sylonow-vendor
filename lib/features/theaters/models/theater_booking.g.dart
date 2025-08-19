// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TheaterBookingImpl _$$TheaterBookingImplFromJson(Map<String, dynamic> json) =>
    _$TheaterBookingImpl(
      id: json['id'] as String,
      theaterId: json['theater_id'] as String,
      timeSlotId: json['time_slot_id'] as String?,
      userId: json['user_id'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      paymentId: json['payment_id'] as String?,
      bookingStatus: json['booking_status'] as String? ?? 'confirmed',
      guestCount: (json['guest_count'] as num?)?.toInt() ?? 1,
      specialRequests: json['special_requests'] as String?,
      contactName: json['contact_name'] as String,
      contactPhone: json['contact_phone'] as String,
      contactEmail: json['contact_email'] as String?,
      celebrationName: json['celebration_name'] as String?,
      numberOfPeople: (json['number_of_people'] as num?)?.toInt() ?? 2,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      theaterName: json['theater_name'] as String?,
      screenName: json['screen_name'] as String?,
      screenNumber: (json['screen_number'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TheaterBookingImplToJson(
        _$TheaterBookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theater_id': instance.theaterId,
      'time_slot_id': instance.timeSlotId,
      'user_id': instance.userId,
      'booking_date': instance.bookingDate.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'total_amount': instance.totalAmount,
      'payment_status': instance.paymentStatus,
      'payment_id': instance.paymentId,
      'booking_status': instance.bookingStatus,
      'guest_count': instance.guestCount,
      'special_requests': instance.specialRequests,
      'contact_name': instance.contactName,
      'contact_phone': instance.contactPhone,
      'contact_email': instance.contactEmail,
      'celebration_name': instance.celebrationName,
      'number_of_people': instance.numberOfPeople,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'theater_name': instance.theaterName,
      'screen_name': instance.screenName,
      'screen_number': instance.screenNumber,
    };
