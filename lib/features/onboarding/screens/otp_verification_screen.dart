import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controllers/otp_controller.dart';
import '../helpers/otp_helper.dart';
import '../../../core/config/supabase_config.dart';
import 'package:go_router/go_router.dart';
import '../providers/vendor_provider.dart';
import '../../../core/services/firebase_analytics_service.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    // Defer the initial OTP sending to avoid provider modification during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Track screen view
        FirebaseAnalyticsService()
            .logScreenView(screenName: 'otp_verification_screen');

        // Only send initial OTP if we're coming from phone screen
        // This prevents duplicate OTP requests when navigating back to this screen
        _sendInitialOtpSafely();
      }
    });
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _sendInitialOtp() async {
    await ref
        .read(otpControllerProvider.notifier)
        .sendInitialOtp(widget.phoneNumber);
  }

  Future<void> _sendInitialOtpSafely() async {
    try {
      // Check if OTP was already sent recently to prevent rate limiting
      final controller = ref.read(otpControllerProvider.notifier);
      final currentState = ref.read(otpControllerProvider);

      // If timer is still active from previous session, don't send again
      if (currentState.isTimerActive && currentState.remainingSeconds > 50) {
        print('🟡 OTP already sent recently, skipping initial send');
        return;
      }

      await controller.sendInitialOtp(widget.phoneNumber);
    } catch (e) {
      print('⚠️ Failed to send initial OTP safely: $e');
      // Don't show error to user for initial send failures
    }
  }

  Future<void> _verifyOtp() async {
    // Track OTP verification attempt
    FirebaseAnalyticsService().logFeatureUsed(
      featureName: 'otp_verification_submit',
      screenName: 'otp_verification_screen',
    );

    // Enhanced debugging for initialization issues
    print('🔍 OTP Verification Debug Info:');
    print('  - SupabaseConfig.isInitialized: ${SupabaseConfig.isInitialized}');
    
    // Check if Supabase is actually working
    final isWorking = await SupabaseConfig.isSupabaseWorking();
    print('  - SupabaseConfig.isSupabaseWorking: $isWorking');
    
    if (!isWorking) {
      print('🔴 Supabase not working - attempting state sync...');
      
      final syncSuccess = await SupabaseConfig.syncState();
      if (!syncSuccess) {
        print('❌ Supabase state sync failed');
        if (mounted) {
          OtpHelper.showErrorSnackBar(
            context, 
            'Authentication service is not available. Please restart the app and try again.'
          );
        }
        return;
      }
      print('🟢 Supabase state sync successful');
    }

    // Test Supabase connection
    print('🔍 Testing Supabase connection before OTP verification...');
    final connectionTest = await SupabaseConfig.testConnection();
    if (!connectionTest) {
      print('🔴 Connection test failed - checking client state...');
      try {
        final client = SupabaseConfig.client;
        print('  - Client available: ${client != null}');
        print('  - Auth available: ${client.auth != null}');
      } catch (e) {
        print('  - Error accessing client: $e');
      }
      
      if (mounted) {
        OtpHelper.showErrorSnackBar(
          context, 
          'Unable to connect to authentication service. Please check your internet connection and try again.'
        );
      }
      return;
    }
    print('🟢 Connection test passed, proceeding with OTP verification...');

    final controller = ref.read(otpControllerProvider.notifier);
    final isVerified = await controller.verifyOtp(widget.phoneNumber);

    if (isVerified && mounted) {
      try {
        // Check if user is authenticated
        final client = SupabaseConfig.client;
        final user = client.auth.currentUser;

      if (user != null) {
        // Track successful phone login
        FirebaseAnalyticsService().logLogin(method: 'phone');

        OtpHelper.showSuccessSnackBar(context, 'OTP verified successfully!');

        // Force refresh vendor data after successful login
        print('🔄 OTP Success: Refreshing vendor data...');
        try {
          // Use invalidate to trigger a complete rebuild of the vendor provider
          ref.invalidate(vendorProvider);

          // Wait a bit for the invalidation to take effect
          await Future.delayed(const Duration(milliseconds: 500));

          // Now manually refresh to ensure we get fresh data
          await ref.read(vendorProvider.notifier).refreshVendor();
          print('🟢 OTP Success: Vendor data refreshed');
        } catch (e) {
          print('⚠️ OTP Success: Failed to refresh vendor data: $e');
        }

        // Force navigation to trigger router redirect logic
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          context.go('/');
        }
      } else {
        // Track OTP verification failure
        FirebaseAnalyticsService().logError(
          errorType: 'otp_verification_auth_failed',
          errorMessage: 'Authentication failed after OTP verification',
          screenName: 'otp_verification_screen',
        );

        OtpHelper.showErrorSnackBar(
            context, 'Authentication failed. Please try again.');
      }
      } catch (e) {
        // Handle any remaining initialization errors
        print('❌ Error during OTP verification: $e');
        if (mounted) {
          OtpHelper.showErrorSnackBar(
            context, 
            'Authentication service error. Please restart the app and try again.'
          );
        }
      }
    }
  }

  Future<void> _resendOtp() async {
    // Track OTP resend
    FirebaseAnalyticsService().logFeatureUsed(
      featureName: 'otp_resend',
      screenName: 'otp_verification_screen',
    );

    // Enhanced debugging for initialization issues
    print('🔍 OTP Resend Debug Info:');
    print('  - SupabaseConfig.isInitialized: ${SupabaseConfig.isInitialized}');
    
    // Check if Supabase is actually working
    final isWorking = await SupabaseConfig.isSupabaseWorking();
    print('  - SupabaseConfig.isSupabaseWorking: $isWorking');
    
    if (!isWorking) {
      print('🔴 Supabase not working - attempting state sync...');
      
      final syncSuccess = await SupabaseConfig.syncState();
      if (!syncSuccess) {
        print('❌ Supabase state sync failed');
        if (mounted) {
          OtpHelper.showErrorSnackBar(
            context, 
            'Authentication service is not available. Please restart the app and try again.'
          );
        }
        return;
      }
      print('🟢 Supabase state sync successful');
    }

    try {
      final controller = ref.read(otpControllerProvider.notifier);
      await controller.resendOtp(widget.phoneNumber);

      final state = ref.read(otpControllerProvider);
      if (state.errorMessage == null && mounted) {
        OtpHelper.showSuccessSnackBar(
            context, 'OTP has been resent successfully!');
      }
    } catch (e) {
      print('❌ Error during OTP resend: $e');
      if (mounted) {
        OtpHelper.showErrorSnackBar(
          context, 
          'Failed to resend OTP. Please check your connection and try again.'
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpControllerProvider);

    // Listen for errors and show them
    ref.listen<OtpState>(otpControllerProvider, (previous, next) {
      if (next.errorMessage != null && mounted) {
        OtpHelper.showErrorSnackBar(context, next.errorMessage!);
        ref.read(otpControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: AutofillGroup(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 60),
                    _buildPhoneIllustration(),
                    const SizedBox(height: 40),
                    _buildTimerChip(otpState),
                    const SizedBox(height: 40),
                    _buildOtpInput(otpState),
                    const SizedBox(height: 32),
                    _buildResendButton(otpState),
                    const SizedBox(height: 40),
                    _buildVerifyButton(otpState),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Verify mobile number',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'We have sent a verification code to\n'),
              TextSpan(
                text: OtpHelper.maskPhoneNumber(widget.phoneNumber),
                style: const TextStyle(
                  color: Color(0xFFE91E63),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: '. Enter the code in below boxes'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneIllustration() {
    return SizedBox(
        width: 280,
        height: 280,
        child: Image.asset(
          'assets/images/hand_otp.png',
          fit: BoxFit.cover,
        ));
  }

  Widget _buildTimerChip(OtpState otpState) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: otpState.isTimerActive
            ? const Color(0xFFE91E63).withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: otpState.isTimerActive
              ? const Color(0xFFE91E63).withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color:
                otpState.isTimerActive ? const Color(0xFFE91E63) : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            otpState.isTimerActive
                ? '${OtpHelper.formatTime(otpState.remainingSeconds)} seconds'
                : 'Timer expired',
            style: TextStyle(
              fontSize: 16,
              color: otpState.isTimerActive
                  ? const Color(0xFFE91E63)
                  : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInput(OtpState otpState) {
    return SizedBox(
      width: double.infinity,
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(16),
          fieldHeight: 60,
          fieldWidth: 50,
          borderWidth: 2,
          activeColor: const Color(0xFFE91E63),
          inactiveColor: Colors.grey.shade300,
          selectedColor: const Color(0xFFE91E63),
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedFillColor: const Color(0xFFE91E63).withOpacity(0.1),
        ),
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        cursorColor: const Color(0xFFE91E63),
        keyboardType: TextInputType.number,
        // Enable OTP autofill
        enablePinAutofill: true,
        autoFocus: true,
        // Configure text input for SMS autofill
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        onChanged: (value) {
          ref.read(otpControllerProvider.notifier).updateOtp(value);
          // Auto-verify when 6 digits are entered via autofill
          if (value.length == 6) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted && value.length == 6) {
                _verifyOtp();
              }
            });
          }
        },
        onCompleted: (pin) => _verifyOtp(),
        beforeTextPaste: (text) {
          // Allow pasting numeric values only and auto-extract OTP from SMS
          if (text != null) {
            // Extract 6-digit number from SMS text
            final otpMatch = RegExp(r'\b\d{6}\b').firstMatch(text);
            if (otpMatch != null) {
              final extractedOtp = otpMatch.group(0)!;
              // Update the OTP in controller
              ref.read(otpControllerProvider.notifier).updateOtp(extractedOtp);
              return true;
            }
            // Fallback to digits only
            final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
            return digitsOnly.length <= 6;
          }
          return false;
        },
      ),
    );
  }

  Widget _buildResendButton(OtpState otpState) {
    return TextButton(
      onPressed: otpState.isTimerActive ? null : _resendOtp,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Resend OTP',
        style: TextStyle(
          fontSize: 16,
          color: otpState.isTimerActive ? Colors.grey : const Color(0xFFE91E63),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVerifyButton(OtpState otpState) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: otpState.isLoading ? null : _verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE91E63),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: const Color(0xFFE91E63).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: otpState.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Verify & Proceed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
