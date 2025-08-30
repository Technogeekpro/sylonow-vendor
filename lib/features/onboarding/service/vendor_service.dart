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
      
      final currentUser = _client.auth.currentUser;
      print('🔍 Current user - ID: ${currentUser?.id}, Phone: ${currentUser?.phone}, Email: ${currentUser?.email}');
      
      // First try by auth_user_id
      var response = await _client
          .from('vendors')
          .select('*')
          .eq('auth_user_id', userId)
          .maybeSingle();
      
      if (response != null) {
        final vendor = Vendor.fromJson(response);
        print('🟢 VendorService: Vendor found by auth_user_id - ${vendor.fullName} (${vendor.isOnboardingComplete ? 'Complete' : 'Incomplete'}, ${vendor.isVerified ? 'Verified' : 'Unverified'})');
        return vendor;
      }
      
      // If not found by auth_user_id, try by phone number
      if (currentUser?.phone != null) {
        print('🔍 VendorService: Trying lookup by phone: ${currentUser!.phone}');
        
        // Try exact phone match first
        response = await _client
            .from('vendors')
            .select('*')
            .eq('phone', currentUser.phone!)
            .maybeSingle();
            
        if (response != null) {
          final vendor = Vendor.fromJson(response);
          print('🟡 VendorService: Vendor found by phone - updating auth_user_id link');
          
        // Update the auth_user_id to link this vendor to current user
          await _client
              .from('vendors')
              .update({'auth_user_id': userId})
              .eq('id', vendor.id!);
              
          // Return updated vendor
          final updatedVendor = vendor.copyWith(authUserId: userId);
          print('🟢 VendorService: Vendor linked and returned - ${vendor.fullName}');
          return updatedVendor;
        }
        
        // Try without +91 prefix
        final phoneWithoutPrefix = currentUser.phone!.replaceFirst('+91', '');
        response = await _client
            .from('vendors')
            .select('*')
            .eq('phone', phoneWithoutPrefix)
            .maybeSingle();
            
        if (response != null) {
          final vendor = Vendor.fromJson(response);
          print('🟡 VendorService: Vendor found by phone without prefix - updating auth_user_id link');
          
          // Update the auth_user_id to link this vendor to current user
          await _client
              .from('vendors')
              .update({'auth_user_id': userId})
              .eq('id', vendor.id!);
              
          // Return updated vendor
          final updatedVendor = vendor.copyWith(authUserId: userId);
          print('🟢 VendorService: Vendor linked and returned - ${vendor.fullName}');
          return updatedVendor;
        }
      }
      
      // Try by email if available
      if (currentUser?.email != null) {
        print('🔍 VendorService: Trying lookup by email: ${currentUser!.email}');
        response = await _client
            .from('vendors')
            .select('*')
            .eq('email', currentUser.email!)
            .maybeSingle();
            
        if (response != null) {
          final vendor = Vendor.fromJson(response);
          print('🟡 VendorService: Vendor found by email - updating auth_user_id link');
          
          // Update the auth_user_id to link this vendor to current user
          await _client
              .from('vendors')
              .update({'auth_user_id': userId})
              .eq('id', vendor.id!);
              
          // Return updated vendor
          final updatedVendor = vendor.copyWith(authUserId: userId);
          print('🟢 VendorService: Vendor linked and returned - ${vendor.fullName}');
          return updatedVendor;
        }
      }
      
      print('🟡 VendorService: No vendor found by any method');
      return null;
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

  /// Checks if a vendor exists and their current status
  Future<Map<String, dynamic>> checkVendorStatus(String authUserId) async {
    try {
      print('🔍 Checking vendor status for auth_user_id: $authUserId');
      
      final authUser = _client.auth.currentUser!;
      final authEmail = authUser.email;
      
      // Check by auth_user_id first
      final vendorByAuth = await _client
          .from('vendors')
          .select('id, email, is_onboarding_completed, verification_status, is_active')
          .eq('auth_user_id', authUserId)
          .maybeSingle();
      
      if (vendorByAuth != null) {
        print('🟢 Vendor found by auth_user_id: ${vendorByAuth['id']}');
        return {
          'exists': true,
          'vendor_id': vendorByAuth['id'],
          'is_onboarding_completed': vendorByAuth['is_onboarding_completed'] ?? false,
          'verification_status': vendorByAuth['verification_status'] ?? 'pending',
          'is_ready_for_business': vendorByAuth['verification_status'] == 'verified' && vendorByAuth['is_active'] == true,
          'found_by': 'auth_user_id'
        };
      }
      
      // Check by email if not found by auth_user_id
      if (authEmail != null) {
        print('🔍 Checking by email: $authEmail');
        final vendorByEmail = await _client
            .from('vendors')
            .select('id, auth_user_id, email, is_onboarding_completed, verification_status, is_active')
            .eq('email', authEmail)
            .maybeSingle();
        
        if (vendorByEmail != null) {
          final existingAuthUserId = vendorByEmail['auth_user_id'];
          print('🟡 Vendor found by email: ${vendorByEmail['id']}, existing auth_user_id: $existingAuthUserId');
          
          if (existingAuthUserId != null && existingAuthUserId != authUserId) {
            // Email exists with different auth_user_id
            return {
              'exists': true,
              'vendor_id': vendorByEmail['id'],
              'is_onboarding_completed': vendorByEmail['is_onboarding_completed'] ?? false,
              'verification_status': vendorByEmail['verification_status'] ?? 'pending',
              'is_ready_for_business': vendorByEmail['verification_status'] == 'verified' && vendorByEmail['is_active'] == true,
              'found_by': 'email_different_auth',
              'existing_auth_user_id': existingAuthUserId,
              'conflict': true
            };
          } else if (existingAuthUserId == null) {
            // Email exists but no auth_user_id - can be linked
            return {
              'exists': true,
              'vendor_id': vendorByEmail['id'],
              'is_onboarding_completed': vendorByEmail['is_onboarding_completed'] ?? false,
              'verification_status': vendorByEmail['verification_status'] ?? 'pending',
              'is_ready_for_business': vendorByEmail['verification_status'] == 'verified' && vendorByEmail['is_active'] == true,
              'found_by': 'email_no_auth',
              'can_link': true
            };
          }
        }
      }
      
      print('🔴 No vendor found by auth_user_id or email');
      return {
        'exists': false,
      };
    } catch (e) {
      print('🔴 Error checking vendor status: $e');
      return {
        'exists': false,
        'error': e.toString(),
      };
    }
  }

  /// Creates or updates a vendor and their associated documents with support for both URLs and files.
  /// URLs take priority over files when both are provided.
  Future<void> createVendorAndDocumentsWithUrls({
    // Vendor details
    required String fullName,
    required String authUserId,
    required String serviceArea,
    required String pincode,
    required String serviceType,
    required String vendorType,
    required String businessName,
    required String aadhaarNumber,
    required String bankAccountNumber,
    required String bankIfscCode,
    required String additionalAddress,
    String? fcmToken,
    String? gstNumber,
    double? latitude,
    double? longitude,
    // Image URLs (take priority)
    String? profileImageUrl,
    String? aadhaarFrontImageUrl,
    String? aadhaarBackImageUrl,
    String? panCardImageUrl,
    // Image files (fallback)
    File? profileImageFile,
    File? aadhaarFrontFile,
    File? aadhaarBackFile,
    File? panCardFile,
  }) async {
    try {
      print('🔵 Starting vendor creation with URL/file support...');
      final authUser = _client.auth.currentUser!;
      final authUserId = authUser.id;
      
      print('🔍 Current user auth_user_id: $authUserId');
      print('🔍 Current user email: ${authUser.email}');
      
      // Check vendor status first
      final vendorStatus = await checkVendorStatus(authUserId);
      
      if (vendorStatus['exists'] == true) {
        final isOnboardingCompleted = vendorStatus['is_onboarding_completed'] == true;
        final isReadyForBusiness = vendorStatus['is_ready_for_business'] == true;
        final foundBy = vendorStatus['found_by'];
        final hasConflict = vendorStatus['conflict'] == true;
        
        if (hasConflict) {
          // Email exists with different auth_user_id
          final existingAuthUserId = vendorStatus['existing_auth_user_id'];
          print('🔴 Email conflict detected: Email is registered with auth_user_id: $existingAuthUserId, current user: $authUserId');
          
          if (isOnboardingCompleted && isReadyForBusiness) {
            throw Exception('This email address is already registered with a verified vendor account. If this is your account, please contact support to link it to your current login method.');
          } else if (isOnboardingCompleted) {
            throw Exception('This email address is already registered with a vendor account that is pending verification. If this is your account, please contact support to link it to your current login method.');
          } else {
            throw Exception('This email address is already in use with another account. Please use a different email address or contact support if you believe this is an error.');
          }
        }
        
        if (isReadyForBusiness) {
          print('🎉 Vendor is already fully verified and ready for business!');
          throw Exception('You are already a verified vendor and ready to receive bookings! If you need to update your information, please use the profile settings.');
        }
        
        if (isOnboardingCompleted) {
          print('🟡 Vendor onboarding is complete but verification is pending');
          throw Exception('Your vendor registration is already complete and is under review. You will be notified once verification is complete.');
        }
        
        print('🟡 Vendor exists but onboarding is incomplete. Continuing with update...');
      }
      
      final userAppType = await _getUserAppType(authUserId);
      if (userAppType == 'customer') {
        throw Exception('Access denied: Customer users cannot create vendor profiles. App type: $userAppType');
      }
      
      final authEmail = authUser.email;
      final authPhone = authUser.phone;
      
      // Email can be null for phone-based authentication
      print('🔵 Auth user phone: $authPhone, email: $authEmail, app type: $userAppType');

      // 1. Find or create the vendor record
      String vendorId;
      
      // First, check by auth_user_id
      final existingVendorByAuth = await _client
          .from('vendors')
          .select('id, email, is_onboarding_completed, verification_status')
          .eq('auth_user_id', authUserId)
          .maybeSingle();

      // Also check by email to handle cases where auth_user_id might be different (only if email is not null)
      Map<String, dynamic>? existingVendorByEmail;
      if (authEmail != null && authEmail.isNotEmpty) {
        existingVendorByEmail = await _client
            .from('vendors')
            .select('id, auth_user_id, email, is_onboarding_completed, verification_status')
            .eq('email', authEmail)
            .maybeSingle();
      }

      if (existingVendorByAuth != null) {
        // Found vendor by auth_user_id - this is the normal case
        vendorId = existingVendorByAuth['id'];
        print('🟢 Vendor found by auth_user_id: $vendorId. Updating record...');
        
        final locationJson = (latitude != null && longitude != null) ? {
          'latitude': latitude,
          'longitude': longitude,
          'address': serviceArea,
          'pincode': pincode,
          'timestamp': DateTime.now().toIso8601String(),
        } : null;

        await _client.from('vendors').update({
          'full_name': fullName,
          'phone': authPhone,
          'business_name': businessName,
          'business_type': serviceType,
          'service_area': serviceArea,
          'pincode': pincode,
          'latitude': latitude,
          'longitude': longitude,
          'location': locationJson,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', vendorId);
        
      } else if (existingVendorByEmail != null) {
        // Found vendor by email but different auth_user_id
        vendorId = existingVendorByEmail['id'];
        final existingAuthUserId = existingVendorByEmail['auth_user_id'];
        
        if (existingAuthUserId == null) {
          // Email exists but no auth_user_id - link it to current user
          print('🟡 Vendor found by email with no auth_user_id. Linking to current user: $vendorId');
          
          final locationJson = (latitude != null && longitude != null) ? {
            'latitude': latitude,
            'longitude': longitude,
            'address': serviceArea,
            'pincode': pincode,
            'timestamp': DateTime.now().toIso8601String(),
          } : null;

          await _client.from('vendors').update({
            'auth_user_id': authUserId,
            'full_name': fullName,
            'phone': authPhone,
            'business_name': businessName,
            'business_type': serviceType,
            'service_area': serviceArea,
            'pincode': pincode,
            'latitude': latitude,
            'longitude': longitude,
            'location': locationJson,
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('id', vendorId);
          
        } else if (existingAuthUserId != authUserId) {
          // Email exists with different auth_user_id - this is a conflict
          print('🔴 Email conflict: This email is already registered with a different account');
          throw Exception('This email address is already registered with another account. Please use a different email or contact support if you believe this is an error.');
          
        } else {
          // This shouldn't happen (would be caught by first check), but handle it
          print('🟢 Vendor found by email with same auth_user_id: $vendorId. Updating record...');
          
          final locationJson = (latitude != null && longitude != null) ? {
            'latitude': latitude,
            'longitude': longitude,
            'address': serviceArea,
            'pincode': pincode,
            'timestamp': DateTime.now().toIso8601String(),
          } : null;

          await _client.from('vendors').update({
            'full_name': fullName,
            'phone': authPhone,
            'business_name': businessName,
            'business_type': serviceType,
            'service_area': serviceArea,
            'pincode': pincode,
            'latitude': latitude,
            'longitude': longitude,
            'location': locationJson,
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('id', vendorId);
        }
        
      } else {
        // No existing vendor found - create new one
        print('🟡 No vendor found by auth_user_id or email. Creating new record...');
        final locationJson = (latitude != null && longitude != null) ? {
          'latitude': latitude,
          'longitude': longitude,
          'address': serviceArea,
          'pincode': pincode,
          'timestamp': DateTime.now().toIso8601String(),
        } : null;

        final newVendor = await _client.from('vendors').insert({
          'full_name': fullName,
          'auth_user_id': authUserId,
          'email': authEmail,
          'phone': authPhone,
          'business_name': businessName,
          'business_type': serviceType,
          'vendor_type': vendorType,
          'verification_status': 'pending',
          'is_active': false,
          'service_area': serviceArea,
          'additional_address': additionalAddress,
          'fcm_token': fcmToken,
          'pincode': pincode,
          'latitude': latitude,
          'longitude': longitude,
          'location': locationJson,
        }).select('id').single();
        vendorId = newVendor['id'];
        print('🟢 New vendor created with ID: $vendorId');
      }

      // 2. Upsert the private details
      await _client.from('vendor_private_details').upsert({
        'vendor_id': vendorId,
        'aadhaar_number': aadhaarNumber,
        'bank_account_number': bankAccountNumber,
        'bank_ifsc_code': bankIfscCode,
        'gst_number': gstNumber,
      }, onConflict: 'vendor_id');
      print('🟢 Vendor private details upserted.');

      // 3. Handle documents with URL priority
      final List<Future> documentFutures = [];

      Future<void> handleDocument(String? url, File? file, String docType) async {
        String? finalUrl;
        
        if (url != null) {
          // URL is already available, use it directly
          finalUrl = url;
          print('🟢 Using existing URL for $docType: $url');
        } else if (file != null) {
          // Upload file to get URL
          try {
            finalUrl = await uploadImage(file, docType, vendorId);
            print('🟢 Uploaded $docType to get URL: $finalUrl');
          } catch (e) {
            print('⚠️ Failed to upload $docType: $e - Skipping document...');
            return;
          }
        } else {
          print('ℹ️ No URL or file provided for $docType - skipping');
          return;
        }
        
        // Create/update document record
        documentFutures.add(
          _client.from('vendor_documents').upsert({
            'vendor_id': vendorId,
            'document_type': docType,
            'document_url': finalUrl,
            'verification_status': 'pending',
          }, onConflict: 'vendor_id, document_type'),
        );
        print('🟢 Queued document record for $docType');
            }
      
      // Handle profile picture (updates vendor record directly)
      if (profileImageUrl != null) {
        documentFutures.add(
          _client.from('vendors').update({'profile_image_url': profileImageUrl}).eq('id', vendorId)
        );
        print('🟢 Using existing profile image URL');
      } else if (profileImageFile != null) {
        try {
          final profileUrl = await uploadImage(profileImageFile, 'profile', vendorId);
          documentFutures.add(
            _client.from('vendors').update({'profile_image_url': profileUrl}).eq('id', vendorId)
          );
          print('🟢 Uploaded and set profile image');
        } catch (e) {
          print('⚠️ Failed to upload profile image: $e - Continuing without it...');
        }
      }

      // Handle documents
      await handleDocument(aadhaarFrontImageUrl, aadhaarFrontFile, 'identity_aadhaar_front');
      await handleDocument(aadhaarBackImageUrl, aadhaarBackFile, 'identity_aadhaar_back');
      await handleDocument(panCardImageUrl, panCardFile, 'identity_pan');

      if (documentFutures.isNotEmpty) {
        try {
          await Future.wait(documentFutures);
          print('🟢 All document operations completed successfully');
        } catch (e) {
          print('⚠️ Some document operations failed: $e - But vendor record was created');
        }
      }

      // Final update to mark onboarding as complete
      await _client.from('vendors').update({
        'is_onboarding_completed': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', vendorId);

      print('🎉 Vendor registration completed successfully with URL/file support!');
      
    } catch (e) {
      print('🔴 Transaction failed in createVendorAndDocumentsWithUrls: $e');
      rethrow;
    }
  }

  /// Clean up temporary files after upload
  void _cleanupTempFiles(List<File?> files) {
    for (final file in files) {
      if (file != null) {
        try {
          // Only clean up files that are explicitly in temp directories
          // Be more conservative - only clean up if we're sure it's a temp file
          if (file.path.contains('temp_images') || 
              (file.path.contains('vendor_uploads') && file.path.contains('cache'))) {
            file.deleteSync();
            print('🧹 Cleaned up temp file: ${file.path}');
          } else {
            print('ℹ️ Keeping file (not temp): ${file.path}');
          }
        } catch (e) {
          print('⚠️ Failed to cleanup file: ${file.path} - $e');
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

      print('🔵 Starting upload for $imageType...');
      print('🔵 File path: ${imageFile.path}');

      // Check if file exists before attempting upload
      if (!await imageFile.exists()) {
        print('🔴 File not found at path: ${imageFile.path}');
        
        // Try to provide helpful error message based on file path
        if (imageFile.path.contains('temp_images')) {
          throw Exception('Image file was moved or deleted from temporary storage. Please select the image again and upload immediately.');
        } else {
          throw Exception('Image file not found. Please select the image again.');
        }
      }
      
      // Verify file size and readability
      int fileSize;
      try {
        fileSize = await imageFile.length();
        if (fileSize == 0) {
          throw Exception('Selected image file is empty or corrupted. Please choose a different image.');
        }
        print('🔵 File size: $fileSize bytes');
      } catch (e) {
        throw Exception('Unable to read the selected image file. Please choose a different image.');
      }

      final bucketName = (imageType == 'profile') ? 'profile-pictures' : 'vendor-documents';
      final folderPath = vendorId; 
      final fileName = '${imageType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '$folderPath/$fileName';

      print('🔵 Uploading to bucket: $bucketName, path: $filePath');
      
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
      
      // Provide more specific error messages
      if (e.toString().contains('PathNotFoundException') || e.toString().contains('file not found')) {
        throw Exception('Image file was deleted or moved. Please select the image again and try uploading immediately.');
      } else if (e.toString().contains('corrupted') || e.toString().contains('empty')) {
        throw Exception('The selected image file is corrupted or invalid. Please choose a different image.');
      } else if (e.toString().contains('User not authenticated')) {
        throw Exception('Your session has expired. Please log in again and try uploading.');
      } else {
        // Pass through our custom exceptions
        rethrow;
      }
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

  // 🔴 NEW: Helper method to get user app type
  Future<String?> _getUserAppType(String userId) async {
    try {
      final response = await _client.rpc('get_user_app_type', params: {
        'user_id': userId,
      });
      
      return response as String?;
    } catch (e) {
      print('🔴 Failed to get user app type: $e');
      return null;
    }
  }

  /// Update vendor online status
  Future<bool> updateVendorOnlineStatus(String vendorId, bool isOnline) async {
    try {
      print('🔵 VendorService: Updating online status for vendor $vendorId to $isOnline');
      
      await _client
          .from('vendors')
          .update({
            'is_online': isOnline,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', vendorId);
          
      print('🟢 VendorService: Vendor online status updated successfully');
      return true;
    } catch (e) {
      print('🔴 VendorService: Error updating vendor online status: $e');
      return false;
    }
  }
} 