import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/config/supabase_config.dart';
import 'package:sylonow_vendor/features/orders/models/order.dart';

final orderServiceProvider = Provider((ref) => OrderService());

class OrderService {
  Future<List<Order>> getVendorOrders({
    String? status,
  }) async {
    try {
      print('🔵 OrderService: Calling get_vendor_orders RPC with status: $status');
      
      final response = await SupabaseConfig.client.rpc(
        'get_vendor_orders_enhanced',
        params: {
          'p_status': status,
        },
      );

      print('🟢 OrderService: RPC response received');
      print('🔵 OrderService: Response type: ${response.runtimeType}');
      print('🔵 OrderService: Response data: $response');

      if (response == null) {
        print('🟡 OrderService: Empty response from RPC');
        return [];
      }

      final List<Order> orders = (response as List)
          .map((data) {
            print('🔵 OrderService: Processing order data: $data');
            return Order.fromJson(data as Map<String, dynamic>);
          })
          .toList();

      print('🟢 OrderService: Successfully parsed ${orders.length} orders');
      return orders;
    } catch (e, stackTrace) {
      print('🔴 OrderService: Error in getVendorOrders: $e');
      print('🔴 OrderService: Stack trace: $stackTrace');
      
      // Re-throw with more context
      if (e.toString().contains('not found for authenticated user')) {
        throw Exception('No vendor profile found. Please complete vendor onboarding first.');
      }
      
      throw Exception('Failed to fetch orders: ${e.toString()}');
    }
  }

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      print('🔵 OrderService: Updating booking $bookingId to status: $status');
      
      await SupabaseConfig.client.rpc(
        'update_booking_status',
        params: {
          'p_booking_id': bookingId,
          'p_new_status': status,
        },
      );
      
      print('🟢 OrderService: Successfully updated booking status');
    } catch (e, stackTrace) {
      print('🔴 OrderService: Error updating booking status: $e');
      print('🔴 OrderService: Stack trace: $stackTrace');
      
      // Provide more user-friendly error messages
      if (e.toString().contains('Permission denied')) {
        throw Exception('You do not have permission to update this order.');
      } else if (e.toString().contains('Invalid status')) {
        throw Exception('Invalid status transition. Please check the order status.');
      } else if (e.toString().contains('not found')) {
        throw Exception('Order not found or already updated.');
      }
      
      throw Exception('Failed to update order status: ${e.toString()}');
    }
  }
} 