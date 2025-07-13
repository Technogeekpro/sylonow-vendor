import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../models/dashboard_stats.dart';
import '../../service_listings/providers/service_listing_provider.dart';

final dashboardStatsProvider = AsyncNotifierProvider<DashboardStatsNotifier, DashboardStats>(
  () => DashboardStatsNotifier(),
);

class DashboardStatsNotifier extends AsyncNotifier<DashboardStats> {
  @override
  FutureOr<DashboardStats> build() async {
    // Watch auth state changes to refresh dashboard when user changes
    final currentUser = ref.watch(currentUserProvider);
    
    // If no user is authenticated, return initial stats
    if (currentUser == null) {
      return DashboardStats.initial();
    }

    print('🔵 DashboardStatsNotifier: Loading dashboard stats for user: ${currentUser.id}');
    
    try {
      // Get actual service listings count
      final serviceListingsAsync = ref.watch(serviceListingsProvider);
      final serviceListingsCount = serviceListingsAsync.when(
        data: (listings) => listings.length,
        loading: () => 0,
        error: (_, __) => 0,
      );
      
      // For now, return stats with real service listings count
      // TODO: Replace with actual API call for other dashboard statistics
      final stats = DashboardStats(
        grossSales: 0.0, // TODO: Get from API
        earnings: 0.0, // TODO: Get from API  
        totalServiceListings: serviceListingsCount,
        totalOrders: 0, // TODO: Get from API
        lastUpdated: DateTime.now(),
      );
      
      print('🟢 DashboardStatsNotifier: Dashboard stats loaded successfully');
      print('🔵 DashboardStatsNotifier: Service listings count: $serviceListingsCount');
      return stats;
    } catch (e) {
      print('🔴 DashboardStatsNotifier: Error loading dashboard stats: $e');
      // Return initial stats on error instead of throwing
      return DashboardStats.initial();
    }
  }

  // TODO: Replace this with actual API call
  Future<DashboardStats> _fetchDashboardStats(String userId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // For now, return initial stats (all zeros)
    // In the future, this will make an API call to fetch real data
    return DashboardStats.initial();
    
    // Example of what this might look like with real API:
    /*
    try {
      final response = await SupabaseConfig.client
          .from('vendor_dashboard_stats')
          .select('*')
          .eq('vendor_id', userId)
          .single();
      
      return DashboardStats.fromJson(response);
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return DashboardStats.initial();
    }
    */
  }

  // Method to refresh dashboard stats manually
  Future<void> refreshStats() async {
    print('🔵 DashboardStatsNotifier: Manual refresh requested');
    state = const AsyncLoading();
    
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        state = AsyncData(DashboardStats.initial());
        return;
      }
      
      final stats = await _fetchDashboardStats(currentUser.id);
      state = AsyncData(stats);
      print('🟢 DashboardStatsNotifier: Manual refresh completed');
    } catch (e) {
      print('🔴 DashboardStatsNotifier: Manual refresh failed: $e');
      state = AsyncData(DashboardStats.initial());
    }
  }

  // Method to update specific stats (for real-time updates)
  void updateStats({
    double? grossSales,
    double? earnings,
    int? totalServiceListings,
    int? totalOrders,
  }) {
    state.whenData((currentStats) {
      final updatedStats = currentStats.copyWith(
        grossSales: grossSales,
        earnings: earnings,
        totalServiceListings: totalServiceListings,
        totalOrders: totalOrders,
        lastUpdated: DateTime.now(),
      );
      state = AsyncData(updatedStats);
      print('🟢 DashboardStatsNotifier: Stats updated');
    });
  }

  // Clear stats (for logout)
  void clearStats() {
    print('🔵 DashboardStatsNotifier: Clearing dashboard stats');
    state = AsyncData(DashboardStats.initial());
  }
} 