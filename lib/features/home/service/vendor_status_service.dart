import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vendor_status_model.dart';
import '../../../core/config/supabase_config.dart';

class VendorStatusService {
  final SupabaseClient _client = SupabaseConfig.client;

  static const String _tableName = 'vendors';

  Future<VendorStatusModel?> getVendorStatus(String vendorId) async {
    try {
      print('Fetching vendor status for ID: $vendorId'); // Debug log
      
      final response = await _client
          .from(_tableName)
          .select('id, is_verified, is_onboarding_complete, created_at, updated_at')
          .eq('id', vendorId)
          .maybeSingle();
      
      if (response != null) {
        print('Vendor status found'); // Debug log
        
        // Map the response to our VendorStatusModel
        final statusData = {
          'vendor_id': response['id'],
          'is_verified': response['is_verified'] ?? false,
          'is_onboarding_complete': response['is_onboarding_complete'] ?? false,
          'verification_status': _getVerificationStatus(
            response['is_verified'] ?? false,
            response['is_onboarding_complete'] ?? false,
          ),
          'created_at': response['created_at'],
          'updated_at': response['updated_at'],
        };
        
        return VendorStatusModel.fromJson(statusData);
      }
      
      print('No vendor status found for ID: $vendorId'); // Debug log
      return null;
    } catch (e) {
      print('Error in getVendorStatus: $e'); // Debug log
      throw Exception('Failed to get vendor status: $e');
    }
  }

  Future<VendorStatusModel?> getVendorStatusByAuthId(String authUserId) async {
    try {
      print('Fetching vendor status for auth user ID: $authUserId'); // Debug log
      
      final response = await _client
          .from(_tableName)
          .select('id, is_verified, is_onboarding_complete, created_at, updated_at')
          .eq('auth_user_id', authUserId)
          .maybeSingle();
      
      if (response != null) {
        print('Vendor status found for auth user'); // Debug log
        
        // Map the response to our VendorStatusModel
        final statusData = {
          'vendor_id': response['id'],
          'is_verified': response['is_verified'] ?? false,
          'is_onboarding_complete': response['is_onboarding_complete'] ?? false,
          'verification_status': _getVerificationStatus(
            response['is_verified'] ?? false,
            response['is_onboarding_complete'] ?? false,
          ),
          'created_at': response['created_at'],
          'updated_at': response['updated_at'],
        };
        
        return VendorStatusModel.fromJson(statusData);
      }
      
      print('No vendor status found for auth user ID: $authUserId'); // Debug log
      return null;
    } catch (e) {
      print('Error in getVendorStatusByAuthId: $e'); // Debug log
      throw Exception('Failed to get vendor status: $e');
    }
  }

  Future<void> updateLastLogin(String vendorId) async {
    try {
      print('Updating last login for vendor: $vendorId'); // Debug log
      
      await _client
          .from(_tableName)
          .update({
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', vendorId);
      
      print('Last login updated successfully'); // Debug log
    } catch (e) {
      print('Error updating last login: $e'); // Debug log
      // Don't throw error for last login update failure
    }
  }

  String _getVerificationStatus(bool isVerified, bool isOnboardingComplete) {
    if (!isOnboardingComplete) {
      return 'incomplete';
    } else if (isVerified) {
      return 'approved';
    } else {
      return 'pending';
    }
  }
} 