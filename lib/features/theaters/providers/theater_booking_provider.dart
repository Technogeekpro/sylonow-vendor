import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../onboarding/providers/vendor_provider.dart';
import '../models/theater_booking.dart';
import '../service/theater_booking_service.dart';

part 'theater_booking_provider.g.dart';

@riverpod
class VendorBookings extends _$VendorBookings {
  @override
  Future<List<TheaterBooking>> build() async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor?.authUserId == null) return [];
    
    print('🔍 PROVIDER DEBUG: Vendor ID: ${vendor!.id}, Auth User ID: ${vendor.authUserId}');
    
    final service = ref.watch(theaterBookingServiceProvider);
    return service.getVendorBookings(vendor.authUserId!);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class BookingStats extends _$BookingStats {
  @override
  Future<Map<String, dynamic>> build() async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor?.authUserId == null) return {};
    
    print('🔍 STATS PROVIDER DEBUG: Vendor ID: ${vendor!.id}, Auth User ID: ${vendor.authUserId}');
    
    final service = ref.watch(theaterBookingServiceProvider);
    return service.getBookingStats(vendor.authUserId!);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class TodayBookings extends _$TodayBookings {
  @override
  Future<List<TheaterBooking>> build() async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor?.authUserId == null) return [];
    
    final service = ref.watch(theaterBookingServiceProvider);
    return service.getTodayBookings(vendor!.authUserId!);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class UpcomingBookings extends _$UpcomingBookings {
  @override
  Future<List<TheaterBooking>> build() async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor?.authUserId == null) return [];
    
    final service = ref.watch(theaterBookingServiceProvider);
    return service.getUpcomingBookings(vendor!.authUserId!);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class TheaterBookings extends _$TheaterBookings {
  @override
  Future<List<TheaterBooking>> build(String theaterId) async {
    final service = ref.watch(theaterBookingServiceProvider);
    return service.getTheaterBookings(theaterId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class BookingDetail extends _$BookingDetail {
  @override
  Future<TheaterBooking?> build(String bookingId) async {
    final service = ref.watch(theaterBookingServiceProvider);
    return service.getBookingById(bookingId);
  }

  Future<TheaterBooking> updateBookingStatus(String bookingId, String status) async {
    final service = ref.read(theaterBookingServiceProvider);
    final updatedBooking = await service.updateBookingStatus(bookingId, status);
    
    // Refresh related providers
    ref.invalidate(vendorBookingsProvider);
    ref.invalidate(bookingStatsProvider);
    ref.invalidate(todayBookingsProvider);
    ref.invalidate(upcomingBookingsProvider);
    ref.invalidateSelf();
    
    return updatedBooking;
  }

  Future<TheaterBooking> updatePaymentStatus(String bookingId, String paymentStatus) async {
    final service = ref.read(theaterBookingServiceProvider);
    final updatedBooking = await service.updatePaymentStatus(bookingId, paymentStatus);
    
    // Refresh related providers
    ref.invalidate(vendorBookingsProvider);
    ref.invalidate(bookingStatsProvider);
    ref.invalidate(todayBookingsProvider);
    ref.invalidate(upcomingBookingsProvider);
    ref.invalidateSelf();
    
    return updatedBooking;
  }
}

@riverpod
class FilteredBookings extends _$FilteredBookings {
  @override
  Future<List<TheaterBooking>> build(String status) async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor?.authUserId == null) return [];
    
    final service = ref.watch(theaterBookingServiceProvider);
    return service.getBookingsByStatus(vendor!.authUserId!, status);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class SearchedBookings extends _$SearchedBookings {
  @override
  Future<List<TheaterBooking>> build(String query) async {
    if (query.trim().isEmpty) return [];
    
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor?.authUserId == null) return [];
    
    final service = ref.watch(theaterBookingServiceProvider);
    return service.searchBookings(vendor!.authUserId!, query);
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.authUserId == null) return <TheaterBooking>[];
      
      final service = ref.read(theaterBookingServiceProvider);
      return service.searchBookings(vendor!.authUserId!, query);
    });
  }
}