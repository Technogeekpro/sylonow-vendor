import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/dashboard_stats.dart' as ds;
import '../models/dashboard_order.dart';
import '../service/dashboard_service.dart';
import '../../onboarding/providers/vendor_provider.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardStats extends _$DashboardStats {
  @override
  Future<ds.DashboardStats?> build() async {
    try {
      final vendor = await ref.watch(vendorProvider.future);
      if (vendor?.id == null) return null;

      final service = ref.read(dashboardServiceProvider);
      return await service.getDashboardStats(vendor!.id!);
    } catch (e) {
      print('🔴 DashboardStatsProvider: Error loading stats: $e');
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.id == null) return null;

      final service = ref.read(dashboardServiceProvider);
      return await service.getDashboardStats(vendor!.id!);
    });
  }
}

@riverpod
class PendingOrders extends _$PendingOrders {
  @override
  Future<List<DashboardOrder>> build() async {
    try {
      final vendor = await ref.watch(vendorProvider.future);
      if (vendor?.id == null) return [];

      final service = ref.read(dashboardServiceProvider);
      return await service.getPendingOrders(vendor!.id!);
    } catch (e) {
      print('🔴 PendingOrdersProvider: Error loading pending orders: $e');
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.id == null) return <DashboardOrder>[];

      final service = ref.read(dashboardServiceProvider);
      return await service.getPendingOrders(vendor!.id!);
    });
  }

  Future<OrderActionResult> acceptOrder(String orderId) async {
    try {
      final service = ref.read(dashboardServiceProvider);
      final result = await service.acceptOrder(orderId);
      
      if (result.success) {
        await refresh();
        ref.invalidate(dashboardStatsProvider);
      }
      
      return result;
    } catch (e) {
      return OrderActionResult(
        success: false,
        message: 'Failed to accept order: ${e.toString()}',
      );
    }
  }

  Future<OrderActionResult> rejectOrder(String orderId, {String? reason}) async {
    try {
      final service = ref.read(dashboardServiceProvider);
      final result = await service.rejectOrder(orderId, reason: reason);
      
      if (result.success) {
        await refresh();
        ref.invalidate(dashboardStatsProvider);
      }
      
      return result;
    } catch (e) {
      return OrderActionResult(
        success: false,
        message: 'Failed to reject order: ${e.toString()}',
      );
    }
  }
}

@riverpod
class UpcomingOrders extends _$UpcomingOrders {
  @override
  Future<List<DashboardOrder>> build() async {
    try {
      final vendor = await ref.watch(vendorProvider.future);
      if (vendor?.id == null) return [];

      final service = ref.read(dashboardServiceProvider);
      return await service.getUpcomingOrders(vendor!.id!);
    } catch (e) {
      print('🔴 UpcomingOrdersProvider: Error loading upcoming orders: $e');
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.id == null) return <DashboardOrder>[];

      final service = ref.read(dashboardServiceProvider);
      return await service.getUpcomingOrders(vendor!.id!);
    });
  }
}

@riverpod
class VendorHasTheaters extends _$VendorHasTheaters {
  @override
  Future<bool> build() async {
    try {
      final vendor = await ref.watch(vendorProvider.future);
      if (vendor?.id == null) return false;

      final service = ref.read(dashboardServiceProvider);
      return await service.hasAnyTheaters(vendor!.id!);
    } catch (e) {
      print('🔴 VendorHasTheatersProvider: Error checking theaters: $e');
      return false;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.id == null) return false;

      final service = ref.read(dashboardServiceProvider);
      return await service.hasAnyTheaters(vendor!.id!);
    });
  }
}

@riverpod
Future<DashboardOrder> orderDetails(OrderDetailsRef ref, String orderId) async {
  final service = ref.read(dashboardServiceProvider);
  return await service.getOrderDetails(orderId);
}