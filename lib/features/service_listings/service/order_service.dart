import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/supabase_config.dart';
import '../models/order.dart';

final orderServiceProvider = Provider((ref) => OrderService());

class OrderService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Get orders for a specific service listing
  Future<List<Order>> getOrdersForServiceListing(String serviceListingId) async {
    try {
      print('🔵 OrderService: Getting orders for service listing: $serviceListingId');
      
      final response = await _client
          .from('orders')
          .select('*')
          .eq('service_listing_id', serviceListingId)
          .order('created_at', ascending: false);
      
      print('🔵 OrderService: Found ${response.length} orders');
      
      return response.map((json) {
        // Handle null values that could cause type cast errors
        final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);
        
        // Ensure required fields have fallback values
        safeJson['customer_name'] ??= 'Unknown Customer';
        safeJson['service_title'] ??= 'Unknown Service';
        safeJson['total_amount'] ??= 0.0;
        safeJson['status'] ??= 'pending';
        safeJson['payment_status'] ??= 'pending';
        
        // Handle datetime fields
        if (safeJson['booking_date'] != null) {
          safeJson['booking_date'] = DateTime.parse(safeJson['booking_date']);
        } else {
          safeJson['booking_date'] = DateTime.now();
        }
        
        if (safeJson['created_at'] != null) {
          safeJson['created_at'] = DateTime.parse(safeJson['created_at']);
        }
        
        if (safeJson['updated_at'] != null) {
          safeJson['updated_at'] = DateTime.parse(safeJson['updated_at']);
        }
        
        return Order.fromJson(safeJson);
      }).toList();
    } catch (e) {
      print('🔴 OrderService: Error getting orders: $e');
      if (e is PostgrestException) {
        print('🔴 OrderService: Postgrest error details: ${e.details}');
        print('🔴 OrderService: Postgrest error message: ${e.message}');
      }
      rethrow;
    }
  }

  // Accept an order
  Future<Order> acceptOrder(String orderId) async {
    try {
      print('🔵 OrderService: Accepting order: $orderId');
      
      final response = await _client
          .from('orders')
          .update({'status': 'confirmed', 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', orderId)
          .select()
          .single();
      
      print('🟢 OrderService: Order accepted successfully');
      
      // Handle datetime fields in response
      final Map<String, dynamic> safeJson = Map<String, dynamic>.from(response);
      if (safeJson['booking_date'] != null) {
        safeJson['booking_date'] = DateTime.parse(safeJson['booking_date']);
      }
      if (safeJson['created_at'] != null) {
        safeJson['created_at'] = DateTime.parse(safeJson['created_at']);
      }
      if (safeJson['updated_at'] != null) {
        safeJson['updated_at'] = DateTime.parse(safeJson['updated_at']);
      }
      
      return Order.fromJson(safeJson);
    } catch (e) {
      print('🔴 OrderService: Error accepting order: $e');
      rethrow;
    }
  }

  // Reject an order
  Future<Order> rejectOrder(String orderId) async {
    try {
      print('🔵 OrderService: Rejecting order: $orderId');
      
      final response = await _client
          .from('orders')
          .update({'status': 'rejected', 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', orderId)
          .select()
          .single();
      
      print('🟢 OrderService: Order rejected successfully');
      
      // Handle datetime fields in response
      final Map<String, dynamic> safeJson = Map<String, dynamic>.from(response);
      if (safeJson['booking_date'] != null) {
        safeJson['booking_date'] = DateTime.parse(safeJson['booking_date']);
      }
      if (safeJson['created_at'] != null) {
        safeJson['created_at'] = DateTime.parse(safeJson['created_at']);
      }
      if (safeJson['updated_at'] != null) {
        safeJson['updated_at'] = DateTime.parse(safeJson['updated_at']);
      }
      
      return Order.fromJson(safeJson);
    } catch (e) {
      print('🔴 OrderService: Error rejecting order: $e');
      rethrow;
    }
  }

  // Get order counts by status for a service listing
  Future<Map<String, int>> getOrderStatusCounts(String serviceListingId) async {
    try {
      print('🔵 OrderService: Getting order status counts for service listing: $serviceListingId');
      
      final response = await _client
          .from('orders')
          .select('status')
          .eq('service_listing_id', serviceListingId);
      
      final Map<String, int> counts = {
        'pending': 0,
        'confirmed': 0,
        'rejected': 0,
        'completed': 0,
      };
      
      for (final order in response) {
        final status = order['status'] as String? ?? 'pending';
        counts[status] = (counts[status] ?? 0) + 1;
      }
      
      print('🟢 OrderService: Order status counts: $counts');
      return counts;
    } catch (e) {
      print('🔴 OrderService: Error getting order status counts: $e');
      rethrow;
    }
  }
}