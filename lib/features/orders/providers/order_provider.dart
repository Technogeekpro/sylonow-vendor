import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/providers/auth_provider.dart';
import 'package:sylonow_vendor/features/orders/models/order.dart';
import 'package:sylonow_vendor/features/orders/service/order_service.dart';

final ordersProvider = FutureProvider.family<List<Order>, String>((ref, status) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not authenticated');
  }

  final orderService = ref.watch(orderServiceProvider);
  
  final filterStatus = status == 'All' ? null : status.toLowerCase();

  return orderService.getVendorOrders(
    status: filterStatus,
  );
}); 