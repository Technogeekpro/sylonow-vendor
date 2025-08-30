import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/config/supabase_config.dart';
import '../models/theater_booking.dart';


part 'theater_booking_service.g.dart';

@riverpod
TheaterBookingService theaterBookingService(TheaterBookingServiceRef ref) {
  return TheaterBookingService();
}

class TheaterBookingService {
  final _client = SupabaseConfig.client;

  // Helper method to get theater IDs for a vendor
  Future<List<String>> _getTheaterIdsForAuthUser(String authUserId) async {
    print('🔍 DEBUG: Looking up theaters for auth_user_id: $authUserId');
    
    // According to schema: private_theaters.owner_id references auth.users(id)
    // So we should find theaters directly by owner_id = authUserId
    final theaterResponse = await _client
        .from('private_theaters')
        .select('id, name, owner_id')
        .eq('owner_id', authUserId);
    
    print('🔍 DEBUG: Theater response for owner_id=$authUserId: $theaterResponse');
    print('🔍 DEBUG: Found ${theaterResponse.length} theaters');
    
    if (theaterResponse.isEmpty) {
      print('🔍 DEBUG: No theaters found for auth user: $authUserId');
      print('🔍 DEBUG: This means either:');
      print('🔍 DEBUG: 1. No theaters exist for this user');
      print('🔍 DEBUG: 2. Data inconsistency in private_theaters.owner_id');
      return [];
    }
    
    final theaterIds = theaterResponse.map<String>((t) => t['id'] as String).toList();
    print('🔍 DEBUG: Theater IDs found: $theaterIds');
    return theaterIds;
  }


  // Get all bookings for a vendor's theaters
  Future<List<TheaterBooking>> getVendorBookings(String authUserId) async {
    try {
      print('🔍 DEBUG: Fetching bookings for auth user: $authUserId');
      
      // Get theater IDs for this auth user
      final theaterIds = await _getTheaterIdsForAuthUser(authUserId);
      
      if (theaterIds.isEmpty) {
        return [];
      }
      
      print('🔍 DEBUG: About to query bookings with theater IDs: $theaterIds');
      
      final response = await _client
          .from('private_theater_bookings')
          .select('''
            *,
            private_theaters!inner(
              name,
              theater_screens(
                screen_name,
                screen_number
              )
            )
          ''')
          .inFilter('theater_id', theaterIds)
          .order('created_at', ascending: false);

      print('🔍 DEBUG: Vendor bookings response: $response');
      print('🔍 DEBUG: Response length: ${response.length}');
      print('🔍 DEBUG: Response type: ${response.runtimeType}');
      
      if (response.isNotEmpty) {
        print('🔍 DEBUG: First booking data: ${response[0]}');
      }

      if (response.isEmpty) {
        print('🔍 DEBUG: Response is empty, returning empty list');
        return [];
      }

      return response.map<TheaterBooking>((data) {
        // Process the booking data
        final flatData = Map<String, dynamic>.from(data);
        
        // Extract theater name and screen information
        if (data['private_theaters'] != null) {
          final theater = data['private_theaters'];
          flatData['theater_name'] = theater['name'];
          
          // Extract screen information from nested theater_screens
          if (theater['theater_screens'] != null && (theater['theater_screens'] as List).isNotEmpty) {
            final screen = (theater['theater_screens'] as List).first;
            flatData['screen_name'] = screen['screen_name'];
            flatData['screen_number'] = screen['screen_number'];
          }
        }
        
        // Process add-ons if they exist
        if (data['private_theater_booking_addons'] != null) {
          final addons = data['private_theater_booking_addons'] as List;
          flatData['selected_addons'] = addons.map((addon) => {
            'addon_id': addon['addon_id'],
            'addon_name': addon['add_ons']?['name'],
            'addon_description': addon['add_ons']?['description'],
            'addon_category': addon['add_ons']?['category'],
            'quantity': addon['quantity'],
            'unit_price': addon['unit_price'],
            'total_price': addon['total_price'],
          }).toList();
        }

        // Remove nested objects
        flatData.remove('private_theater_booking_addons');
        flatData.remove('private_theaters');
        
        return TheaterBooking.fromJson(flatData);
      }).toList();
    } catch (e) {
      print('🔴 ERROR: Failed to fetch vendor bookings: $e');
      rethrow;
    }
  }

  // Get bookings for a specific theater
  Future<List<TheaterBooking>> getTheaterBookings(String theaterId) async {
    try {
      print('🔍 DEBUG: Fetching bookings for theater: $theaterId');
      
      final response = await _client
          .from('private_theater_bookings')
          .select('''
            *,
            private_theater_booking_addons(
              id,
              addon_id,
              quantity,
              unit_price,
              total_price,
              add_ons(
                id,
                name,
                description,
                category,
                image_url
              )
            )
          ''')
          .eq('theater_id', theaterId)
          .order('booking_date', ascending: false);

      print('🔍 DEBUG: Theater bookings response: $response');

      if (response.isEmpty) {
        return [];
      }

      return response.map<TheaterBooking>((data) {
        // Process the booking data
        final flatData = Map<String, dynamic>.from(data);
        
        // Theater name and screen info will be fetched separately if needed
        // For now, we'll just use the theater_id to identify the theater
        
        // Process add-ons if they exist
        if (data['private_theater_booking_addons'] != null) {
          final addons = data['private_theater_booking_addons'] as List;
          flatData['selected_addons'] = addons.map((addon) => {
            'addon_id': addon['addon_id'],
            'addon_name': addon['add_ons']?['name'],
            'addon_description': addon['add_ons']?['description'],
            'addon_category': addon['add_ons']?['category'],
            'quantity': addon['quantity'],
            'unit_price': addon['unit_price'],
            'total_price': addon['total_price'],
          }).toList();
        }

        // Remove nested objects
        flatData.remove('private_theater_booking_addons');
        
        return TheaterBooking.fromJson(flatData);
      }).toList();
    } catch (e) {
      print('🔴 ERROR: Failed to fetch theater bookings: $e');
      rethrow;
    }
  }

  // Get booking by ID
  Future<TheaterBooking?> getBookingById(String bookingId) async {
    try {
      print('🔍 DEBUG: Fetching booking by ID: $bookingId');
      
      final response = await _client
          .from('private_theater_bookings')
          .select('''
            *,
            private_theater_booking_addons(
              id,
              addon_id,
              quantity,
              unit_price,
              total_price,
              add_ons(
                id,
                name,
                description,
                category,
                image_url
              )
            ),
            private_theaters!inner(
              name,
              theater_screens(
                images,
                screen_name,
                screen_number
              )
            )
          ''')
          .eq('id', bookingId)
          .maybeSingle();

      print('🔍 DEBUG: Booking by ID response: $response');

      if (response == null) {
        return null;
      }

      // Process the booking data
      final flatData = Map<String, dynamic>.from(response);
      
      // Process theater information
      if (response['private_theaters'] != null) {
        final theater = response['private_theaters'];
        flatData['theater_name'] = theater['name'];
        
        // Get screen images from theater_screens
        if (theater['theater_screens'] != null && (theater['theater_screens'] as List).isNotEmpty) {
          final screen = (theater['theater_screens'] as List).first;
          flatData['screen_name'] = screen['screen_name'];
          flatData['screen_number'] = screen['screen_number'];
          flatData['screen_images'] = screen['images'] ?? [];
        }
      }
      
      // Process add-ons if they exist
      if (response['private_theater_booking_addons'] != null) {
        final addons = response['private_theater_booking_addons'] as List;
        flatData['selected_addons'] = addons.map((addon) => {
          'addon_id': addon['addon_id'],
          'addon_name': addon['add_ons']?['name'],
          'addon_description': addon['add_ons']?['description'],
          'addon_category': addon['add_ons']?['category'],
          'quantity': addon['quantity'],
          'unit_price': addon['unit_price'],
          'total_price': addon['total_price'],
        }).toList();
      }

      // Remove nested objects
      flatData.remove('private_theater_booking_addons');
      flatData.remove('private_theaters');
      
      return TheaterBooking.fromJson(flatData);
    } catch (e) {
      print('🔴 ERROR: Failed to fetch booking by ID: $e');
      rethrow;
    }
  }

  // Update booking status
  Future<TheaterBooking> updateBookingStatus(String bookingId, String status) async {
    try {
      print('🔍 DEBUG: Updating booking status for $bookingId to $status');
      
      final response = await _client
          .from('private_theater_bookings')
          .update({'booking_status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', bookingId)
          .select('''
            *,
            private_theater_booking_addons(
              id,
              addon_id,
              quantity,
              unit_price,
              total_price,
              add_ons(
                id,
                name,
                description,
                category,
                image_url
              )
            )
          ''')
          .single();

      print('🔍 DEBUG: Updated booking response: $response');

      // Process the booking data
      final flatData = Map<String, dynamic>.from(response);
      
      // Process add-ons if they exist
      if (response['private_theater_booking_addons'] != null) {
        final addons = response['private_theater_booking_addons'] as List;
        flatData['selected_addons'] = addons.map((addon) => {
          'addon_id': addon['addon_id'],
          'addon_name': addon['add_ons']?['name'],
          'addon_description': addon['add_ons']?['description'],
          'addon_category': addon['add_ons']?['category'],
          'quantity': addon['quantity'],
          'unit_price': addon['unit_price'],
          'total_price': addon['total_price'],
        }).toList();
      }

      // Remove nested objects
      flatData.remove('private_theater_booking_addons');
      
      return TheaterBooking.fromJson(flatData);
    } catch (e) {
      print('🔴 ERROR: Failed to update booking status: $e');
      rethrow;
    }
  }

  // Update payment status
  Future<TheaterBooking> updatePaymentStatus(String bookingId, String paymentStatus) async {
    try {
      print('🔍 DEBUG: Updating payment status for $bookingId to $paymentStatus');
      
      final response = await _client
          .from('private_theater_bookings')
          .update({'payment_status': paymentStatus, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', bookingId)
          .select('''
            *,
            private_theater_booking_addons(
              id,
              addon_id,
              quantity,
              unit_price,
              total_price,
              add_ons(
                id,
                name,
                description,
                category,
                image_url
              )
            )
          ''')
          .single();

      print('🔍 DEBUG: Updated payment response: $response');

      // Process the booking data
      final flatData = Map<String, dynamic>.from(response);
      
      // Process add-ons if they exist
      if (response['private_theater_booking_addons'] != null) {
        final addons = response['private_theater_booking_addons'] as List;
        flatData['selected_addons'] = addons.map((addon) => {
          'addon_id': addon['addon_id'],
          'addon_name': addon['add_ons']?['name'],
          'addon_description': addon['add_ons']?['description'],
          'addon_category': addon['add_ons']?['category'],
          'quantity': addon['quantity'],
          'unit_price': addon['unit_price'],
          'total_price': addon['total_price'],
        }).toList();
      }

      // Remove nested objects
      flatData.remove('private_theater_booking_addons');
      
      return TheaterBooking.fromJson(flatData);
    } catch (e) {
      print('🔴 ERROR: Failed to update payment status: $e');
      rethrow;
    }
  }

  // Get booking statistics for vendor using the new view
  Future<Map<String, dynamic>> getBookingStats(String authUserId) async {
    try {
      print('🔍 DEBUG: Fetching booking stats for auth user: $authUserId');
      
      // Query the vendor_theater_stats view directly
      final response = await _client
          .from('vendor_theater_stats')
          .select('*')
          .eq('vendor_id', authUserId)
          .maybeSingle();
      
      print('🔍 DEBUG: Vendor stats response: $response');

      if (response == null) {
        print('🔍 DEBUG: No stats found for vendor, returning zero stats');
        return {
          'total_bookings': 0,
          'confirmed_bookings': 0,
          'cancelled_bookings': 0,
          'completed_bookings': 0,
          'total_revenue': 0.0,
          'gross_sales': 0.0,
          'pending_payments': 0,
          'today_bookings': 0,
          'upcoming_bookings': 0,
          'this_month_bookings': 0,
          'this_month_revenue': 0.0,
          'avg_booking_value': 0.0,
          'total_customers': 0,
          'total_theaters': 0,
        };
      }

      // Convert string numbers to proper types
      final stats = {
        'total_bookings': int.tryParse(response['total_bookings']?.toString() ?? '0') ?? 0,
        'confirmed_bookings': int.tryParse(response['confirmed_bookings']?.toString() ?? '0') ?? 0,
        'cancelled_bookings': int.tryParse(response['cancelled_bookings']?.toString() ?? '0') ?? 0,
        'completed_bookings': int.tryParse(response['completed_bookings']?.toString() ?? '0') ?? 0,
        'total_revenue': double.tryParse(response['total_revenue']?.toString() ?? '0') ?? 0.0,
        'gross_sales': double.tryParse(response['gross_sales']?.toString() ?? '0') ?? 0.0,
        'pending_payments': int.tryParse(response['pending_payments']?.toString() ?? '0') ?? 0,
        'today_bookings': int.tryParse(response['today_bookings']?.toString() ?? '0') ?? 0,
        'upcoming_bookings': int.tryParse(response['upcoming_bookings']?.toString() ?? '0') ?? 0,
        'this_month_bookings': int.tryParse(response['this_month_bookings']?.toString() ?? '0') ?? 0,
        'this_month_revenue': double.tryParse(response['this_month_revenue']?.toString() ?? '0') ?? 0.0,
        'avg_booking_value': double.tryParse(response['avg_booking_value']?.toString() ?? '0') ?? 0.0,
        'total_customers': int.tryParse(response['total_customers']?.toString() ?? '0') ?? 0,
        'total_theaters': response['total_theaters'] ?? 0,
      };
      
      print('🔍 DEBUG: Processed stats: $stats');
      return stats;
    } catch (e) {
      print('🔴 ERROR: Failed to fetch booking stats: $e');
      // Return default stats on error
      return {
        'total_bookings': 0,
        'confirmed_bookings': 0,
        'cancelled_bookings': 0,
        'completed_bookings': 0,
        'total_revenue': 0.0,
        'gross_sales': 0.0,
        'pending_payments': 0,
        'today_bookings': 0,
        'upcoming_bookings': 0,
        'this_month_bookings': 0,
        'this_month_revenue': 0.0,
        'avg_booking_value': 0.0,
        'total_customers': 0,
        'total_theaters': 0,
      };
    }
  }

  // Helper method to calculate booking statistics
  Map<String, dynamic> _calculateBookingStats(List<dynamic> bookings) {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    var totalBookings = 0;
    var confirmedBookings = 0;
    var cancelledBookings = 0;
    var completedBookings = 0;
    var totalRevenue = 0.0;
    var pendingPayments = 0;
    var todayBookings = 0;
    var upcomingBookings = 0;
    
    for (final booking in bookings) {
      totalBookings++;
      
      final status = booking['booking_status']?.toString().toLowerCase() ?? '';
      final paymentStatus = booking['payment_status']?.toString().toLowerCase() ?? '';
      final amount = booking['total_amount']?.toDouble() ?? 0.0;
      final bookingDate = booking['booking_date']?.toString() ?? '';
      
      // Count by booking status
      switch (status) {
        case 'confirmed':
          confirmedBookings++;
          break;
        case 'cancelled':
          cancelledBookings++;
          break;
        case 'completed':
          completedBookings++;
          break;
      }
      
      // Count revenue and pending payments
      if (paymentStatus == 'paid') {
        totalRevenue += amount;
      } else if (paymentStatus == 'pending') {
        pendingPayments++;
      }
      
      // Count today's bookings
      if (bookingDate.startsWith(todayStr)) {
        todayBookings++;
      }
      
      // Count upcoming bookings (confirmed bookings after today)
      if (status == 'confirmed' && bookingDate.compareTo(todayStr) >= 0) {
        upcomingBookings++;
      }
    }
    
    return {
      'total_bookings': totalBookings,
      'confirmed_bookings': confirmedBookings,
      'cancelled_bookings': cancelledBookings,
      'completed_bookings': completedBookings,
      'total_revenue': totalRevenue,
      'pending_payments': pendingPayments,
      'today_bookings': todayBookings,
      'upcoming_bookings': upcomingBookings,
    };
  }

  // Get today's bookings
  Future<List<TheaterBooking>> getTodayBookings(String authUserId) async {
    try {
      print('🔍 DEBUG: Fetching today bookings for auth user: $authUserId');
      
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      // Get theater IDs for this auth user
      final theaterIds = await _getTheaterIdsForAuthUser(authUserId);
      
      if (theaterIds.isEmpty) {
        return [];
      }
      
      final response = await _client
          .from('private_theater_bookings')
          .select('''
            *,
            private_theater_booking_addons(
              id,
              addon_id,
              quantity,
              unit_price,
              total_price,
              add_ons(
                id,
                name,
                description,
                category,
                image_url
              )
            )
          ''')
          .inFilter('theater_id', theaterIds)
          .eq('booking_date', today)
          .order('start_time', ascending: true);

      print('🔍 DEBUG: Today bookings response: $response');

      if (response.isEmpty) {
        return [];
      }

      return response.map<TheaterBooking>((data) {
        // Process the booking data
        final flatData = Map<String, dynamic>.from(data);
        
        // Theater name and screen info will be fetched separately if needed
        // For now, we'll just use the theater_id to identify the theater
        
        // Process add-ons if they exist
        if (data['private_theater_booking_addons'] != null) {
          final addons = data['private_theater_booking_addons'] as List;
          flatData['selected_addons'] = addons.map((addon) => {
            'addon_id': addon['addon_id'],
            'addon_name': addon['add_ons']?['name'],
            'addon_description': addon['add_ons']?['description'],
            'addon_category': addon['add_ons']?['category'],
            'quantity': addon['quantity'],
            'unit_price': addon['unit_price'],
            'total_price': addon['total_price'],
          }).toList();
        }

        // Remove nested objects
        flatData.remove('private_theater_booking_addons');
        
        return TheaterBooking.fromJson(flatData);
      }).toList();
    } catch (e) {
      print('🔴 ERROR: Failed to fetch today bookings: $e');
      rethrow;
    }
  }

  // Get upcoming bookings
  Future<List<TheaterBooking>> getUpcomingBookings(String authUserId) async {
    try {
      print('🔍 DEBUG: Fetching upcoming bookings for auth user: $authUserId');
      
      final today = DateTime.now().toIso8601String().split('T')[0];
      
      // Get theater IDs for this auth user
      final theaterIds = await _getTheaterIdsForAuthUser(authUserId);
      
      if (theaterIds.isEmpty) {
        return [];
      }
      
      final response = await _client
          .from('private_theater_bookings')
          .select('''
            *,
            private_theater_booking_addons(
              id,
              addon_id,
              quantity,
              unit_price,
              total_price,
              add_ons(
                id,
                name,
                description,
                category,
                image_url
              )
            )
          ''')
          .inFilter('theater_id', theaterIds)
          .gte('booking_date', today)
          .eq('booking_status', 'confirmed')
          .order('booking_date', ascending: true)
          .limit(10);

      print('🔍 DEBUG: Upcoming bookings response: $response');

      if (response.isEmpty) {
        return [];
      }

      return response.map<TheaterBooking>((data) {
        // Process the booking data
        final flatData = Map<String, dynamic>.from(data);
        
        // Theater name and screen info will be fetched separately if needed
        // For now, we'll just use the theater_id to identify the theater
        
        // Process add-ons if they exist
        if (data['private_theater_booking_addons'] != null) {
          final addons = data['private_theater_booking_addons'] as List;
          flatData['selected_addons'] = addons.map((addon) => {
            'addon_id': addon['addon_id'],
            'addon_name': addon['add_ons']?['name'],
            'addon_description': addon['add_ons']?['description'],
            'addon_category': addon['add_ons']?['category'],
            'quantity': addon['quantity'],
            'unit_price': addon['unit_price'],
            'total_price': addon['total_price'],
          }).toList();
        }

        // Remove nested objects
        flatData.remove('private_theater_booking_addons');
        
        return TheaterBooking.fromJson(flatData);
      }).toList();
    } catch (e) {
      print('🔴 ERROR: Failed to fetch upcoming bookings: $e');
      rethrow;
    }
  }

  // Filter bookings by status
  Future<List<TheaterBooking>> getBookingsByStatus(String authUserId, String status) async {
    try {
      print('🔍 DEBUG: Fetching bookings by status for auth user: $authUserId, status: $status');
      
      // Get theater IDs for this auth user
      final theaterIds = await _getTheaterIdsForAuthUser(authUserId);
      
      if (theaterIds.isEmpty) {
        print('🔍 DEBUG: No theaters found for auth user, returning empty list');
        return [];
      }
      
      print('🔍 DEBUG: Querying bookings for theater IDs: $theaterIds with status: $status');
      
      final response = await _client
          .from('private_theater_bookings')
          .select('''
            *,
            private_theater_booking_addons(
              id,
              addon_id,
              quantity,
              unit_price,
              total_price,
              add_ons(
                id,
                name,
                description,
                category,
                image_url
              )
            )
          ''')
          .inFilter('theater_id', theaterIds)
          .eq('booking_status', status)
          .order('created_at', ascending: false);

      print('🔍 DEBUG: Bookings by status response for status "$status": ${response.length} bookings found');
      print('🔍 DEBUG: Raw response: $response');

      if (response.isEmpty) {
        return [];
      }

      return response.map<TheaterBooking>((data) {
        // Process the booking data
        final flatData = Map<String, dynamic>.from(data);
        
        // Theater name and screen info will be fetched separately if needed
        // For now, we'll just use the theater_id to identify the theater
        
        // Process add-ons if they exist
        if (data['private_theater_booking_addons'] != null) {
          final addons = data['private_theater_booking_addons'] as List;
          flatData['selected_addons'] = addons.map((addon) => {
            'addon_id': addon['addon_id'],
            'addon_name': addon['add_ons']?['name'],
            'addon_description': addon['add_ons']?['description'],
            'addon_category': addon['add_ons']?['category'],
            'quantity': addon['quantity'],
            'unit_price': addon['unit_price'],
            'total_price': addon['total_price'],
          }).toList();
        }

        // Remove nested objects
        flatData.remove('private_theater_booking_addons');
        
        return TheaterBooking.fromJson(flatData);
      }).toList();
    } catch (e) {
      print('🔴 ERROR: Failed to fetch bookings by status: $e');
      rethrow;
    }
  }

  // Search bookings
  Future<List<TheaterBooking>> searchBookings(String authUserId, String query) async {
    try {
      print('🔍 DEBUG: Searching bookings for auth user: $authUserId, query: $query');
      
      // Get theater IDs for this auth user
      final theaterIds = await _getTheaterIdsForAuthUser(authUserId);
      
      if (theaterIds.isEmpty) {
        return [];
      }
      
      final response = await _client
          .from('private_theater_bookings')
          .select('''
            *,
            private_theater_booking_addons(
              id,
              addon_id,
              quantity,
              unit_price,
              total_price,
              add_ons(
                id,
                name,
                description,
                category,
                image_url
              )
            ) 
          ''')
          .inFilter('theater_id', theaterIds)
          .or('contact_name.ilike.%$query%,contact_phone.ilike.%$query%,celebration_name.ilike.%$query%')
          .order('created_at', ascending: false);

      print('🔍 DEBUG: Search bookings response: $response');

      if (response.isEmpty) {
        return [];
      }

      return response.map<TheaterBooking>((data) {
        // Process the booking data
        final flatData = Map<String, dynamic>.from(data);
        
        // Theater name and screen info will be fetched separately if needed
        // For now, we'll just use the theater_id to identify the theater
        
        // Process add-ons if they exist
        if (data['private_theater_booking_addons'] != null) {
          final addons = data['private_theater_booking_addons'] as List;
          flatData['selected_addons'] = addons.map((addon) => {
            'addon_id': addon['addon_id'],
            'addon_name': addon['add_ons']?['name'],
            'addon_description': addon['add_ons']?['description'],
            'addon_category': addon['add_ons']?['category'],
            'quantity': addon['quantity'],
            'unit_price': addon['unit_price'],
            'total_price': addon['total_price'],
          }).toList();
        }

        // Remove nested objects
        flatData.remove('private_theater_booking_addons');
        
        return TheaterBooking.fromJson(flatData);
      }).toList();
    } catch (e) {
      print('🔴 ERROR: Failed to search bookings: $e');
      rethrow;
    }
  }

  // Get screen images for a theater
  Future<List<String>> getScreenImages(String theaterId) async {
    try {
      print('🔍 DEBUG: Fetching screen images for theater: $theaterId');
      
      final response = await _client
          .from('theater_screens')
          .select('images')
          .eq('theater_id', theaterId)
          .maybeSingle();

      print('🔍 DEBUG: Screen images response: $response');

      if (response == null || response['images'] == null) {
        return [];
      }

      final images = response['images'] as List;
      return images.map<String>((img) => img.toString()).toList();
    } catch (e) {
      print('🔴 ERROR: Failed to fetch screen images: $e');
      return [];
    }
  }
}