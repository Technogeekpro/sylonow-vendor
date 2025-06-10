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
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Enhanced authentication validation for release builds
      final user = SupabaseConfig.client.auth.currentUser;
      final session = SupabaseConfig.client.auth.currentSession;
      
      print('🔵 Pre-upload authentication check:');
      print('   - User ID: ${user?.id ?? 'null'}');
      print('   - User email: ${user?.email ?? user?.phone ?? 'no email/phone'}');
      print('   - Session present: ${session != null}');
      print('   - Session expired: ${session?.isExpired ?? 'unknown'}');
      
      if (user == null) {
        throw Exception('User not authenticated. Please login again.');
      }
      
      if (session == null) {
        throw Exception('Authentication session not found. Please login again.');
      }
      
      if (session.isExpired) {
        print('🔵 Session expired, refreshing...');
        try {
          await SupabaseConfig.client.auth.refreshSession();
          print('🟢 Session refreshed successfully');
        } catch (refreshError) {
          print('🔴 Session refresh failed: $refreshError');
          throw Exception('Authentication expired. Please logout and login again.');
        }
      }

      print('🔵 Starting vendor application submission...');
      final vendorService = ref.read(vendorServiceProvider);

      // Upload images first with proper type names
      String? profileImageUrl;
      String? aadhaarFrontUrl;
      String? aadhaarBackUrl;
      String? panCardUrl;

      print('🔵 Uploading images...');

      if (state.profileImage != null) {
        print('🔵 Uploading profile picture...');
        profileImageUrl = await vendorService.uploadImage(
          state.profileImage!, 
          'profile', // This will use profile-pictures bucket
        );
        print('🟢 Profile picture uploaded: $profileImageUrl');
      }

      if (state.aadhaarFrontImage != null) {
        print('🔵 Uploading Aadhaar front image...');
        aadhaarFrontUrl = await vendorService.uploadImage(
          state.aadhaarFrontImage!, 
          'aadhaar', // This will use vendor-documents bucket
        );
        print('🟢 Aadhaar front uploaded: $aadhaarFrontUrl');
      }

      if (state.aadhaarBackImage != null) {
        print('🔵 Uploading Aadhaar back image...');
        aadhaarBackUrl = await vendorService.uploadImage(
          state.aadhaarBackImage!, 
          'aadhaar', // This will use vendor-documents bucket
        );
        print('🟢 Aadhaar back uploaded: $aadhaarBackUrl');
      }

      if (state.panCardImage != null) {
        print('🔵 Uploading PAN card image...');
        panCardUrl = await vendorService.uploadImage(
          state.panCardImage!, 
          'pan', // This will use vendor-documents bucket
        );
        print('🟢 PAN card uploaded: $panCardUrl');
      }

      print('🔵 All images uploaded successfully, creating vendor record...');

      // Create vendor record
      final userPhone = user.phone?.trim() ?? '';
      print('🔵 User phone from auth: "$userPhone"');
      
      await vendorService.createVendor(
        mobileNumber: userPhone,
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
        profilePicture: profileImageUrl,
        aadhaarFrontImage: aadhaarFrontUrl,
        aadhaarBackImage: aadhaarBackUrl,
        panCardImage: panCardUrl,
      );

      print('🟢 Vendor application submitted successfully!');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('🔴 Error submitting vendor application: $e');
      
      // Add detailed error logging for release build debugging
      if (e.toString().contains('SocketException')) {
        print('🔴 Network Error: Unable to connect to server');
        print('🔴 This could be due to:');
        print('🔴 1. No internet connection');
        print('🔴 2. Server is down');
        print('🔴 3. Network security policy blocking HTTPS');
        print('🔴 4. DNS resolution failure');
      } else if (e.toString().contains('HttpException')) {
        print('🔴 HTTP Error: Server responded with error');
        print('🔴 This could be due to:');
        print('🔴 1. Authentication token expired');
        print('🔴 2. API endpoint not found');
        print('🔴 3. Server configuration issue');
      } else if (e.toString().contains('FormatException')) {
        print('🔴 Data Format Error: Invalid response from server');
        print('🔴 This could be due to:');
        print('🔴 1. Server returned unexpected data format');
        print('🔴 2. JSON parsing error');
        print('🔴 3. API version mismatch');
      } else if (e.toString().contains('TimeoutException')) {
        print('🔴 Timeout Error: Request took too long');
        print('🔴 This could be due to:');
        print('🔴 1. Slow internet connection');
        print('🔴 2. Server overloaded');
        print('🔴 3. Large file upload timeout');
      } else {
        print('🔴 Unknown Error Type: ${e.runtimeType}');
        print('🔴 Full error: $e');
      }
      
      // Set user-friendly error message
      String userMessage = 'Failed to submit application. Please try again later.';
      if (e.toString().contains('SocketException') || e.toString().contains('network')) {
        userMessage = 'Network error. Please check your internet connection and try again.';
      } else if (e.toString().contains('timeout')) {
        userMessage = 'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('authentication') || e.toString().contains('token')) {
        userMessage = 'Authentication error. Please logout and login again.';
      }
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: userMessage,
      );
      return false;
    }
  }
} 