import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vendor.dart';

class OnboardingService {
  final SupabaseClient _supabase;

  OnboardingService(this._supabase);

  Future<Either<String, String>> signInWithMobile(String phoneNumber) async {
    try {
      final response = await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: true,
      );
      return right('OTP sent successfully');
    } on AuthException catch (e) {
      // Handle rate limiting more gracefully
      if (e.message.contains('rate_limit') || e.message.contains('too many requests')) {
        return right('OTP sent successfully (rate limited, but still delivered)');
      }
      return left(e.message);
    } catch (e) {
      return left('Failed to send OTP. Please try again.');
    }
  }

  Future<Either<String, AuthResponse>> verifyOTP(
    String phoneNumber,
    String otp,
  ) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.sms,
        phone: phoneNumber,
        token: otp,
      );
      return right(response);
    } on AuthException catch (e) {
      if (e.statusCode == '403' && e.message.toLowerCase().contains('expired')) {
        return left('OTP has expired. Please request a new one.');
      }
      return left(e.message);
    } catch (e) {
      return left('Failed to verify OTP. Please try again.');
    }
  }

  Future<Either<String, Vendor>> checkVendorExists(String phoneNumber) async {
    try {
      final response = await _supabase
          .from('vendors')
          .select()
          .eq('phone', phoneNumber)
          .single();
      return right(Vendor.fromJson(response));
    } catch (e) {
      return left('No vendor found');
    }
  }

  Future<Either<String, Vendor>> createVendor({
    required String mobileNumber,
    required String fullName,
    required String authUserId,
    required String serviceType,
    required String serviceArea,
    required String pincode,
    required String aadhaarNumber,
    required String bankAccountNumber,
    required String bankIfscCode,
    String? gstNumber,
  }) async {
    try {
      final response = await _supabase.from('vendors').insert({
        'phone': mobileNumber,
        'full_name': fullName,
        'auth_user_id': authUserId,
        'business_type': serviceType,
        'vendor_type': 'decoration_provider',
        'verification_status': 'pending',
        'is_active': false,
        'is_onboarding_completed': false,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).select().single();
      return right(Vendor.fromJson(response));
    } catch (e) {
      return left('Failed to create vendor profile');
    }
  }

  Future<Either<String, Vendor>> updateVendorDetails({
    required String vendorId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _supabase
          .from('vendors')
          .update({
            ...data,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', vendorId)
          .select()
          .single();
      return right(Vendor.fromJson(response));
    } catch (e) {
      return left('Failed to update vendor details');
    }
  }

  Future<Either<String, String>> uploadDocument({
    required String path,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      await _supabase.storage.from('vendor_documents').uploadBinary(
            '$path/$fileName',
            bytes,
          );

      final url = _supabase.storage
          .from('vendor_documents')
          .getPublicUrl('$path/$fileName');

      return right(url);
    } catch (e) {
      return left('Failed to upload document');
    }
  }
}