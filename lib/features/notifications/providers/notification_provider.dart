import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../onboarding/providers/vendor_provider.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

part 'notification_provider.g.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

@riverpod
class NotificationList extends _$NotificationList {
  @override
  Future<List<VendorNotification>> build() async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor == null) return [];
    
    final notificationService = ref.read(notificationServiceProvider);
    return await notificationService.getNotifications(vendorId: vendor.id!);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor == null) return [];
      
      final notificationService = ref.read(notificationServiceProvider);
      return await notificationService.getNotifications(vendorId: vendor.id!);
    });
  }

  Future<void> markAsRead(String notificationId) async {
    final notificationService = ref.read(notificationServiceProvider);
    final success = await notificationService.markAsRead(notificationId: notificationId);
    
    if (success && state.hasValue) {
      // Update the local state immediately for better UX
      final updatedNotifications = state.value!.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();
      
      state = AsyncValue.data(updatedNotifications);
      
      // Also refresh the unread count
      ref.invalidate(unreadCountProvider);
    }
  }

  Future<void> markAllAsRead() async {
    final vendor = await ref.read(vendorProvider.future);
    if (vendor == null) return;
    
    final notificationService = ref.read(notificationServiceProvider);
    final success = await notificationService.markAllAsRead(vendorId: vendor.id!);
    
    if (success) {
      // Refresh the data
      refresh();
      ref.invalidate(unreadCountProvider);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final notificationService = ref.read(notificationServiceProvider);
    final success = await notificationService.deleteNotification(notificationId: notificationId);
    
    if (success && state.hasValue) {
      // Remove from local state immediately
      final updatedNotifications = state.value!.where((n) => n.id != notificationId).toList();
      state = AsyncValue.data(updatedNotifications);
      
      // Also refresh the unread count
      ref.invalidate(unreadCountProvider);
    }
  }
}

@riverpod
class UnreadCount extends _$UnreadCount {
  @override
  Future<int> build() async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor == null) return 0;
    
    final notificationService = ref.read(notificationServiceProvider);
    return await notificationService.getUnreadCount(vendorId: vendor.id!);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor == null) return 0;
      
      final notificationService = ref.read(notificationServiceProvider);
      return await notificationService.getUnreadCount(vendorId: vendor.id!);
    });
  }
}

@riverpod
class NotificationsByType extends _$NotificationsByType {
  @override
  Future<List<VendorNotification>> build(String type) async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor == null) return [];
    
    final notificationService = ref.read(notificationServiceProvider);
    return await notificationService.getNotificationsByType(
      vendorId: vendor.id!,
      type: type,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor == null) return [];
      
      final notificationService = ref.read(notificationServiceProvider);
      return await notificationService.getNotificationsByType(
        vendorId: vendor.id!,
        type: type,
      );
    });
  }
}

// Real-time stream provider for notifications
@riverpod
Stream<List<VendorNotification>> notificationStream(
  NotificationStreamRef ref,
) async* {
  final vendor = await ref.read(vendorProvider.future);
  if (vendor == null) {
    yield [];
    return;
  }
  
  final notificationService = ref.read(notificationServiceProvider);
  yield* notificationService.subscribeToNotifications(vendorId: vendor.id!);
}

// Helper provider to check if there are unread notifications
@riverpod
Future<bool> hasUnreadNotifications(HasUnreadNotificationsRef ref) async {
  final count = await ref.watch(unreadCountProvider.future);
  return count > 0;
}