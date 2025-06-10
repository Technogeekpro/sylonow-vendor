import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/config/supabase_config.dart';
import 'package:sylonow_vendor/features/onboarding/models/vendor.dart';
import 'dart:io';

final vendorServiceProvider = Provider((ref) => VendorService());

class VendorService {

  final SupabaseClient _client = SupabaseConfig.client;

  //get vendor by user id
  Future<Vendor?> getVendorByUserId(String userId) async {
    try {
      print('🔵 VendorService: Getting vendor for user ID: $userId');
      
      final response = await _client
          .from('vendors')
          .select('*')
          .eq('auth_user_id', userId)
          .maybeSingle();
      
      print('🔵 VendorService: Database response received');
      print('🔵 VendorService: Response data: ${response != null ? 'Found vendor data' : 'No vendor data'}');
      
      if (response == null) {
        print('🟡 VendorService: No vendor found for user: $userId');
        return null;
      }
      
      final vendor = Vendor.fromJson(response);
      print('🟢 VendorService: Vendor parsed successfully');
      print('🟢 VendorService: Vendor name: ${vendor.fullName}');
      print('🟢 VendorService: Onboarding complete: ${vendor.isOnboardingComplete}');
      print('🟢 VendorService: Is verified: ${vendor.isVerified}');
      
      return vendor;
    } catch (e) {
      print('🔴 VendorService: Error getting vendor: $e');
      print('🔴 VendorService: Error type: ${e.runtimeType}');
      if (e is PostgrestException) {
        print('🔴 VendorService: Postgrest error details: ${e.details}');
        print('🔴 VendorService: Postgrest error message: ${e.message}');
      }
      return null;
    }
  }

  //upsert vendor
  Future<void> updateOrCreateVendor(Vendor vendor) async {
    await _client.from('vendors').upsert(vendor.toJson());
  }

  /// Upload image to appropriate Supabase storage bucket
  /// For profile pictures: uses 'profile-pictures' bucket (public)
  /// For documents: uses 'vendor-documents' bucket (private with RLS)
  Future<String> uploadImage(File imageFile, String imageType) async {
    try {
      // Get current user and validate session
      final user = _client.auth.currentUser;
      final session = _client.auth.currentSession;
      
      if (user == null || session == null) {
        print('🔴 Authentication check failed:');
        print('   - User: ${user?.id ?? 'null'}');
        print('   - Session: ${session?.accessToken != null ? 'present' : 'null'}');
        throw Exception('User not authenticated or session invalid');
      }

      // Additional session validation for release builds
      if (session.isExpired) {
        print('🔴 Session expired, attempting refresh...');
        try {
          await _client.auth.refreshSession();
          print('🟢 Session refreshed successfully');
        } catch (e) {
          print('🔴 Failed to refresh session: $e');
          throw Exception('Authentication session expired and could not be refreshed');
        }
      }

      print('🔵 Uploading image for user: ${user.id}');
      print('🔵 Image type: $imageType');
      print('🔵 File size: ${await imageFile.length()} bytes');
      print('🔵 Session valid: ${!session.isExpired}');

      // Determine bucket and path based on image type
      String bucketName;
      String folderPath;
      bool isPublicBucket = false;
      
      switch (imageType.toLowerCase()) {
        case 'profile_pictures':
        case 'profile':
          bucketName = 'profile-pictures';
          folderPath = user.id; // User ID folder for profile pictures
          isPublicBucket = true; // Profile pictures are public
          break;
        case 'aadhaar_images':
        case 'aadhaar':
        case 'pan_images': 
        case 'pan':
        case 'documents':
        default:              
          bucketName = 'vendor-documents';
          folderPath = user.id; // User ID folder for documents
          isPublicBucket = false; // Documents are private
          break;
      }

      final fileName = '${imageType}_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final filePath = '$folderPath/$fileName';
      
      print('🔵 Upload details:');
      print('   - Bucket: $bucketName');
      print('   - Path: $filePath');
      print('   - File: $fileName');
      print('   - Public bucket: $isPublicBucket');
      print('   - Auth User ID: ${user.id}');
      print('   - Folder matches auth: ${folderPath == user.id}');

      // Upload file to storage with additional error handling
      try {
        await _client.storage.from(bucketName).upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true, // Allow overwriting if needed
          ),
        );
        print('🟢 File uploaded to storage successfully');
      } catch (uploadError) {
        print('🔴 Storage upload failed: $uploadError');
        
        // Specific error handling for common release build issues
        if (uploadError.toString().contains('row-level security policy')) {
          print('🔴 RLS Policy Error Details:');
          print('   - Current user ID: ${user.id}');
          print('   - Expected folder: $folderPath');
          print('   - Bucket: $bucketName');
          print('   - Session expired: ${session.isExpired}');
          throw Exception('Storage security policy error: Please ensure you are properly authenticated and try again.');
        } else if (uploadError.toString().contains('unauthorized') || uploadError.toString().contains('403')) {
          throw Exception('Upload unauthorized: Please logout and login again.');
        } else if (uploadError.toString().contains('network') || uploadError.toString().contains('connection')) {
          throw Exception('Network error during upload: Please check your internet connection and try again.');
        } else {
          throw Exception('Upload failed: ${uploadError.toString()}');
        }
      }

      // Generate appropriate URL based on bucket privacy
      String accessUrl;
      if (isPublicBucket) {
        // For public buckets (profile pictures), use public URL
        accessUrl = _client.storage
            .from(bucketName)
            .getPublicUrl(filePath);
        print('🟢 Generated public URL');
      } else {
        // For private buckets (documents), generate signed URL (valid for 1 year)
        accessUrl = await _client.storage
            .from(bucketName)
            .createSignedUrl(filePath, 31536000); // 1 year = 365 * 24 * 60 * 60 seconds
        print('🟢 Generated signed URL (private)');
      }

      print('🟢 Upload successful!');
      print('🟢 Access URL: $accessUrl');
      
      return accessUrl;
    } catch (e) {
      print('🔴 Error uploading image: $e');
      
      // Provide detailed error information
      if (e.toString().contains('row-level security policy')) {
        print('🔴 RLS policy violation - check that user is authenticated and policies allow upload');
        print('🔴 User ID: ${_client.auth.currentUser?.id}');
        print('🔴 Image type: $imageType');
      } else if (e.toString().contains('Duplicate')) {
        print('🔴 File already exists - trying with upsert enabled');
      } else if (e.toString().contains('payload too large')) {
        print('🔴 File size too large - check file size limits');
      }
      
      rethrow;
    }
  }

  // Find existing vendor by mobile or auth user id
  Future<Vendor?> findExistingVendor({
    required String mobileNumber,
    required String authUserId,
  }) async {
    try {
      print('🔍 Looking for existing vendor:');
      print('   - Mobile: $mobileNumber');
      print('   - Auth User ID: $authUserId');
      
      // First try to find by auth_user_id (most reliable)
      var response = await _client
          .from('vendors')
          .select('*')
          .eq('auth_user_id', authUserId)
          .maybeSingle();

      if (response != null) {
        print('🟢 Found existing vendor by auth_user_id: ${response['vendor_id']}');
        return Vendor.fromJson(response);
      }

      // If not found and mobile number is not empty, try by mobile number
      if (mobileNumber.trim().isNotEmpty) {
      response = await _client
          .from('vendors')
          .select('*')
          .eq('mobile_number', mobileNumber)
          .maybeSingle();

      if (response != null) {
          print('🟢 Found existing vendor by mobile number: ${response['vendor_id']}');
        return Vendor.fromJson(response);
        }
      }

      print('🔍 No existing vendor found');
      return null;
    } catch (e) {
      print('🔴 Error finding vendor: $e');
      return null;
    }
  }

  // Create or update vendor (upsert approach)
  Future<void> createVendor({
    required String mobileNumber,
    required String fullName,
    required String authUserId,
    required String serviceArea,
    required String pincode,
    required String serviceType,
    required String businessName,
    required String aadhaarNumber,
    required String bankAccountNumber,
    required String bankIfscCode,
    String? gstNumber,
    String? profilePicture,
    String? aadhaarFrontImage,
    String? aadhaarBackImage,
    String? panCardImage,
  }) async {
    try {
      print('Creating vendor for user: $authUserId');
      print('Mobile number provided: "$mobileNumber"');
      
      // Clean and validate mobile number
      final cleanedMobileNumber = mobileNumber.trim();
      
      // First check if vendor already exists
      final existingVendor = await findExistingVendor(
        mobileNumber: cleanedMobileNumber,
        authUserId: authUserId,
      );
      
      final vendorData = {
        'mobile_number': cleanedMobileNumber,
        'full_name': fullName,
        'auth_user_id': authUserId,
        'service_area': serviceArea,
        'pincode': pincode,
        'service_type': serviceType,
        'business_name': businessName,
        'aadhaar_number': aadhaarNumber,
        'bank_account_number': bankAccountNumber,
        'bank_ifsc_code': bankIfscCode,
        'gst_number': gstNumber,
        'profile_picture': profilePicture,
        'aadhaar_front_image': aadhaarFrontImage,
        'aadhaar_back_image': aadhaarBackImage,
        'pan_card_image': panCardImage,
        'is_verified': false,
        'is_onboarding_complete': true,
        'updated_at': DateTime.now().toIso8601String(),
      };

      print('Vendor data prepared: ${vendorData.keys.toList()}');
      
      if (existingVendor != null) {
        print('Vendor already exists, updating record with ID: ${existingVendor.id}');
        // Update existing vendor
        await _client
            .from('vendors')
            .update(vendorData)
            .eq('id', existingVendor.id);
        print('Vendor updated successfully');
      } else {
        print('Creating new vendor record');
        // Add created_at only for new records
        vendorData['created_at'] = DateTime.now().toIso8601String();
      await _client.from('vendors').insert(vendorData);
      print('Vendor created successfully');
      }
    } catch (e) {
      print('🔴 Error creating vendor: $e');
      
      if (e is PostgrestException) {
        print('🔴 PostgrestException details:');
        print('   - Message: ${e.message}');
        print('   - Code: ${e.code}');
        print('   - Details: ${e.details}');
        print('   - Hint: ${e.hint}');
        
        if (e.code == '23505') {
          // Unique constraint violation
          if (e.message.contains('mobile_number_key')) {
            throw Exception('A vendor with this mobile number already exists. Please use a different number or contact support.');
          } else if (e.message.contains('auth_user_id')) {
            throw Exception('A vendor profile already exists for this user account.');
          } else {
            throw Exception('Duplicate data detected: ${e.message}');
          }
        } else if (e.message.contains('row-level security policy')) {
          throw Exception('Permission denied. Please ensure you are logged in with the correct account.');
        }
      }
      
      if (e.toString().contains('row-level security policy')) {
        print('🔴 RLS policy violation - check that auth_user_id matches authenticated user');
        throw Exception('Authentication error. Please logout and login again.');
      }
      
      rethrow;
    }
  }

  /// Generate signed URL for private vendor documents
  /// This is useful when displaying documents that were uploaded previously
  Future<String> getSignedUrlForDocument(String documentUrl) async {
    try {
      // Extract the file path from the existing URL
      final uri = Uri.parse(documentUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the bucket and file path
      // URL format: https://project.supabase.co/storage/v1/object/public/bucket/path/file
      final bucketIndex = pathSegments.indexOf('vendor-documents');
      if (bucketIndex == -1) {
        // This is probably a profile picture (public), return as-is
        return documentUrl;
      }
      
      // Extract the file path (everything after the bucket name)
      final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
      
      print('🔵 Generating signed URL for: $filePath');
      
      // Generate new signed URL (valid for 1 hour for viewing)
      final signedUrl = await _client.storage
          .from('vendor-documents')
          .createSignedUrl(filePath, 3600); // 1 hour
      
      print('🟢 Generated signed URL for viewing');
      return signedUrl;
    } catch (e) {
      print('🔴 Error generating signed URL: $e');
      // Return original URL as fallback
      return documentUrl;
    }
  }

  /// Get viewable URLs for all vendor documents
  /// Converts any expired signed URLs to fresh ones
  Future<Map<String, String>> getVendorDocumentUrls({
    String? profilePictureUrl,
    String? aadhaarFrontUrl,
    String? aadhaarBackUrl,
    String? panCardUrl,
  }) async {
    final Map<String, String> urls = {};
    
    try {
      // Profile pictures are public, no need to refresh
      if (profilePictureUrl != null) {
        urls['profilePicture'] = profilePictureUrl;
      }
      
      // Generate signed URLs for private documents
      if (aadhaarFrontUrl != null) {
        urls['aadhaarFront'] = await getSignedUrlForDocument(aadhaarFrontUrl);
      }
      
      if (aadhaarBackUrl != null) {
        urls['aadhaarBack'] = await getSignedUrlForDocument(aadhaarBackUrl);
      }
      
      if (panCardUrl != null) {
        urls['panCard'] = await getSignedUrlForDocument(panCardUrl);
      }
      
      print('🟢 Generated ${urls.length} viewable URLs');
      return urls;
    } catch (e) {
      print('🔴 Error generating viewable URLs: $e');
      // Return original URLs as fallback
      return {
        if (profilePictureUrl != null) 'profilePicture': profilePictureUrl,
        if (aadhaarFrontUrl != null) 'aadhaarFront': aadhaarFrontUrl,
        if (aadhaarBackUrl != null) 'aadhaarBack': aadhaarBackUrl,
        if (panCardUrl != null) 'panCard': panCardUrl,
      };
    }
  }
} 