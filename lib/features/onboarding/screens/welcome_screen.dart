import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/google_auth_service.dart';
import '../../../core/services/firebase_analytics_service.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isGoogleLoading = false;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();

    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAnalyticsService().logScreenView(screenName: 'welcome_screen');
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
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    if (!_termsAccepted) {
      _showTermsRequiredDialog();
      return;
    }

    setState(() => _isGoogleLoading = true);

    try {
      // Track sign-in attempt
      FirebaseAnalyticsService().logFeatureUsed(
        featureName: 'google_signin_button',
        screenName: 'welcome_screen',
      );

      final AuthResponse? response =
          await GoogleAuthService().signInWithGoogle(appType: 'vendor');

      if (response?.user != null && mounted) {
        print('🟢 Google Sign-In successful!');

        // Track successful login
        FirebaseAnalyticsService().logLogin(method: 'google');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 12),
                Text('Welcome, ${response!.user!.email ?? 'Vendor'}!'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Navigate to home after successful sign-in
        context.go('/');
      } else if (response == null) {
        // User cancelled the sign-in
        print('🔵 User cancelled Google Sign-In');
      }
    } catch (error) {
      print('🔴 Google Sign-In Error: $error');

      // Track sign-in error
      FirebaseAnalyticsService().logError(
        errorType: 'google_signin_failed',
        errorMessage: error.toString(),
        screenName: 'welcome_screen',
      );

      if (mounted) {
        String errorMessage = 'Google Sign-In failed';

        // Handle specific error types
        if (error.toString().contains('PlatformException')) {
          if (error.toString().contains('sign_in_failed') ||
              error.toString().contains('10')) {
            errorMessage =
                'Google Sign-In configuration issue. Please try phone verification.';
          } else if (error.toString().contains('network_error')) {
            errorMessage =
                'Network error. Please check your internet connection.';
          } else if (error.toString().contains('sign_in_canceled')) {
            errorMessage = 'Sign-in was cancelled.';
          }
        } else if (error.toString().contains('Failed to get ID token')) {
          errorMessage = 'Authentication failed. Please try again.';
        } else if (error is AuthException) {
          errorMessage = error.message;
          print('🔴 AuthException details: ${error.message}');
        } else if (error.toString().contains('Bad ID token')) {
          errorMessage =
              'Authentication configuration issue. Please try phone verification.';
          print('🔴 Bad ID token - likely client ID mismatch');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(errorMessage)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'You can continue with phone verification instead.',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Use Phone',
              textColor: Colors.white,
              onPressed: () {
                if (_termsAccepted) {
                  context.go('/phone');
                } else {
                  _showTermsRequiredDialog();
                }
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  void _showTermsRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms Required'),
        content:
            const Text('Please accept the terms and conditions to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(),
                // App Logo
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'assets/images/app_logo.png',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                 Text(
                  'Join the Vendor community and start earning from today',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400,)
                ),

                const Spacer(),

                // Terms and Conditions Checkbox
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: Colors.white,
                        checkColor: const Color(0xFF667eea),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/terms-conditions');
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                              children: [
                                const TextSpan(text: 'I accept the '),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                  // Phone Sign-In Button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _termsAccepted ? () {
                        // Track phone sign-in button click
                        FirebaseAnalyticsService().logFeatureUsed(
                          featureName: 'phone_signin_button',
                          screenName: 'welcome_screen',
                        );
                        context.go('/phone');
                      } : null,

                      
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                        disabledForegroundColor: Colors.grey,
                        disabledBackgroundColor: Colors.grey,
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),  
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: Colors.black),
                          SizedBox(width: 12),
                          Text(
                            'Continue with Phone',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                //Or Divider
                 Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Google Sign-In Button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _termsAccepted  ? (_isGoogleLoading ? null : _signInWithGoogle) : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        disabledForegroundColor: Colors.grey,
                        disabledBackgroundColor: Colors.grey,
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: _isGoogleLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF667eea)),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.asset(
                                    'assets/images/google_logo.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

              

                const SizedBox(height: 32),

                // Footer
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'By continuing, you agree to our',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/terms-conditions'),
                            child: Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/privacy-policy'),
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/revenue-policy'),
                            child: Text(
                              'Revenue Policy',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
