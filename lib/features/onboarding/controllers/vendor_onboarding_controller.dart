import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../service/vendor_service.dart';
import '../../../core/config/supabase_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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
  final String? profileImageUrl;
  final String? aadhaarFrontImageUrl;
  final String? aadhaarBackImageUrl;
  final String? panCardImageUrl;

  const VendorOnboardingState({
    this.isLoading = false,
    this.errorMessage,
    this.profileImage,
    this.aadhaarFrontImage,
    this.aadhaarBackImage,
    this.panCardImage,
    this.profileImageUrl,
    this.aadhaarFrontImageUrl,
    this.aadhaarBackImageUrl,
    this.panCardImageUrl,
  });

  VendorOnboardingState copyWith({
    bool? isLoading,
    String? errorMessage,
    File? profileImage,
    File? aadhaarFrontImage,
    File? aadhaarBackImage,
    File? panCardImage,
    String? profileImageUrl,
    String? aadhaarFrontImageUrl,
    String? aadhaarBackImageUrl,
    String? panCardImageUrl,
  }) {
    return VendorOnboardingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      profileImage: profileImage ?? this.profileImage,
      aadhaarFrontImage: aadhaarFrontImage ?? this.aadhaarFrontImage,
      aadhaarBackImage: aadhaarBackImage ?? this.aadhaarBackImage,
      panCardImage: panCardImage ?? this.panCardImage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      aadhaarFrontImageUrl: aadhaarFrontImageUrl ?? this.aadhaarFrontImageUrl,
      aadhaarBackImageUrl: aadhaarBackImageUrl ?? this.aadhaarBackImageUrl,
      panCardImageUrl: panCardImageUrl ?? this.panCardImageUrl,
    );
  }
}

class VendorOnboardingController extends StateNotifier<VendorOnboardingState> {
  final Ref ref;

  VendorOnboardingController(this.ref) : super(const VendorOnboardingState());

  void setProfileImage(File? image) {
    // Clear any previous image first
    if (state.profileImage != null) {
      try {
        // Only delete if it's clearly a temporary file
        if (state.profileImage!.path.contains('temp_images') || 
            state.profileImage!.path.contains('cache')) {
          state.profileImage!.deleteSync();
          print('🧹 Cleaned up old profile image');
        }
      } catch (e) {
        print('⚠️ Failed to delete old profile image: $e');
      }
    }
    state = state.copyWith(profileImage: image);
    print('📸 Profile image set: ${image?.path ?? 'null'}');
  }

  void setProfileImageUrl(String url) {
    state = state.copyWith(profileImageUrl: url);
    print('📸 Profile image URL set: $url');
  }

  void setAadhaarFrontImage(File? image) {
    // Clear any previous image first
    if (state.aadhaarFrontImage != null) {
      try {
        // Only delete if it's clearly a temporary file
        if (state.aadhaarFrontImage!.path.contains('temp_images') || 
            state.aadhaarFrontImage!.path.contains('cache')) {
          state.aadhaarFrontImage!.deleteSync();
          print('🧹 Cleaned up old aadhaar front image');
        }
      } catch (e) {
        print('⚠️ Failed to delete old aadhaar front image: $e');
      }
    }
    state = state.copyWith(aadhaarFrontImage: image);
    print('📸 Aadhaar front image set: ${image?.path ?? 'null'}');
  }

  void setAadhaarFrontImageUrl(String url) {
    print('🔵 setAadhaarFrontImageUrl called with: $url');
    state = state.copyWith(aadhaarFrontImageUrl: url);
    print('🔵 State updated, aadhaarFrontImageUrl is now: ${state.aadhaarFrontImageUrl}');
  }

  void setAadhaarBackImage(File? image) {
    // Clear any previous image first
    if (state.aadhaarBackImage != null) {
      try {
        // Only delete if it's clearly a temporary file
        if (state.aadhaarBackImage!.path.contains('temp_images') || 
            state.aadhaarBackImage!.path.contains('cache')) {
          state.aadhaarBackImage!.deleteSync();
          print('🧹 Cleaned up old aadhaar back image');
        }
      } catch (e) {
        print('⚠️ Failed to delete old aadhaar back image: $e');
      }
    }
    state = state.copyWith(aadhaarBackImage: image);
    print('📸 Aadhaar back image set: ${image?.path ?? 'null'}');
  }

  void setAadhaarBackImageUrl(String url) {
    print('🔵 setAadhaarBackImageUrl called with: $url');
    state = state.copyWith(aadhaarBackImageUrl: url);
    print('🔵 State updated, aadhaarBackImageUrl is now: ${state.aadhaarBackImageUrl}');
  }

  void setPanCardImage(File? image) {
    // Clear any previous image first
    if (state.panCardImage != null) {
      try {
        // Only delete if it's clearly a temporary file
        if (state.panCardImage!.path.contains('temp_images') || 
            state.panCardImage!.path.contains('cache')) {
          state.panCardImage!.deleteSync();
          print('🧹 Cleaned up old pan card image');
        }
      } catch (e) {
        print('⚠️ Failed to delete old pan card image: $e');
      }
    }
    state = state.copyWith(panCardImage: image);
    print('📸 PAN card image set: ${image?.path ?? 'null'}');
  }

  void setPanCardImageUrl(String url) {
    print('🔵 setPanCardImageUrl called with: $url');
    state = state.copyWith(panCardImageUrl: url);
    print('🔵 State updated, panCardImageUrl is now: ${state.panCardImageUrl}');
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
      
      // Validate that we have either files OR URLs for required documents
      final documentsStatus = {
        'profile': state.profileImageUrl != null || state.profileImage != null,
        'aadhaar_front': state.aadhaarFrontImageUrl != null || state.aadhaarFrontImage != null,
        'aadhaar_back': state.aadhaarBackImageUrl != null || state.aadhaarBackImage != null,
        'pan_card': state.panCardImageUrl != null || state.panCardImage != null,
      };
      
      print('🔍 Document validation status:');
      print('  aadhaar_front: URL=${state.aadhaarFrontImageUrl != null}, File=${state.aadhaarFrontImage != null}');
      print('    URL value: ${state.aadhaarFrontImageUrl}');
      print('    File value: ${state.aadhaarFrontImage?.path}');
      print('  aadhaar_back: URL=${state.aadhaarBackImageUrl != null}, File=${state.aadhaarBackImage != null}');
      print('    URL value: ${state.aadhaarBackImageUrl}');
      print('    File value: ${state.aadhaarBackImage?.path}');
      print('  pan_card: URL=${state.panCardImageUrl != null}, File=${state.panCardImage != null}');
      print('    URL value: ${state.panCardImageUrl}');
      print('    File value: ${state.panCardImage?.path}');
      print('  profile: URL=${state.profileImageUrl != null}, File=${state.profileImage != null}');
      print('    URL value: ${state.profileImageUrl}');
      print('    File value: ${state.profileImage?.path}');
      
      documentsStatus.forEach((type, hasDocument) {
        print('  $type: hasDocument=$hasDocument');
      });
      
      // Check required documents
      final missingDocs = <String>[];
      if (!documentsStatus['aadhaar_front']!) {
        missingDocs.add('Aadhaar Front');
        print('🔴 Missing Aadhaar Front - URL: ${state.aadhaarFrontImageUrl}, File: ${state.aadhaarFrontImage?.path}');
      }
      if (!documentsStatus['aadhaar_back']!) {
        missingDocs.add('Aadhaar Back');
        print('🔴 Missing Aadhaar Back - URL: ${state.aadhaarBackImageUrl}, File: ${state.aadhaarBackImage?.path}');
      }
      if (!documentsStatus['pan_card']!) {
        missingDocs.add('PAN Card');
        print('🔴 Missing PAN Card - URL: ${state.panCardImageUrl}, File: ${state.panCardImage?.path}');
      }
      
      if (missingDocs.isNotEmpty) {
        print('🔴 Validation failed - Missing documents: $missingDocs');
        throw Exception('Missing required documents: ${missingDocs.join(', ')}. Please upload all required documents.');
      }
      
      print('🟢 All required documents are available, proceeding with submission...');
      
      // For submission, we'll pass URLs if available, otherwise files
      final vendorService = ref.read(vendorServiceProvider);

      // Call the service with a mix of URLs and files
      await vendorService.createVendorAndDocumentsWithUrls(
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
        // Images - URLs take priority
        profileImageUrl: state.profileImageUrl,
        profileImageFile: state.profileImage,
        aadhaarFrontImageUrl: state.aadhaarFrontImageUrl,
        aadhaarFrontFile: state.aadhaarFrontImage,
        aadhaarBackImageUrl: state.aadhaarBackImageUrl,
        aadhaarBackFile: state.aadhaarBackImage,
        panCardImageUrl: state.panCardImageUrl,
        panCardFile: state.panCardImage,
      );

      print('🟢 Vendor application submitted successfully in controller!');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('🔴 Error submitting vendor application in controller: $e');
      
      String userMessage;
      if (e.toString().contains('already a verified vendor')) {
        userMessage = 'You are already a verified vendor! Please check your app - you should be able to see the home screen.';
      } else if (e.toString().contains('registration is already complete')) {
        userMessage = 'Your vendor registration is already under review. Please wait for verification to complete.';
      } else if (e.toString().contains('duplicate key value violates unique constraint')) {
        userMessage = 'This email is already registered. If this is your account, please contact support.';
      } else if (e.toString().contains('email address is already registered')) {
        userMessage = 'This email is already registered with another account. Please use a different email.';
      } else if (e.toString().contains('image file is missing') || 
                 e.toString().contains('Please re-select the image')) {
        userMessage = 'One or more images are missing. Please re-select all images and try again.';
      } else if (e.toString().contains('corrupted') || e.toString().contains('empty')) {
        userMessage = 'One or more images are corrupted. Please select different images and try again.';
      } else if (e.toString().contains('Failed to save') || 
                 e.toString().contains('persistent storage')) {
        userMessage = 'Failed to save images. Please free up some storage space and try again.';
      } else {
        userMessage = 'Failed to submit application. Please try again. If the problem persists, contact support.';
      }
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: userMessage,
      );
      return false;
    }
  }

  Future<File?> _ensureFilePersistence(File file, String type) async {
    try {
      // Create a more persistent directory for vendor uploads
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String uploadsDir = path.join(appDir.path, 'vendor_uploads');
      await Directory(uploadsDir).create(recursive: true);
      
      // Create a new filename with timestamp to avoid conflicts
      final String fileName = 'vendor_${type}_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final String persistentPath = path.join(uploadsDir, fileName);
      
      // Copy the file to the more persistent location
      final File persistentFile = await file.copy(persistentPath);
      
      // Verify the copy was successful
      if (await persistentFile.exists()) {
        final size = await persistentFile.length();
        print('🟢 Created persistent copy of $type: $persistentPath ($size bytes)');
        return persistentFile;
      } else {
        print('🔴 Failed to create persistent copy of $type');
        return file; // Return original file as fallback
      }
    } catch (e) {
      print('🔴 Error creating persistent copy of $type: $e');
      // Return original file as fallback
      return file;
    }
  }

  String? _getUrlForType(String type) {
    if (type == 'profile') {
      return state.profileImageUrl;
    } else if (type == 'aadhaar_front') {
      return state.aadhaarFrontImageUrl;
    } else if (type == 'aadhaar_back') {
      return state.aadhaarBackImageUrl;
    } else if (type == 'pan_card') {
      return state.panCardImageUrl;
    }
    return null;
  }

  File? _getFileForType(String type) {
    if (type == 'profile') {
      return state.profileImage;
    } else if (type == 'aadhaar_front') {
      return state.aadhaarFrontImage;
    } else if (type == 'aadhaar_back') {
      return state.aadhaarBackImage;
    } else if (type == 'pan_card') {
      return state.panCardImage;
    }
    return null;
  }
} 