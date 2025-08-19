import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vendor_private_details.dart';
import '../services/vendor_private_details_service.dart';
import '../../onboarding/providers/vendor_provider.dart';

part 'vendor_private_details_provider.g.dart';

@riverpod
VendorPrivateDetailsService vendorPrivateDetailsService(Ref ref) {
  return VendorPrivateDetailsService();
}

// Provider for vendor private details
@riverpod
class VendorPrivateDetailsData extends _$VendorPrivateDetailsData {
  @override
  Future<VendorPrivateDetails?> build() async {
    // Get current vendor
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor?.id == null) return null;

    final service = ref.watch(vendorPrivateDetailsServiceProvider);
    return await service.getVendorPrivateDetails(vendor!.id!);
  }

  // Refresh private details
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.id == null) return null;

      final service = ref.read(vendorPrivateDetailsServiceProvider);
      return await service.getVendorPrivateDetails(vendor!.id!);
    });
  }

  // Update bank details
  Future<void> updateBankDetails({
    required String accountNumber,
    required String ifscCode,
  }) async {
    final vendor = await ref.read(vendorProvider.future);
    if (vendor?.id == null) throw Exception('Vendor not found');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(vendorPrivateDetailsServiceProvider);
      return await service.updateBankDetails(
        vendor!.id!,
        accountNumber: accountNumber,
        ifscCode: ifscCode,
      );
    });
  }

  // Update GST details
  Future<void> updateGstDetails({
    required String gstNumber,
  }) async {
    final vendor = await ref.read(vendorProvider.future);
    if (vendor?.id == null) throw Exception('Vendor not found');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(vendorPrivateDetailsServiceProvider);
      return await service.updateGstDetails(
        vendor!.id!,
        gstNumber: gstNumber,
      );
    });
  }

  // Update Aadhaar details
  Future<void> updateAadhaarDetails({
    required String aadhaarNumber,
  }) async {
    final vendor = await ref.read(vendorProvider.future);
    if (vendor?.id == null) throw Exception('Vendor not found');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(vendorPrivateDetailsServiceProvider);
      return await service.updateAadhaarDetails(
        vendor!.id!,
        aadhaarNumber: aadhaarNumber,
      );
    });
  }

  // Generic update method
  Future<void> updateDetails(Map<String, dynamic> updates) async {
    final vendor = await ref.read(vendorProvider.future);
    if (vendor?.id == null) throw Exception('Vendor not found');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(vendorPrivateDetailsServiceProvider);
      return await service.upsertVendorPrivateDetails(vendor!.id!, updates);
    });
  }
}

// Provider for bank details specifically
@riverpod
Future<Map<String, String>?> vendorBankDetails(Ref ref) async {
  final privateDetails = await ref.watch(vendorPrivateDetailsDataProvider.future);
  if (privateDetails == null || !privateDetails.hasBankDetails) return null;

  final service = ref.watch(vendorPrivateDetailsServiceProvider);
  return service.getBankDetailsSummary(privateDetails);
}

// Provider to check if bank details exist
@riverpod
Future<bool> hasBankDetails(Ref ref) async {
  final privateDetails = await ref.watch(vendorPrivateDetailsDataProvider.future);
  return privateDetails?.hasBankDetails ?? false;
}

// Provider to check if GST details exist
@riverpod
Future<bool> hasGstDetails(Ref ref) async {
  final privateDetails = await ref.watch(vendorPrivateDetailsDataProvider.future);
  return privateDetails?.hasGstDetails ?? false;
}

// Provider to check if Aadhaar details exist
@riverpod
Future<bool> hasAadhaarDetails(Ref ref) async {
  final privateDetails = await ref.watch(vendorPrivateDetailsDataProvider.future);
  return privateDetails?.hasAadhaarDetails ?? false;
}

// Provider for validation helpers
@riverpod
class ValidationHelper extends _$ValidationHelper {
  @override
  Map<String, bool Function(String)> build() {
    final service = ref.watch(vendorPrivateDetailsServiceProvider);
    
    return {
      'ifsc': service.isValidIfscCode,
      'account': service.isValidAccountNumber,
      'gst': (String gst) {
        final details = VendorPrivateDetails(gstNumber: gst);
        return details.isValidGst();
      },
      'aadhaar': (String aadhaar) {
        final details = VendorPrivateDetails(aadhaarNumber: aadhaar);
        return details.isValidAadhaar();
      },
    };
  }
}