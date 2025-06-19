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
  FutureOr<Vendor?> build() async {
    // Watch auth state changes to auto-refresh vendor data
    final currentUser = ref.watch(currentUserProvider);
    
    // If no user is authenticated, return null immediately
    if (currentUser == null) {
      return null;
    }

    print('🔵 VendorNotifier: Loading vendor data for user: ${currentUser.id}');
    
    try {
      final service = ref.read(vendorServiceProvider);
      final vendor = await service.getVendorByUserId(currentUser.id);
      
      if (vendor != null) {
        print('🟢 VendorNotifier: Vendor data loaded successfully');
      } else {
        print('🟡 VendorNotifier: No vendor data found for user');
      }
      
      return vendor;
    } catch (e) {
      print('🔴 VendorNotifier: Error loading vendor data: $e');
      rethrow;
    }
  }

  Future<void> refreshVendor() async {
    print('🔵 VendorNotifier: Manual refresh requested');
    state = const AsyncLoading();
    
    try {
      final vendor = await build();
      state = AsyncData(vendor);
      print('🟢 VendorNotifier: Manual refresh completed');
    } catch (e) {
      print('🔴 VendorNotifier: Manual refresh failed: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }

  void clearVendorData() {
    print('🔵 VendorNotifier: Clearing vendor data');
    state = const AsyncData(null);
  }
}