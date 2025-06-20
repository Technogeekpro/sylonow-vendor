import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/providers/auth_provider.dart';
import 'package:sylonow_vendor/features/onboarding/models/vendor.dart';
import 'package:sylonow_vendor/features/onboarding/service/vendor_service.dart';

final vendorServiceProvider = Provider((ref) => VendorService());

final vendorProvider = AsyncNotifierProvider<VendorNotifier, Vendor?>(
  () => VendorNotifier(),
);

class VendorNotifier extends AsyncNotifier<Vendor?> {
  @override
  Future<Vendor?> build() async {
    try {
      final authState = ref.watch(authStateProvider);
      final user = authState.valueOrNull?.session?.user;
      
      if (user == null) {
        return null;
      }

      print('🔵 VendorNotifier: Loading vendor data for user: ${user.id.substring(0, 8)}...');
      
      final vendorService = ref.read(vendorServiceProvider);
      final vendor = await vendorService.getVendorByUserId(user.id);
      
      if (vendor != null) {
        print('🟢 VendorNotifier: Vendor loaded - Onboarding: ${vendor.isOnboardingComplete}, Verified: ${vendor.isVerified}');
      } else {
        print('🟡 VendorNotifier: No vendor data found for user');
      }
      
      return vendor;
    } catch (e, stackTrace) {
      print('🔴 VendorNotifier: Error loading vendor data: $e');
      rethrow;
    }
  }

  Future<void> refreshVendor() async {
    print('🔵 VendorNotifier: Manual refresh requested');
    
    // Don't set state to loading during refresh to avoid router triggers
    // Instead, fetch data in background and only update state with new data
    try {
      final authState = ref.watch(authStateProvider);
      final user = authState.valueOrNull?.session?.user;
      
      if (user == null) {
        print('🟡 VendorNotifier: No authenticated user found during refresh');
        return;
      }

      print('🔵 VendorNotifier: Refreshing vendor data for user: ${user.id.substring(0, 8)}...');
      
      final vendorService = ref.read(vendorServiceProvider);
      final vendor = await vendorService.getVendorByUserId(user.id);
      
      if (vendor != null) {
        print('🟢 VendorNotifier: Vendor refreshed - ID: ${vendor.id.substring(0, 8)}, Onboarding: ${vendor.isOnboardingComplete}, Verified: ${vendor.isVerified}');
        // Only update state if we got valid data
        state = AsyncData(vendor);
      } else {
        print('🟡 VendorNotifier: No vendor data found during refresh');
        // Only update to null if we currently have data (don't overwrite loading states)
        if (state.hasValue) {
          state = const AsyncData(null);
        }
      }
    } catch (e) {
      print('🔴 VendorNotifier: Manual refresh failed: $e');
      // Don't set error state during refresh, keep existing data
      // Only log the error for debugging
    }
  }

  void clearVendorData() {
    print('🔵 VendorNotifier: Clearing vendor data');
    state = const AsyncData(null);
  }

  /// Alternative refresh method using Riverpod's built-in invalidation
  /// This is safer as it uses the normal provider lifecycle
  Future<void> invalidateAndRefresh() async {
    print('🔵 VendorNotifier: Invalidating and refreshing...');
    ref.invalidateSelf();
  }
}