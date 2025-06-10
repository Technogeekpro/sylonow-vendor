import 'package:flutter/material.dart';

class OtpHelper {
  static String formatTime(int remainingSeconds) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length >= 4) {
      final lastFour = phoneNumber.substring(phoneNumber.length - 4);
      return '****$lastFour';
    }
    return phoneNumber;
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Remove any existing +91 prefix
    final cleanNumber = phoneNumber.replaceAll('+91', '').trim();
    // Add +91 prefix if not present
    return '+91$cleanNumber';
  }

  static bool isValidOtp(String otp) {
    return otp.length == 6 && int.tryParse(otp) != null;
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
} 