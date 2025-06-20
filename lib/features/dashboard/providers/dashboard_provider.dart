import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/config/supabase_config.dart';
import 'package:sylonow_vendor/core/providers/auth_provider.dart';
import 'package:sylonow_vendor/features/dashboard/models/dashboard_data.dart';
import 'package:sylonow_vendor/features/dashboard/models/activity_item.dart';
import '../services/recent_activity_service.dart';
import '../../onboarding/providers/vendor_provider.dart';

final recentActivityServiceProvider = Provider<RecentActivityService>((ref) {
  return RecentActivityService();
});

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not authenticated');
  }

  // Get dashboard stats from RPC
  final response = await SupabaseConfig.client.rpc(
    'get_vendor_dashboard_stats',
    params: {'p_auth_user_id': user.id},
  );

  final dashboardData = DashboardData.fromJson(response as Map<String, dynamic>);

  // Get vendor info to fetch recent activities
  final vendorAsync = ref.watch(vendorProvider);
  final recentActivities = await vendorAsync.when(
    data: (vendor) async {
      if (vendor?.id != null) {
        final activityService = ref.read(recentActivityServiceProvider);
        return await activityService.getRecentActivities(vendor!.id);
      }
      return <ActivityItem>[];
    },
    loading: () async => <ActivityItem>[],
    error: (_, __) async => <ActivityItem>[],
  );

  // Return dashboard data with recent activities
  return dashboardData.copyWith(recentActivities: recentActivities);
}); 