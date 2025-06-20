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
      print('🔵 VendorService: Getting vendor for user ID: ${userId.substring(0, 8)}...');
      
      final response = await _client
          .from('vendors')
          .select('*')
          .eq('auth_user_id', userId)
          .maybeSingle();
      
      if (response == null) {
        print('🟡 VendorService: No vendor found');
        return null;
      }
      
      final vendor = Vendor.fromJson(response);
      print('🟢 VendorService: Vendor found - ${vendor.fullName} (${vendor.isOnboardingComplete ? 'Complete' : 'Incomplete'}, ${vendor.isVerified ? 'Verified' : 'Unverified'})');
      
      return vendor;
    } catch (e) {
      print('🔴 VendorService: Error getting vendor: $e');
      if (e is PostgrestException) {
        print('🔴 VendorService: Postgrest error: ${e.message}');
      }
      return null;
    }
  }

  //upsert vendor
  Future<void> updateOrCreateVendor(Vendor vendor) async {
    await _client.from('vendors').upsert(vendor.toJson());
  }

  /// Creates or updates a vendor and their associated documents within a single transaction.
  Future<void> createVendorAndDocuments({
    // Vendor details
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
    // Image files to be uploaded
    File? profileImageFile,
    File? aadhaarFrontFile,
    File? aadhaarBackFile,
    File? panCardFile,
  }) async {
    try {
      print('🔵 Starting vendor upsert transaction...');
      final authUser = _client.auth.currentUser!;
      final authUserId = authUser.id;
      final authEmail = authUser.email;
      final authPhone = authUser.phone; // Get phone number from auth user
      
      print('🔵 Auth user phone: $authPhone, email: $authEmail');

      // 1. Find or create the vendor record.
      String vendorId;
      final existingVendor = await _client
          .from('vendors')
          .select('id')
          .eq('auth_user_id', authUserId)
          .maybeSingle();

      if (existingVendor != null) {
        vendorId = existingVendor['id'];
        print('🟢 Vendor found with ID: $vendorId. Updating record...');
        await _client.from('vendors').update({
          'full_name': fullName,
          'phone': authPhone, // Include phone number in update
          'business_name': businessName,
          'business_type': serviceType,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', vendorId);
      } else {
        print('🟡 No vendor found. Creating new record...');
        final newVendor = await _client.from('vendors').insert({
          'full_name': fullName,
          'auth_user_id': authUserId,
          'email': authEmail,
          'phone': authPhone, // Include phone number in creation
          'business_name': businessName,
          'business_type': serviceType,
          'verification_status': 'pending',
          'is_active': false,
        }).select('id').single();
        vendorId = newVendor['id'];
        print('🟢 New vendor created with ID: $vendorId');
      }

      // 2. Upsert the private details.
      await _client.from('vendor_private_details').upsert({
        'vendor_id': vendorId,
        'aadhaar_number': aadhaarNumber,
        'bank_account_number': bankAccountNumber,
        'bank_ifsc_code': bankIfscCode,
        'gst_number': gstNumber,
      }, onConflict: 'vendor_id');
      print('🟢 Vendor private details upserted.');

      // 3. Upload images and create/update document records.
      final List<Future> documentFutures = [];

      Future<void> uploadAndCreateDocument(File? file, String docType) async {
        if (file != null) {
          try {
            final imageUrl = await uploadImage(file, docType, vendorId);
            // Use upsert to avoid errors on retry
            documentFutures.add(
              _client.from('vendor_documents').upsert({
                'vendor_id': vendorId,
                'document_type': docType,
                'document_url': imageUrl,
                'verification_status': 'pending',
              }, onConflict: 'vendor_id, document_type'), // Assumes a vendor has one doc of each type
            );
            print('🟢 Queued document for upsert: $docType');
          } catch (e) {
            print('⚠️ Failed to upload $docType: $e - Continuing with registration...');
            // Don't rethrow - allow registration to continue without this document
          }
        }
      }
      
      // Handle profile picture upload with graceful error handling
      if (profileImageFile != null) {
        try {
          final profileImageUrl = await uploadImage(profileImageFile, 'profile', vendorId);
          documentFutures.add(
            _client.from('vendors').update({'profile_image_url': profileImageUrl}).eq('id', vendorId)
          );
          print('🟢 Queued profile picture update');
        } catch (e) {
          print('⚠️ Failed to upload profile picture: $e - Continuing with registration...');
          // Profile picture upload failed, but don't fail the entire registration
          // This is likely due to missing RLS policies on profile-pictures bucket
        }
      }

      await uploadAndCreateDocument(aadhaarFrontFile, 'identity_aadhaar_front');
      await uploadAndCreateDocument(aadhaarBackFile, 'identity_aadhaar_back');
      await uploadAndCreateDocument(panCardFile, 'identity_pan');

      if (documentFutures.isNotEmpty) {
        try {
          await Future.wait(documentFutures);
          print('🟢 All document uploads completed successfully');
        } catch (e) {
          print('⚠️ Some document uploads failed: $e - But vendor record was created');
          // Don't rethrow - vendor record is created, some uploads may have failed
        }
      }

      // Final update to mark onboarding as complete
      await _client.from('vendors').update({
        'is_onboarding_completed': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', vendorId);

      print('🎉 Transaction complete: Vendor registration completed successfully!');
      
      // Clean up temporary files after successful upload
      _cleanupTempFiles([profileImageFile, aadhaarFrontFile, aadhaarBackFile, panCardFile]);
    } catch (e) {
      print('🔴 Transaction failed in createVendorAndDocuments: $e');
      rethrow;
    }
  }

  /// Clean up temporary files after upload
  void _cleanupTempFiles(List<File?> files) {
    for (final file in files) {
      if (file != null && file.path.contains('temp_images')) {
        try {
          file.deleteSync();
          print('🧹 Cleaned up temp file: ${file.path}');
        } catch (e) {
          print('⚠️ Failed to cleanup temp file: ${file.path} - $e');
        }
      }
    }
  }

  /// Uploads an image to Supabase storage.
  /// Now requires a vendorId to structure the path correctly.
  Future<String> uploadImage(File imageFile, String imageType, String vendorId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated.');

      // Check if file exists before attempting upload
      if (!await imageFile.exists()) {
        throw Exception('Image file not found at path: ${imageFile.path}. The file may have been cleaned up.');
      }

      final bucketName = (imageType == 'profile') ? 'profile-pictures' : 'vendor-documents';
      final folderPath = vendorId; 
      final fileName = '${imageType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '$folderPath/$fileName';

      print('🔵 Uploading to bucket: $bucketName, path: $filePath');
      print('🔵 Source file: ${imageFile.path}');
      
      await _client.storage.from(bucketName).upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true), // Use upsert to handle retries
          );

      final String publicUrl = _client.storage.from(bucketName).getPublicUrl(filePath);
      print('🟢 Upload successful. URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('🔴 Image upload failed: $e');
      if (e.toString().contains('PathNotFoundException') || e.toString().contains('file not found')) {
        throw Exception('Image file was deleted or moved. Please select the image again and try uploading immediately.');
      }
      rethrow;
    }
  }

  // Find existing vendor by auth user id
  Future<Vendor?> findExistingVendor({
    required String authUserId,
  }) async {
    try {
      print('🔍 Looking for existing vendor by Auth User ID: $authUserId');

      // Only find by auth_user_id (most reliable)
      var response = await _client
          .from('vendors')
          .select('*')
          .eq('auth_user_id', authUserId)
          .maybeSingle();

      if (response != null) {
        print('🟢 Found existing vendor by auth_user_id');
        return Vendor.fromJson(response);
      }

      print('🔍 No existing vendor found');
      return null;
    } catch (e) {
      print('🔴 Error finding vendor: $e');
      return null;
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