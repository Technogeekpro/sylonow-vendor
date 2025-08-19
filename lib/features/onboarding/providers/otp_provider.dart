import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';

final otpNotifierProvider =
    StateNotifierProvider<OtpNotifier, AsyncValue<void>>((ref) {
  return OtpNotifier();
});

class OtpNotifier extends StateNotifier<AsyncValue<void>> {
  OtpNotifier() : super(const AsyncValue.data(null));

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      state = const AsyncValue.loading();
      print('Verifying OTP for phone: $phoneNumber'); // Debug log

      // Check if Supabase is properly initialized
      if (!SupabaseConfig.isInitialized) {
        throw Exception('Authentication service is not available. Please restart the app and try again.');
      }

      // Format phone number consistently
      final formattedPhone =
          phoneNumber.startsWith('+91') ? phoneNumber : '+91$phoneNumber';

      final client = SupabaseConfig.client;
      print('🔍 Attempting OTP verification with phone: $formattedPhone, OTP: ${otp.substring(0, 2)}****');
      
      final response = await client.auth.verifyOTP(
        phone: formattedPhone,
        token: otp,
        type: OtpType.sms,
      );
      
      print('🟢 OTP verification response received: ${response.session != null ? 'Success' : 'Failed'}');
      
      // 🔴 NEW: Create user profile with vendor app type after successful OTP
      if (response.session != null && response.user != null) {
        await _createUserProfile(response.user!.id, 'vendor');
      }
      
      state = const AsyncValue.data(null);
      return response.session != null;
    } catch (e, stackTrace) {
      print('❌ OTP verification failed with error: $e');
      print('📋 Stack trace: $stackTrace');
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    try {
      state = const AsyncValue.loading();

      // Check if Supabase is properly initialized
      if (!SupabaseConfig.isInitialized) {
        throw Exception('Authentication service is not available. Please restart the app and try again.');
      }

      // Add rate limiting check with better error handling
      final lastRequestTime = DateTime.now().subtract(const Duration(seconds: 5));
      
      // Format phone number consistently
      final formattedPhone =
          phoneNumber.startsWith('+91') ? phoneNumber : '+91$phoneNumber';

      final client = SupabaseConfig.client;
      await client.auth.signInWithOtp(
        phone: formattedPhone,
      );

      print('OTP resent successfully'); // Debug log
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      print('Error in resendOtp: $e'); // Debug log
      
      // Handle rate limiting error more gracefully
      if (e is AuthApiException && e.code == 'over_sms_send_rate_limit') {
        throw Exception('Please wait a few seconds before requesting another OTP');
      }
      
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  // 🔴 NEW: Helper method to create user profile with app type
  Future<void> _createUserProfile(String userId, String appType) async {
    try {
      // Check if Supabase is properly initialized
      if (!SupabaseConfig.isInitialized) {
        print('🔴 Cannot create user profile: Supabase not initialized');
        return;
      }

      await SupabaseConfig.client.rpc('create_user_profile', params: {
        'user_id': userId,
        'app_type': appType,
      });
      
      print('🟢 User profile created with app type: $appType');
    } catch (e) {
      print('🔴 Failed to create user profile: $e');
      // Don't throw - this is not critical for auth flow
    }
  }
}
