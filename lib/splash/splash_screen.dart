import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers/auth_provider.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/providers/vendor_provider.dart';
import '../features/onboarding/models/vendor.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    _slideController.forward();
  }

  void _navigateAfterDelay() async {
    print('🔵 Splash: Starting navigation delay...');
    await Future.delayed(const Duration(milliseconds: 3500));
    
    if (!mounted) return;
    
    print('🔵 Splash: Animation complete, waiting for providers to initialize...');
    
    // Wait a bit more for providers to fully initialize
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    print('🔵 Splash: Checking auth state...');
    
    // Add more debugging for auth state
    final authState = ref.read(authStateProvider);
    final currentUser = ref.read(currentUserProvider);
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    
    print('🔵 Splash: Auth state details:');
    print('  - Auth state: ${authState.hasValue ? authState.value?.event : 'loading/error'}');
    print('  - Current user: ${currentUser?.id ?? 'null'}');
    print('  - User email: ${currentUser?.email ?? 'null'}');
    print('  - Is authenticated: $isAuthenticated');
    
    // If auth state is still loading, wait a bit more
    if (!authState.hasValue) {
      print('🔵 Splash: Auth state still loading, waiting longer...');
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (!mounted) return;
      
      // Check again
      final isAuthenticatedRetry = ref.read(isAuthenticatedProvider);
      print('🔵 Splash: Auth state after wait: $isAuthenticatedRetry');
      
      if (!isAuthenticatedRetry) {
        print('🔵 Splash: User not authenticated after wait, navigating to welcome');
        context.go('/welcome');
        return;
      }
    } else if (!isAuthenticated) {
      print('🔵 Splash: User not authenticated, navigating to welcome');
      context.go('/welcome');
      return;
    }
    
    print('🔵 Splash: User is authenticated, actively waiting for vendor data...');
    
    // For authenticated users, actively wait for vendor data with multiple checks
    await _waitForVendorDataAndNavigate();
  }

  Future<void> _waitForVendorDataAndNavigate() async {
    int attempts = 0;
    const maxAttempts = 8; // Check every 500ms for up to 4 seconds
    bool hasTriggeredRefresh = false;
    
    while (attempts < maxAttempts && mounted) {
      attempts++;
      final vendorState = ref.read(vendorProvider);
      
      print('🔵 Splash: Vendor check attempt $attempts/$maxAttempts - State: ${vendorState.toString()}');
      
      // Check if we have actual vendor data (AsyncData with non-null value)
      if (vendorState is AsyncData<Vendor?> && vendorState.value != null) {
        final vendor = vendorState.value!;
        print('🟢 Splash: Vendor data found! ${vendor.fullName}');
        print('  - Onboarding complete: ${vendor.isOnboardingComplete}');
        print('  - Is verified: ${vendor.isVerified}');
        
        if (vendor.isOnboardingComplete == false) {
          print('🔵 Splash: Onboarding incomplete, navigating to onboarding');
          context.go('/vendor-onboarding');
        } else if (vendor.isVerified == false) {
          print('🔵 Splash: Vendor unverified, navigating to pending verification');
          context.go('/pending-verification');
        } else {
          print('🔵 Splash: Vendor verified, navigating to home');
          context.go('/home');
        }
        return;
      }
      
      // Check if we have AsyncData with null value (no vendor found)
      if (vendorState is AsyncData<Vendor?> && vendorState.value == null) {
        print('🔵 Splash: No vendor data found (AsyncData with null), navigating to onboarding');
        context.go('/vendor-onboarding');
        return;
      }
      
      // Check if vendor state has an error
      if (vendorState is AsyncError) {
        print('🔴 Splash: Vendor state error: ${vendorState.error}');
        context.go('/welcome');
        return;
      }
      
      // If we're in AsyncLoading state
      if (vendorState is AsyncLoading<Vendor?>) {
        print('🔵 Splash: Vendor data is loading...');
        
        // If we're still loading after 3 attempts and haven't triggered a refresh, try refreshing the provider
        if (attempts == 3 && !hasTriggeredRefresh) {
          print('🔄 Splash: Vendor still loading after 3 attempts, triggering provider refresh...');
          try {
            ref.read(vendorProvider.notifier).refreshVendor();
            hasTriggeredRefresh = true;
          } catch (e) {
            print('🔴 Splash: Error refreshing vendor provider: $e');
          }
        }
        
        // Wait before next attempt
        print('🔵 Splash: Waiting 500ms before next check...');
        await Future.delayed(const Duration(milliseconds: 500));
        continue; // Continue to next iteration
      }
      
      // If we reach here, we have an unexpected state
      print('🔴 Splash: Unexpected vendor state: ${vendorState.runtimeType}');
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    // If we've exhausted all attempts and still no data
    print('🔴 Splash: Timeout waiting for vendor data after ${maxAttempts * 500}ms');
    print('🔴 Splash: Defaulting to vendor onboarding for authenticated user');
    context.go('/vendor-onboarding');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              
              // Logo and Brand Section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container with Animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _logoAnimation,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // App Name with Slide Animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                          
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'VENDOR',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Loading Section
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Custom Loading Animation
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Stack(
                              children: [
                                // Outer ring
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                // Inner animated ring
                                const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Welcome to your business partner',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Loading your dashboard...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom spacing
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}