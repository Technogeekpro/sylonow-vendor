import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/theme/app_theme.dart';
import 'dart:convert';

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

  // Google Sign-In instance - serverClientId required for ID tokens
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Web client ID - Android client ID gives ApiException 10
    serverClientId: '828054656956-bnntihgtvfpm16vhc50gnippgpn2jqev.apps.googleusercontent.com',
    // Add nonce for better token validation
    forceCodeForRefreshToken: true,
  );

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
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
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
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
      print('🔵 Starting Google Sign-In process...');
      
      // Clear any existing sign-in state first
      await _googleSignIn.signOut();
      print('🔵 Cleared previous sign-in state');
      
      // Native Google Sign-In - shows account selection UI
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('🔵 Google user result: ${googleUser?.email}');
      
      if (googleUser == null) {
        // User cancelled the sign-in
        print('🔵 User cancelled sign-in');
        setState(() => _isGoogleLoading = false);
        return;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('🔵 Got authentication details');
      print('🔵 ID Token present: ${googleAuth.idToken != null}');
      print('🔵 Access Token present: ${googleAuth.accessToken != null}');
      
      if (googleAuth.idToken == null) {
        throw Exception('Failed to get ID token from Google');
      }

      print('🔵 Attempting Supabase authentication...');
      
      // Debug: Let's see exactly what's in the token
      try {
        final parts = googleAuth.idToken!.split('.');
        if (parts.length >= 2) {
          // Decode the payload (second part)
          String payload = parts[1];
          // Add padding if needed
          while (payload.length % 4 != 0) {
            payload += '=';
          }
          final decoded = utf8.decode(base64Url.decode(payload));
          print('🔍 FULL TOKEN PAYLOAD: $decoded');
          
          // Parse JSON to see specific fields
          final tokenData = jsonDecode(decoded);
          print('🔍 TOKEN ISSUER (iss): ${tokenData['iss']}');
          print('🔍 TOKEN AUDIENCE (aud): ${tokenData['aud']}');
          print('🔍 TOKEN AUTHORIZED PARTY (azp): ${tokenData['azp']}');
          print('🔍 TOKEN EMAIL: ${tokenData['email']}');
          print('🔍 TOKEN EXPIRY (exp): ${tokenData['exp']}');
          print('🔍 TOKEN ISSUED AT (iat): ${tokenData['iat']}');
        }
      } catch (e) {
        print('🔍 Token decode error: $e');
      }
      
      // Authenticate with Supabase using the Google ID token
      try {
        final AuthResponse response = await SupabaseConfig.client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          // Try without accessToken - sometimes causes validation issues
          // accessToken: googleAuth.accessToken,
        );
        
        print('🟢 Supabase auth successful: ${response.user?.email}');
        
        if (response.user != null && mounted) {
          print('🟢 Google Sign-In successful!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Text('Welcome, ${response.user!.email ?? 'Vendor'}!'),
                ],
              ),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          
          // Let the router handle navigation based on vendor status
          context.go('/');
        }
        
      } catch (e) {
        print('🔴 Primary auth method failed: $e');
        
        // Try alternative: Using signInWithOAuth instead
        try {
          print('🔄 Trying alternative OAuth method...');
          
          // Create a custom OAuth flow
          final response = await SupabaseConfig.client.auth.signInWithOAuth(
            OAuthProvider.google,
            redirectTo: 'com.example.sylonow_vendor://oauth',
          );
          
          print('🟢 Alternative method successful!');
          
        } catch (e2) {
          print('🔴 Alternative method also failed: $e2');
          throw e; // Throw original error
        }
      }

    } catch (error) {
      print('🔴 Google Sign-In Error: $error');
      print('🔴 Error type: ${error.runtimeType}');
      if (mounted) {
        String errorMessage = 'Google Sign-In failed';
        
        // Handle specific error types
        if (error.toString().contains('PlatformException')) {
          if (error.toString().contains('sign_in_failed') || error.toString().contains('10')) {
            errorMessage = 'Google Sign-In configuration issue. Please try phone verification.';
          } else if (error.toString().contains('network_error')) {
            errorMessage = 'Network error. Please check your internet connection.';
          } else if (error.toString().contains('sign_in_canceled')) {
            errorMessage = 'Sign-in was cancelled.';
          }
        } else if (error.toString().contains('Failed to get ID token')) {
          errorMessage = 'Authentication failed. Please try again.';
        } else if (error is AuthException) {
          errorMessage = error.message;
          print('🔴 AuthException details: ${error.message}');
        } else if (error.toString().contains('Bad ID token')) {
          errorMessage = 'Authentication configuration issue. Please try phone verification.';
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
                  context.push('/phone');
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
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppTheme.warningColor,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Terms Required',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          content: const Text(
            'You must accept the Terms & Conditions and Revenue Policy to continue with registration.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/terms-conditions');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Terms'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo and Brand Section
                    _buildBrandSection(),
                    
                    const SizedBox(height: 80),
                    
                    // Welcome Message
                    _buildWelcomeMessage(),
                    
                    const SizedBox(height: 60),
                    
                    // Authentication Buttons (now includes terms at bottom)
                    _buildAuthButtons(),
                    
                    const SizedBox(height: 24),
                    
                    // Additional Privacy Info
                    _buildPrivacyInfo(),
                    
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

  Widget _buildBrandSection() {
    return Column(
      children: [
        // Logo Container
       AspectRatio(aspectRatio: 1/0.4,child: Image.asset('assets/images/app_logo.png',width: 100,height: 100,)),
        
        const SizedBox(height: 24),
        
     
        
        const SizedBox(height: 8),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primarySurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'VENDOR PARTNER',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    return const Column(
      children: [
        Text(
          'Welcome to your\nbusiness journey',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryColor,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Join thousands of vendors and grow your business with us. Get started in just a few simple steps.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButtons() {
    return Column(
      children: [
        // Google Sign-In Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: (_isGoogleLoading || !_termsAccepted) ? null : _signInWithGoogle,
            style: ElevatedButton.styleFrom(
              backgroundColor: _termsAccepted ? AppTheme.surfaceColor : AppTheme.surfaceColor.withOpacity(0.5),
              foregroundColor: _termsAccepted ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
              elevation: _termsAccepted ? 2 : 0,
              shadowColor: AppTheme.shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: _termsAccepted ? AppTheme.borderColor : AppTheme.borderColor.withOpacity(0.5),
                ),
              ),
            ),
            child: _isGoogleLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppTheme.primaryColor,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://developers.google.com/identity/images/g-logo.png',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // OR Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.dividerColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.dividerColor,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Mobile Sign-In Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              gradient: _termsAccepted ? AppTheme.primaryGradient : LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.5),
                  AppTheme.primaryColor.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: _termsAccepted ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ] : [],
            ),
            child: ElevatedButton(
              onPressed: !_termsAccepted ? null : () {
                context.push('/phone');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppTheme.textOnPrimary,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.phone_android_rounded,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Continue with Mobile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Terms and Conditions Checkbox - Moved to bottom
        _buildTermsCheckbox(),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _termsAccepted ? AppTheme.primaryColor.withOpacity(0.3) : AppTheme.borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _termsAccepted = !_termsAccepted;
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _termsAccepted ? AppTheme.primaryColor : Colors.transparent,
                    border: Border.all(
                      color: _termsAccepted ? AppTheme.primaryColor : AppTheme.borderColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _termsAccepted
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.textPrimaryColor,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(
                            text: 'I agree to the ',
                          ),
                          WidgetSpan(


                            child: GestureDetector(
                              onTap: () => context.push('/terms-conditions'),
                              child: const Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => context.push('/revenue-policy'),
                              child: const Text(
                                'Revenue Policy',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '* Required to proceed with registration',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.errorColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
       
          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildPolicyButton(
          //         'Terms & Conditions',
          //         Icons.description_outlined,
          //         () => context.push('/terms-conditions'),
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: _buildPolicyButton(
          //         'Revenue Policy',
          //         Icons.account_balance_wallet_outlined,
          //         () => context.push('/revenue-policy'),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildPolicyButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.primarySurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: 'We protect your data and respect your ',
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => context.push('/privacy-policy'),
                    child: const Text(
                      'privacy',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => context.push('/privacy-policy'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => context.push('/cookies-policy'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cookie_outlined,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Cookies Policy',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 