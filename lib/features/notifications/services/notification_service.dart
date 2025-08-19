import '../../../core/config/supabase_config.dart';
import '../models/notification.dart';

class NotificationService {
  static const String _tableName = 'vendor_notifications';

  Future<List<VendorNotification>> getNotifications({
    required String vendorId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      print('📱 Fetching notifications for vendor: $vendorId');
      
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('vendor_id', vendorId)
          .order('created_at', ascending: false)
          .limit(limit)
          .range(offset, offset + limit - 1);

      print('📱 Notifications query successful, found ${response.length} notifications');
      
      return response
          .map((json) => VendorNotification.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<List<VendorNotification>> getUnreadNotifications({
    required String vendorId,
  }) async {
    try {
      print('📱 Fetching unread notifications for vendor: $vendorId');
      
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('vendor_id', vendorId)
          .eq('is_read', false)
          .order('created_at', ascending: false);

      print('📱 Unread notifications query successful, found ${response.length} unread notifications');
      
      return response
          .map((json) => VendorNotification.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching unread notifications: $e');
      throw Exception('Failed to load unread notifications: $e');
    }
  }

  Future<int> getUnreadCount({required String vendorId}) async {
    try {
      print('📱 Getting unread count for vendor: $vendorId');
      
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select('id')
          .eq('vendor_id', vendorId)
          .eq('is_read', false);

      final count = response.length;
      print('📱 Unread count: $count');
      
      return count;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }

  Future<bool> markAsRead({required String notificationId}) async {
    try {
      print('📱 Marking notification as read: $notificationId');
      
      await SupabaseConfig.client
          .from(_tableName)
          .update({'is_read': true, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', notificationId);

      print('✅ Notification marked as read successfully');
      return true;
    } catch (e) {
      print('❌ Error marking notification as read: $e');
      return false;
    }
  }

  Future<bool> markAllAsRead({required String vendorId}) async {
    try {
      print('📱 Marking all notifications as read for vendor: $vendorId');
      
      await SupabaseConfig.client
          .from(_tableName)
          .update({'is_read': true, 'updated_at': DateTime.now().toIso8601String()})
          .eq('vendor_id', vendorId)
          .eq('is_read', false);

      print('✅ All notifications marked as read successfully');
      return true;
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
      return false;
    }
  }

  Future<bool> deleteNotification({required String notificationId}) async {
    try {
      print('📱 Deleting notification: $notificationId');
      
      await SupabaseConfig.client
          .from(_tableName)
          .delete()
          .eq('id', notificationId);

      print('✅ Notification deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting notification: $e');
      return false;
    }
  }

  Future<VendorNotification?> createNotification({
    required String vendorId,
    required String title,
    required String message,
    required String type,
    String? actionData,
    String? imageUrl,
  }) async {
    try {
      print('📱 Creating notification for vendor: $vendorId');
      print('📱 Notification type: $type, title: $title');
      
      final response = await SupabaseConfig.client
          .from(_tableName)
          .insert({
            'vendor_id': vendorId,
            'title': title,
            'message': message,
            'type': type,
            'action_data': actionData,
            'image_url': imageUrl,
            'is_read': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      print('✅ Notification created successfully');
      return VendorNotification.fromJson(response);
    } catch (e) {
      print('❌ Error creating notification: $e');
      return null;
    }
  }

  // Real-time subscription for new notifications
  Stream<List<VendorNotification>> subscribeToNotifications({
    required String vendorId,
  }) {
    print('📱 Setting up real-time subscription for vendor notifications: $vendorId');
    
    return SupabaseConfig.client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('vendor_id', vendorId)
        .order('created_at', ascending: false)
        .map((data) => data
            .map((json) => VendorNotification.fromJson(json))
            .toList());
  }

  // Get notifications by type
  Future<List<VendorNotification>> getNotificationsByType({
    required String vendorId,
    required String type,
    int limit = 20,
  }) async {
    try {
      print('📱 Fetching $type notifications for vendor: $vendorId');
      
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .eq('vendor_id', vendorId)
          .eq('type', type)
          .order('created_at', ascending: false)
          .limit(limit);

      print('📱 Found ${response.length} $type notifications');
      
      return response
          .map((json) => VendorNotification.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching $type notifications: $e');
      throw Exception('Failed to load $type notifications: $e');
    }
  }
}