import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../providers/otp_provider.dart';
import '../helpers/otp_helper.dart';

final otpControllerProvider = StateNotifierProvider<OtpController, OtpState>((ref) {
  return OtpController(ref);
});

class OtpState {
  final String otp;
  final int remainingSeconds;
  final bool isLoading;
  final bool isTimerActive;
  final String? errorMessage;

  const OtpState({
    this.otp = '',
    this.remainingSeconds = 60,
    this.isLoading = false,
    this.isTimerActive = true,
    this.errorMessage,
  });

  OtpState copyWith({
    String? otp,
    int? remainingSeconds,
    bool? isLoading,
    bool? isTimerActive,
    String? errorMessage,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isLoading: isLoading ?? this.isLoading,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      errorMessage: errorMessage,
    );
  }
}

class OtpController extends StateNotifier<OtpState> {
  final Ref ref;
  Timer? _timer;

  OtpController(this.ref) : super(const OtpState()) {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp, errorMessage: null);
  }

  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(remainingSeconds: 60, isTimerActive: true);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        timer.cancel();
        state = state.copyWith(isTimerActive: false);
      }
    });
  }

  Future<void> sendInitialOtp(String phoneNumber) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await ref.read(otpNotifierProvider.notifier).resendOtp(
        OtpHelper.formatPhoneNumber(phoneNumber),
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send OTP: $e',
      );
    }
  }

  Future<bool> verifyOtp(String phoneNumber) async {
    if (!OtpHelper.isValidOtp(state.otp)) {
      state = state.copyWith(errorMessage: 'Please enter a valid 6-digit OTP');
      return false;
    }

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final otpNotifier = ref.read(otpNotifierProvider.notifier);
      final formattedPhone = OtpHelper.formatPhoneNumber(phoneNumber);
      
      final isVerified = await otpNotifier.verifyOtp(
        phoneNumber: formattedPhone,
        otp: state.otp,
      );

      state = state.copyWith(isLoading: false);
      
      if (!isVerified) {
        state = state.copyWith(errorMessage: 'Invalid OTP. Please try again.');
      }
      
      return isVerified;
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
      return false;
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    if (state.isTimerActive) {
      state = state.copyWith(
        errorMessage: 'Please wait ${state.remainingSeconds} seconds before requesting a new OTP',
      );
      return;
    }

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      await ref.read(otpNotifierProvider.notifier).resendOtp(
        OtpHelper.formatPhoneNumber(phoneNumber),
      );
      
      _startTimer();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to resend OTP: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
} 