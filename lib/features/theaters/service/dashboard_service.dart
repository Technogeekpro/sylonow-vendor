import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import '../models/dashboard_stats.dart';
import '../models/dashboard_order.dart';

final dashboardServiceProvider = Provider((ref) => DashboardService());

class DashboardService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<DashboardStats> getDashboardStats(String vendorId) async {
    try {
      print('🔵 DashboardService: Getting dashboard stats for vendor: $vendorId');
      
      final response = await _client
          .from('vendor_dashboard_stats')
          .select('*')
          .eq('vendor_id', vendorId)
          .single();
      
      print('🟢 DashboardService: Dashboard stats retrieved successfully');
      return DashboardStats.fromJson(response);
    } catch (e) {
      print('🔴 DashboardService: Error getting dashboard stats: $e');
      
      if (e is PostgrestException && e.code == 'PGRST116') {
        print('🟡 DashboardService: No stats found, returning empty stats');
        return DashboardStats(vendorId: vendorId);
      }
      
      rethrow;
    }
  }

  Future<List<DashboardOrder>> getPendingOrders(String vendorId) async {
    try {
      print('🔵 DashboardService: Getting pending orders for vendor: $vendorId');
      
      final response = await _client
          .from('vendor_pending_orders')
          .select('*')
          .eq('vendor_id', vendorId)
          .order('booking_date', ascending: true)
          .limit(10);
      
      print('🟢 DashboardService: Found ${response.length} pending orders');
      return response.map((json) => DashboardOrder.fromJson(json)).toList();
    } catch (e) {
      print('🔴 DashboardService: Error getting pending orders: $e');
      rethrow;
    }
  }

  Future<List<DashboardOrder>> getUpcomingOrders(String vendorId) async {
    try {
      print('🔵 DashboardService: Getting upcoming orders for vendor: $vendorId');
      
      final response = await _client
          .from('vendor_upcoming_orders')
          .select('*')
          .eq('vendor_id', vendorId)
          .limit(5);
      
      print('🟢 DashboardService: Found ${response.length} upcoming orders');
      return response.map((json) => DashboardOrder.fromJson(json)).toList();
    } catch (e) {
      print('🔴 DashboardService: Error getting upcoming orders: $e');
      rethrow;
    }
  }

  Future<OrderActionResult> acceptOrder(String orderId) async {
    try {
      print('🔵 DashboardService: Accepting order: $orderId');
      
      final response = await _client
          .from('orders')
          .update({
            'status': 'confirmed',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .select()
          .single();
      
      print('🟢 DashboardService: Order accepted successfully');
      
      return OrderActionResult(
        success: true,
        message: 'Order accepted successfully',
        updatedOrder: DashboardOrder.fromJson(response),
      );
    } catch (e) {
      print('🔴 DashboardService: Error accepting order: $e');
      return OrderActionResult(
        success: false,
        message: 'Failed to accept order: ${e.toString()}',
      );
    }
  }

  Future<OrderActionResult> rejectOrder(String orderId, {String? reason}) async {
    try {
      print('🔵 DashboardService: Rejecting order: $orderId');
      
      final updateData = {
        'status': 'rejected',
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (reason != null && reason.isNotEmpty) {
        updateData['rejection_reason'] = reason;
      }
      
      final response = await _client
          .from('orders')
          .update(updateData)
          .eq('id', orderId)
          .select()
          .single();
      
      print('🟢 DashboardService: Order rejected successfully');
      
      return OrderActionResult(
        success: true,
        message: 'Order rejected successfully',
        updatedOrder: DashboardOrder.fromJson(response),
      );
    } catch (e) {
      print('🔴 DashboardService: Error rejecting order: $e');
      return OrderActionResult(
        success: false,
        message: 'Failed to reject order: ${e.toString()}',
      );
    }
  }

  Future<DashboardOrder> getOrderDetails(String orderId) async {
    try {
      print('🔵 DashboardService: Getting order details: $orderId');
      
      final response = await _client
          .from('orders')
          .select('*')
          .eq('id', orderId)
          .single();
      
      print('🟢 DashboardService: Order details retrieved successfully');
      
      return DashboardOrder.fromJson(response);
    } catch (e) {
      print('🔴 DashboardService: Error getting order details: $e');
      rethrow;
    }
  }

  Future<bool> hasAnyTheaters(String vendorId) async {
    try {
      print('🔵 DashboardService: Checking if vendor has theaters: $vendorId');
      
      // First get the vendor's auth_user_id
      final vendorResponse = await _client
          .from('vendors')
          .select('auth_user_id')
          .eq('id', vendorId)
          .single();
          
      final authUserId = vendorResponse['auth_user_id'];
      if (authUserId == null) {
        print('🔴 DashboardService: No auth_user_id found for vendor: $vendorId');
        return false;
      }
      
      // Then check theaters using auth_user_id
      final response = await _client
          .from('private_theaters')
          .select('id')
          .eq('owner_id', authUserId)
          .limit(1);
      
      final hasTheaters = response.isNotEmpty;
      print('🟢 DashboardService: Vendor has theaters: $hasTheaters (auth_user_id: $authUserId)');
      
      return hasTheaters;
    } catch (e) {
      print('🔴 DashboardService: Error checking theaters: $e');
      return false;
    }
  }

  Stream<DashboardStats> watchDashboardStats(String vendorId) {
    return _client
        .from('vendor_dashboard_stats')
        .stream(primaryKey: ['vendor_id'])
        .eq('vendor_id', vendorId)
        .map((data) => data.isNotEmpty 
            ? DashboardStats.fromJson(data.first)
            : DashboardStats(vendorId: vendorId));
  }

  Stream<List<DashboardOrder>> watchPendingOrders(String vendorId) {
    return _client
        .from('vendor_pending_orders')
        .stream(primaryKey: ['id'])
        .eq('vendor_id', vendorId)
        .order('booking_date', ascending: true)
        .limit(10)
        .map((data) => data.map((json) => DashboardOrder.fromJson(json)).toList());
  }

  Stream<List<DashboardOrder>> watchUpcomingOrders(String vendorId) {
    return _client
        .from('vendor_upcoming_orders')
        .stream(primaryKey: ['id'])
        .eq('vendor_id', vendorId)
        .limit(5)
        .map((data) => data.map((json) => DashboardOrder.fromJson(json)).toList());
  }
}