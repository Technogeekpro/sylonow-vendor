import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/firebase_analytics_service.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen>
    with TickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();

    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAnalyticsService().logScreenView(screenName: 'phone_screen');
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
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Track phone sign-in attempt
    FirebaseAnalyticsService().logFeatureUsed(
      featureName: 'phone_number_submit',
      screenName: 'phone_screen',
    );

    final result = await ref.read(onboardingProvider.notifier).signInWithMobile(
          "+91${_phoneController.text.trim()}",
        );

    if (!mounted) return;

    result.fold(
      (error) {
        // Track phone sign-in error
        FirebaseAnalyticsService().logError(
          errorType: 'phone_signin_failed',
          errorMessage: error,
          screenName: 'phone_screen',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      (_) {
        // Track successful OTP sent
        FirebaseAnalyticsService().logCustomEvent(
          eventName: 'otp_sent',
          parameters: {
            'method': 'phone',
            'screen_name': 'phone_screen',
          },
        );

        context.push('/verify-otp',
            extra: "+91${_phoneController.text.trim()}");
      },
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: const Text(
          'Enter your mobile number',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        leading: const BackButton(
          color: AppTheme.textPrimaryColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section

                _buildPhoneInput(),

                const SizedBox(height: 24),

                // Continue Button
                _buildContinueButton(),

                const SizedBox(height: 30),

                // Terms and Privacy
                const Spacer(),
                _buildTermsText(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your mobile number',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryColor,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'We\'ll send you a verification code to confirm your number',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text(
            'Mobile Number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: AppTheme.borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              // Country Code Section
              Row(
                children: [
                  SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset('assets/images/flag.png')),
                  const SizedBox(width: 8),
                  const Text(
                    '+91',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                height: 24,
                width: 1,
                color: AppTheme.borderColor,
              ),

              const SizedBox(width: 8),

              // Phone Number Input
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                  decoration: InputDecoration(
                    hintText: '9876543210',
                    fillColor: Colors.transparent,
                    hintStyle: const TextStyle(
                      color: AppTheme.textDisabledColor,
                      fontWeight: FontWeight.normal,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppTheme.primaryColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppTheme.errorColor, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppTheme.errorColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter only numbers';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppTheme.textOnPrimary,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: _isLoading
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
                      'Continue',
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
      ),
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: 'By continuing, you agree to our ',
              ),
              TextSpan(
                text: 'Terms of Service',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
