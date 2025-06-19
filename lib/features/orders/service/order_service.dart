import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/config/supabase_config.dart';
import 'package:sylonow_vendor/features/orders/models/order.dart';

final orderServiceProvider = Provider((ref) => OrderService());

class OrderService {
  Future<List<Order>> getVendorOrders({
    String? status,
  }) async {
    final response = await SupabaseConfig.client.rpc(
      'get_vendor_orders',
      params: {
        'p_status': status,
      },
    );

    return (response as List)
        .map((data) => Order.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    await SupabaseConfig.client.rpc(
      'update_booking_status',
      params: {
        'p_booking_id': bookingId,
        'p_new_status': status,
      },
    );
  }
} 