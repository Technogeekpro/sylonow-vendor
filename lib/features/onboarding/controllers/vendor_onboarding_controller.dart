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
    // Clear any previous image first
    if (state.profileImage != null && state.profileImage!.path.contains('temp_images')) {
      try {
        state.profileImage!.deleteSync();
      } catch (e) {
        print('⚠️ Failed to delete old profile image: $e');
      }
    }
    state = state.copyWith(profileImage: image);
    print('📸 Profile image set: ${image.path}');
  }

  void setAadhaarFrontImage(File image) {
    // Clear any previous image first
    if (state.aadhaarFrontImage != null && state.aadhaarFrontImage!.path.contains('temp_images')) {
      try {
        state.aadhaarFrontImage!.deleteSync();
      } catch (e) {
        print('⚠️ Failed to delete old aadhaar front image: $e');
      }
    }
    state = state.copyWith(aadhaarFrontImage: image);
    print('📸 Aadhaar front image set: ${image.path}');
  }

  void setAadhaarBackImage(File image) {
    // Clear any previous image first
    if (state.aadhaarBackImage != null && state.aadhaarBackImage!.path.contains('temp_images')) {
      try {
        state.aadhaarBackImage!.deleteSync();
      } catch (e) {
        print('⚠️ Failed to delete old aadhaar back image: $e');
      }
    }
    state = state.copyWith(aadhaarBackImage: image);
    print('📸 Aadhaar back image set: ${image.path}');
  }

  void setPanCardImage(File image) {
    // Clear any previous image first
    if (state.panCardImage != null && state.panCardImage!.path.contains('temp_images')) {
      try {
        state.panCardImage!.deleteSync();
      } catch (e) {
        print('⚠️ Failed to delete old pan card image: $e');
      }
    }
    state = state.copyWith(panCardImage: image);
    print('📸 PAN card image set: ${image.path}');
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
      
      // Validate files exist before proceeding
      final filesToCheck = [
        ('profile', state.profileImage),
        ('aadhaar_front', state.aadhaarFrontImage),
        ('aadhaar_back', state.aadhaarBackImage),
        ('pan_card', state.panCardImage),
      ];
      
      for (final (type, file) in filesToCheck) {
        if (file != null) {
          print('🔵 Checking $type file: ${file.path}');
          if (!await file.exists()) {
            throw Exception('$type file not found at path: ${file.path}. Please re-select the image.');
          }
          print('🟢 $type file verified: ${file.path}');
        }
      }
      
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