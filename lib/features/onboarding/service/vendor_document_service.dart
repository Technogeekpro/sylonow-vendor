import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import 'package:path/path.dart' as path;

class VendorDocumentService {
  final SupabaseClient _client = SupabaseConfig.client;
  final String _storageBucket = 'vendor-documents';
  final String _tableName = 'vendor_documents';

  VendorDocumentService();

  /// Check if a vendor already exists with the given mobile number or auth_user_id
  Future<Map<String, dynamic>?> checkExistingVendor({
    String? mobileNumber,
    String? authUserId,
  }) async {
    try {
      print('Checking for existing vendor...'); // Debug log
      
      var query = _client.from('vendors').select();
      
      if (mobileNumber != null && mobileNumber.isNotEmpty) {
        query = query.eq('mobile_number', mobileNumber);
      } else if (authUserId != null) {
        query = query.eq('auth_user_id', authUserId);
      } else {
        throw Exception('Either mobile number or auth user ID must be provided');
      }
      
      final response = await query.maybeSingle();
      
      if (response != null) {
        print('Found existing vendor: ${response['vendor_id']}'); // Debug log
        return response;
      }
      
      print('No existing vendor found'); // Debug log
      return null;
    } catch (e) {
      print('Error checking existing vendor: $e'); // Debug log
      throw Exception('Failed to check existing vendor: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getVendorDocuments(String vendorId) async {
    try {
      print('Fetching documents for vendor: $vendorId'); // Debug log

      final response = await _client
          .from(_tableName)
          .select()
          .eq('vendor_id', vendorId);

      print('Found ${response.length} documents'); // Debug log
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error in getVendorDocuments: $e'); // Debug log
      throw Exception('Failed to fetch vendor documents: $e');
    }
  }

  Future<String> uploadDocument(String filePath, String documentType) async {
    try {
      print('Starting document upload...'); // Debug log
      print('- Type: $documentType');
      print('- Path: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File does not exist: $filePath');
      }

      // Get current user
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final fileExt = path.extension(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      // Use user ID as folder structure for proper RLS policy matching
      final storagePath = '${user.id}/$documentType/$fileName';

      print('Uploading to storage path: $storagePath'); // Debug log

      final response = await _client
          .storage
          .from(_storageBucket)
          .upload(storagePath, file);

      if (response.isEmpty) {
        throw Exception('Failed to upload document');
      }

      final url = _client
          .storage
          .from(_storageBucket)
          .getPublicUrl(storagePath);

      print('Document uploaded successfully: $url'); // Debug log
      return url;
    } catch (e) {
      print('Error in uploadDocument: $e'); // Debug log
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<void> deleteDocument(String documentUrl) async {
    try {
      print('Deleting document: $documentUrl'); // Debug log

      final uri = Uri.parse(documentUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the bucket name in path segments and extract the file path after it
      final bucketIndex = pathSegments.indexWhere((segment) => segment == _storageBucket);
      if (bucketIndex == -1) {
        throw Exception('Invalid document URL: bucket not found in path');
      }
      
      final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');

      await _client
          .storage
          .from(_storageBucket)
          .remove([storagePath]);

      print('Document deleted successfully'); // Debug log
    } catch (e) {
      print('Error in deleteDocument: $e'); // Debug log
      throw Exception('Failed to delete document: $e');
    }
  }
} 