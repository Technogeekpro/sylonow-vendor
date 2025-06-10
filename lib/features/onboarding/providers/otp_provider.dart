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

      // Format phone number consistently
      final formattedPhone =
          phoneNumber.startsWith('+91') ? phoneNumber : '+91$phoneNumber';

      final client = SupabaseConfig.client;
      final response = await client.auth.verifyOTP(
        phone: formattedPhone,
        token: otp,
        type: OtpType.sms,
      );
      state = const AsyncValue.data(null);
      return response.session != null;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    try {
      state = const AsyncValue.loading();

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
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}
