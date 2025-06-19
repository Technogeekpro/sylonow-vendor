import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/config/supabase_config.dart';
import 'package:sylonow_vendor/core/providers/auth_provider.dart';
import 'package:sylonow_vendor/features/dashboard/models/dashboard_data.dart';

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not authenticated');
  }

  final response = await SupabaseConfig.client.rpc(
    'get_vendor_dashboard_stats',
    params: {'p_auth_user_id': user.id},
  );

  return DashboardData.fromJson(response as Map<String, dynamic>);
}); 