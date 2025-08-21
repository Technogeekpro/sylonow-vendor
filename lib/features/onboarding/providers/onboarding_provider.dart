import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylonow_vendor/features/onboarding/providers/supabase_provider.dart';
import '../models/vendor.dart';
import '../service/onboarding_service.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return OnboardingService(supabase);
});

final onboardingProvider = AsyncNotifierProvider<OnboardingNotifier, Option<Vendor>>(() {
  return OnboardingNotifier();
});

class OnboardingNotifier extends AsyncNotifier<Option<Vendor>> {
  @override
  Future<Option<Vendor>> build() async {
    return none();
  }

  Future<Either<String, String>> signInWithMobile(String phoneNumber) async {
    final service = ref.read(onboardingServiceProvider);
    return service.signInWithMobile(phoneNumber);
  }

  Future<Either<String, AuthResponse>> verifyOTP(
    String phoneNumber,
    String otp,
  ) async {
    final service = ref.read(onboardingServiceProvider);
    return service.verifyOTP(phoneNumber, otp);
  }

  Future<Either<String, Vendor>> checkOrCreateVendor({
    required String phoneNumber,
    required String authUserId,
  }) async {
    state = const AsyncLoading();
    final service = ref.read(onboardingServiceProvider);

    final vendorExists = await service.checkVendorExists(phoneNumber);

    return vendorExists.fold(
      (_) async {
        // Create new vendor if not exists
        final createResult = await service.createVendor(
          mobileNumber: phoneNumber,
          fullName: '',  // Will be collected in vendor details screen
          authUserId: authUserId,
          serviceType: '',
          serviceArea: '',
          pincode: '',
          aadhaarNumber: '',
          bankAccountNumber: '',
          bankIfscCode: '',
        );

        return createResult.fold(
          (error) => left(error),
          (vendor) {
            state = AsyncData(some(vendor));
            return right(vendor);
          },
        );
      },
      (vendor) {
        // Vendor exists, update state and return
        state = AsyncData(some(vendor));
        return right(vendor);
      },
    );
  }

  Future<Either<String, void>> updateVendorDetails(
    String vendorId,
    Map<String, dynamic> data,
  ) async {
    state = const AsyncLoading();
    final service = ref.read(onboardingServiceProvider);

    final result = await service.updateVendorDetails(
      vendorId: vendorId,
      data: data,
    );

    return result.fold(
      (error) => left(error),
      (vendor) {
        state = AsyncData(some(vendor));
        return right(null);
      },
    );
  }

  Future<Either<String, String>> uploadDocument({
    required String path,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final service = ref.read(onboardingServiceProvider);
    return service.uploadDocument(
      path: path,
      bytes: bytes,
      fileName: fileName,
    );
  }
} 