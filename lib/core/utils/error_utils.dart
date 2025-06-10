import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorUtils {
  /// Converts technical error messages to user-friendly messages
  static String getOtpErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Twilio trial account error
    if (errorString.contains('trial accounts cannot send messages to unverified numbers') ||
        errorString.contains('sms_send_failed') ||
        errorString.contains('unverified')) {
      return 'Unable to send OTP to this number. Please contact support or try with a different number.';
    }
    
    // Rate limiting errors
    if (errorString.contains('rate limit') || 
        errorString.contains('too many requests') ||
        errorString.contains('429')) {
      return 'Too many OTP requests. Please wait a few minutes before trying again.';
    }
    
    // Invalid phone number
    if (errorString.contains('invalid phone') || 
        errorString.contains('invalid number') ||
        errorString.contains('phone number format')) {
      return 'Please enter a valid 10-digit mobile number.';
    }
    
    // Network/connectivity issues
    if (errorString.contains('network') || 
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return 'Network error. Please check your internet connection and try again.';
    }
    
    // OTP verification specific errors
    if (errorString.contains('invalid otp') || 
        errorString.contains('wrong code') ||
        errorString.contains('incorrect otp')) {
      return 'Invalid OTP. Please check the code and try again.';
    }
    
    if (errorString.contains('expired') || 
        errorString.contains('otp expired')) {
      return 'OTP has expired. Please request a new code.';
    }
    
    // Supabase Auth errors
    if (error is AuthException) {
      switch (error.statusCode) {
        case '400':
          return 'Invalid request. Please check your phone number and try again.';
        case '401':
          return 'Invalid OTP code. Please try again.';
        case '422':
          if (error.message.contains('unverified') || 
              error.message.contains('trial account')) {
            return 'This phone number cannot receive OTP messages. Please contact support or try with a different number.';
          }
          return 'Unable to process your request. Please try again.';
        case '429':
          return 'Too many attempts. Please wait a few minutes before trying again.';
        case '500':
          return 'Service temporarily unavailable. Please try again later.';
        default:
          return 'Unable to send OTP. Please try again or contact support.';
      }
    }
    
    // Generic fallback
    return 'Something went wrong. Please try again or contact support if the problem persists.';
  }
  
  /// Gets error message for general vendor-related operations
  static String getVendorErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || 
        errorString.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }
    
    if (errorString.contains('unauthorized') || 
        errorString.contains('permission denied')) {
      return 'Access denied. Please log in again.';
    }
    
    if (errorString.contains('not found')) {
      return 'Information not found. Please try again.';
    }
    
    return 'An error occurred. Please try again.';
  }
  
  /// Gets error message for file upload operations
  static String getUploadErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('file too large') || 
        errorString.contains('size limit')) {
      return 'File is too large. Please choose a smaller image.';
    }
    
    if (errorString.contains('invalid file type') || 
        errorString.contains('unsupported format')) {
      return 'Invalid file format. Please choose a JPG or PNG image.';
    }
    
    if (errorString.contains('network') || 
        errorString.contains('connection')) {
      return 'Upload failed due to network error. Please try again.';
    }
    
    return 'Failed to upload file. Please try again.';
  }
} 