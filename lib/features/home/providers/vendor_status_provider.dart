import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/vendor_status_model.dart';
import '../service/vendor_status_service.dart';
import '../../../core/config/supabase_config.dart';

part 'vendor_status_provider.g.dart';

@riverpod
class VendorStatusNotifier extends _$VendorStatusNotifier {
  late final VendorStatusService _vendorStatusService;

  @override
  Future<VendorStatusModel?> build() async {
    _vendorStatusService = VendorStatusService();
    
    try {
      // Get current authenticated user
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) {
        print('No authenticated user found'); // Debug log
        return null;
      }

      print('Fetching vendor status for user: ${user.id}'); // Debug log
      
      // Get vendor status by auth user ID
      final vendorStatus = await _vendorStatusService.getVendorStatusByAuthId(user.id);
      
      if (vendorStatus != null) {
        print('Vendor status loaded: ${vendorStatus.verificationStatus}'); // Debug log
        // Update last login
        await _vendorStatusService.updateLastLogin(vendorStatus.vendorId);
      }
      
      return vendorStatus;
    } catch (e) {
      print('Error in VendorStatusNotifier.build(): $e'); // Debug log
      throw Exception('Failed to load vendor status: $e');
    }
  }

  Future<void> refreshStatus() async {
    state = const AsyncValue.loading();
    
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      print('Refreshing vendor status...'); // Debug log
      
      final vendorStatus = await _vendorStatusService.getVendorStatusByAuthId(user.id);
      
      if (vendorStatus != null) {
        print('Vendor status refreshed: ${vendorStatus.verificationStatus}'); // Debug log
      }
      
      state = AsyncValue.data(vendorStatus);
    } catch (e, stackTrace) {
      print('Error refreshing vendor status: $e'); // Debug log
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> logout() async {
    try {
      print('Logging out user...'); // Debug log
      
      // Sign out from Supabase
      await SupabaseConfig.client.auth.signOut();
      
      // Clear the state
      state = const AsyncValue.data(null);
      
      print('User logged out successfully'); // Debug log
    } catch (e, stackTrace) {
      print('Error during logout: $e'); // Debug log
      state = AsyncValue.error(e, stackTrace);
    }
  }

  bool get isVerified {
    final status = state.value;
    return status?.isVerified ?? false;
  }

  bool get isOnboardingComplete {
    final status = state.value;
    return status?.isOnboardingComplete ?? false;
  }

  String get verificationStatus {
    final status = state.value;
    return status?.verificationStatus ?? 'unknown';
  }
} 