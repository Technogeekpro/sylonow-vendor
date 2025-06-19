import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../service/vendor_service.dart';
import '../../../core/config/supabase_config.dart';

final vendorOnboardingControllerProvider = 
    StateNotifierProvider<VendorOnboardingController, VendorOnboardingState>((ref) {
  return VendorOnboardingController(ref);
});

class VendorOnboardingState {
  final bool isLoading;
  final String? errorMessage;
  final File? profileImage;
  final File? aadhaarFrontImage;
  final File? aadhaarBackImage;
  final File? panCardImage;

  const VendorOnboardingState({
    this.isLoading = false,
    this.errorMessage,
    this.profileImage,
    this.aadhaarFrontImage,
    this.aadhaarBackImage,
    this.panCardImage,
  });

  VendorOnboardingState copyWith({
    bool? isLoading,
    String? errorMessage,
    File? profileImage,
    File? aadhaarFrontImage,
    File? aadhaarBackImage,
    File? panCardImage,
  }) {
    return VendorOnboardingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      profileImage: profileImage ?? this.profileImage,
      aadhaarFrontImage: aadhaarFrontImage ?? this.aadhaarFrontImage,
      aadhaarBackImage: aadhaarBackImage ?? this.aadhaarBackImage,
      panCardImage: panCardImage ?? this.panCardImage,
    );
  }
}

class VendorOnboardingController extends StateNotifier<VendorOnboardingState> {
  final Ref ref;

  VendorOnboardingController(this.ref) : super(const VendorOnboardingState());

  void setProfileImage(File image) {
    state = state.copyWith(profileImage: image);
  }

  void setAadhaarFrontImage(File image) {
    state = state.copyWith(aadhaarFrontImage: image);
  }

  void setAadhaarBackImage(File image) {
    state = state.copyWith(aadhaarBackImage: image);
  }

  void setPanCardImage(File image) {
    state = state.copyWith(panCardImage: image);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> submitVendorApplication({
    required String fullName,
    required String serviceArea,
    required String pincode,
    required String serviceType,
    required String businessName,
    required String aadhaarNumber,
    required String bankAccountNumber,
    required String bankIfscCode,
    String? gstNumber,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated. Please login again.');
      }
      
      print('🔵 Starting vendor application submission for user: ${user.id}');
      final vendorService = ref.read(vendorServiceProvider);

      // Call the new transactional method in the service
      await vendorService.createVendorAndDocuments(
        // Vendor details
        fullName: fullName,
        authUserId: user.id,
        serviceArea: serviceArea,
        pincode: pincode,
        serviceType: serviceType,
        businessName: businessName,
        aadhaarNumber: aadhaarNumber,
        bankAccountNumber: bankAccountNumber,
        bankIfscCode: bankIfscCode,
        gstNumber: gstNumber,
        // Image files
        profileImageFile: state.profileImage,
        aadhaarFrontFile: state.aadhaarFrontImage,
        aadhaarBackFile: state.aadhaarBackImage,
        panCardFile: state.panCardImage,
      );

      print('🟢 Vendor application submitted successfully in controller!');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('🔴 Error submitting vendor application in controller: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to submit application. Please try again. Error: ${e.toString()}',
      );
      return false;
    }
  }
} 