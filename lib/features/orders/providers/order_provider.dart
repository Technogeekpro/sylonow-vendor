import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/providers/auth_provider.dart';
import 'package:sylonow_vendor/features/orders/models/order.dart';
import 'package:sylonow_vendor/features/orders/service/order_service.dart';

final ordersProvider = FutureProvider.family<List<Order>, String>((ref, status) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not authenticated');
  }

  print('🔵 OrderProvider: Fetching orders for status: $status');
  
  try {
    final orderService = ref.watch(orderServiceProvider);
    
    final filterStatus = status == 'All' ? null : status.toLowerCase();
    print('🔵 OrderProvider: Filter status: $filterStatus');

    final orders = await orderService.getVendorOrders(status: filterStatus);
    print('🟢 OrderProvider: Retrieved ${orders.length} orders');
    
    return orders;
  } catch (e, stackTrace) {
    print('🔴 OrderProvider: Error fetching orders: $e');
    print('🔴 OrderProvider: Stack trace: $stackTrace');
    rethrow;
  }
}); 