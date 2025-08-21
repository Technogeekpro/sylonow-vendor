import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/order.dart';
import '../service/order_service.dart';

part 'order_provider.g.dart';

@riverpod
class ServiceListingOrders extends _$ServiceListingOrders {
  @override
  Future<List<Order>> build(String serviceListingId) async {
    final orderService = ref.read(orderServiceProvider);
    return await orderService.getOrdersForServiceListing(serviceListingId);
  }

  Future<void> acceptOrder(String orderId) async {
    state = const AsyncValue.loading();
    try {
      final orderService = ref.read(orderServiceProvider);
      await orderService.acceptOrder(orderId);
      
      // Refresh the orders list
      final orders = await orderService.getOrdersForServiceListing(serviceListingId);
      state = AsyncValue.data(orders);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> rejectOrder(String orderId) async {
    state = const AsyncValue.loading();
    try {
      final orderService = ref.read(orderServiceProvider);
      await orderService.rejectOrder(orderId);
      
      // Refresh the orders list
      final orders = await orderService.getOrdersForServiceListing(serviceListingId);
      state = AsyncValue.data(orders);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final orderService = ref.read(orderServiceProvider);
      final orders = await orderService.getOrdersForServiceListing(serviceListingId);
      state = AsyncValue.data(orders);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

@riverpod
Future<Map<String, int>> serviceListingOrderCounts(ServiceListingOrderCountsRef ref, String serviceListingId) async {
  final orderService = ref.read(orderServiceProvider);
  return await orderService.getOrderStatusCounts(serviceListingId);
}