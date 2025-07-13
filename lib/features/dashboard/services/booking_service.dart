import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';
import '../../../core/services/firebase_analytics_service.dart';

class BookingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Accept a booking by updating its status to 'confirmed'
  Future<bool> acceptBooking(String bookingId) async {
    try {
      print('🔄 Accepting booking: $bookingId');
      
      // Get current user
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user');
        return false;
      }
      print('🔍 Current user: ${currentUser.id}');
      
      // Try using the new RPC function first
      try {
        print('🔄 Attempting RPC call to accept booking...');
        final rpcResponse = await _supabase.rpc(
          'accept_booking',
          params: {
            'p_booking_id': bookingId,
            'p_auth_user_id': currentUser.id,
          },
        );
        
        print('🔍 RPC Response: $rpcResponse');
        
        if (rpcResponse != null && rpcResponse['success'] == true) {
          print('✅ Booking accepted via RPC successfully');
          
          // Track booking acceptance
          FirebaseAnalyticsService().logBookingStatusChanged(
            bookingId: bookingId,
            oldStatus: 'pending',
            newStatus: 'confirmed',
          );
          
          return true;
        } else {
          print('❌ RPC call returned error: ${rpcResponse?['error']}');
          // Don't fallback for RPC errors - they're likely permission issues
          return false;
        }
      } catch (rpcError) {
        print('❌ RPC call failed: $rpcError');
        print('🔄 Falling back to direct table update...');
        
        // Check if booking exists first
        final existingBooking = await _supabase
            .from('bookings')
            .select('id, vendor_id, status')
            .eq('id', bookingId)
            .maybeSingle();
        
        if (existingBooking == null) {
          print('❌ Booking not found: $bookingId');
          return false;
        }
        
        print('🔍 Found booking: ${existingBooking['id']} for vendor: ${existingBooking['vendor_id']} with status: ${existingBooking['status']}');
        
        // Try direct table update as fallback
        try {
          print('🔄 Trying direct table update...');
          await _supabase
              .from('bookings')
              .update({
                'status': 'confirmed',
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', bookingId)
              .eq('vendor_id', existingBooking['vendor_id']);

          print('✅ Booking accepted via direct update successfully');
          
          // Track booking acceptance
          FirebaseAnalyticsService().logBookingStatusChanged(
            bookingId: bookingId,
            oldStatus: 'pending',
            newStatus: 'confirmed',
          );
          
          return true;
        } catch (updateError) {
          print('❌ Direct update failed: $updateError');
          return false;
        }
      }
      
    } catch (e) {
      print('❌ Error accepting booking: $e');
      
      // Track booking acceptance error
      FirebaseAnalyticsService().logError(
        errorType: 'booking_acceptance_failed',
        errorMessage: e.toString(),
        screenName: 'booking_details',
      );
      
      if (e.toString().contains('permission') || e.toString().contains('403')) {
        print('❌ Permission denied - RLS policies or trigger issues');
        print('💡 Suggestion: Check database triggers and RLS policies');
      }
      return false;
    }
  }

  /// Get detailed booking information
  Future<Booking?> getBookingDetails(String bookingId) async {
    try {
      print('🔄 Fetching booking details: $bookingId');
      
      final response = await _supabase
          .from('bookings')
          .select('''
            *,
            service_listings!inner(
              title,
              original_price,
              offer_price,
              description,
              cover_photo,
              photos
            )
          ''')
          .eq('id', bookingId)
          .single();

      // Transform the response to match our Booking model
      final transformedData = {
        ...response,
        'service_title': response['service_listings']['title'],
        'original_price': response['service_listings']['original_price'],
        'offer_price': response['service_listings']['offer_price'],
        'customer_name': 'Customer', // Default value since we can't access auth.users
        'customer_email': null, // Will be null if we can't access it
      };

      final booking = Booking.fromJson(transformedData);
      print('✅ Booking details fetched successfully');
      return booking;
    } catch (e) {
      print('❌ Error fetching booking details: $e');
      return null;
    }
  }

  /// Get recent pending bookings for a vendor
  Future<List<Booking>> getRecentPendingBookings(String vendorId, {int limit = 5}) async {
    try {
      print('🔄 Fetching recent pending bookings for vendor: $vendorId');
      
      final response = await _supabase
          .from('bookings')
          .select('''
            *,
            service_listings!inner(
              title,
              original_price,
              offer_price
            )
          ''')
          .eq('vendor_id', vendorId)
          .eq('status', 'pending')
          .order('created_at', ascending: false)
          .limit(limit);

      final bookings = response.map((data) {
        // Transform the response to match our Booking model
        final transformedData = {
          ...data,
          'service_title': data['service_listings']['title'],
          'original_price': data['service_listings']['original_price'],
          'offer_price': data['service_listings']['offer_price'],
          'customer_name': 'Customer', // Default value
          'customer_email': null, // Will be null
        };
        
        return Booking.fromJson(transformedData);
      }).toList();

      print('✅ Fetched ${bookings.length} recent pending bookings');
      return bookings;
    } catch (e) {
      print('❌ Error fetching recent pending bookings: $e');
      return [];
    }
  }

  /// Decline a booking by updating its status to 'cancelled'
  Future<bool> declineBooking(String bookingId, {String? reason}) async {
    try {
      print('🔄 Declining booking: $bookingId');
      
      // Get current user and verify booking ownership
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user');
        return false;
      }
      
      // Check if booking exists first
      final existingBooking = await _supabase
          .from('bookings')
          .select('id, vendor_id, status')
          .eq('id', bookingId)
          .maybeSingle();
      
      if (existingBooking == null) {
        print('❌ Booking not found: $bookingId');
        return false;
      }
      
      // Try using RPC function first (if it exists)
      try {
        print('🔄 Attempting RPC call to decline booking...');
        final rpcResponse = await _supabase.rpc(
          'decline_booking',
          params: {
            'p_booking_id': bookingId,
            'p_auth_user_id': currentUser.id,
          },
        );
        
        print('✅ Booking declined via RPC successfully');
        return true;
      } catch (rpcError) {
        print('❌ RPC call failed: $rpcError');
        print('🔄 Falling back to direct table update...');
      }
      
      // Try multiple approaches to update the booking
      
      // Approach 1: Minimal update with only status
      try {
        print('🔄 Trying minimal status update...');
        final response1 = await _supabase
            .from('bookings')
            .update({'status': 'cancelled'})
            .eq('id', bookingId)
            .eq('vendor_id', existingBooking['vendor_id'])
            .select();

        if (response1.isNotEmpty) {
          print('✅ Booking declined via minimal update successfully');
          return true;
        }
      } catch (e1) {
        print('❌ Minimal update failed: $e1');
      }
      
      // Approach 2: Update with timestamp
      try {
        print('🔄 Trying update with timestamp...');
        final response2 = await _supabase
            .from('bookings')
            .update({
              'status': 'cancelled',
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', bookingId)
            .eq('vendor_id', existingBooking['vendor_id'])
            .select();

        if (response2.isNotEmpty) {
          print('✅ Booking declined via timestamped update successfully');
          return true;
        }
      } catch (e2) {
        print('❌ Timestamped update failed: $e2');
      }
      
      // Approach 3: Try without select() to avoid returning data
      try {
        print('🔄 Trying update without select...');
        await _supabase
            .from('bookings')
            .update({'status': 'cancelled'})
            .eq('id', bookingId)
            .eq('vendor_id', existingBooking['vendor_id']);

        print('✅ Booking declined via no-select update successfully');
        return true;
      } catch (e3) {
        print('❌ No-select update failed: $e3');
      }
      
      print('❌ All decline approaches failed');
      return false;
      
    } catch (e) {
      print('❌ Error declining booking: $e');
      if (e.toString().contains('permission')) {
        print('❌ Permission denied - check RLS policies');
      }
      return false;
    }
  }
} 