import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_vendor/core/config/supabase_config.dart';
import 'package:sylonow_vendor/features/onboarding/providers/vendor_provider.dart';
import 'package:sylonow_vendor/features/onboarding/screens/otp_verification_screen.dart';
import 'package:sylonow_vendor/features/onboarding/screens/phone_screen.dart';
import 'package:sylonow_vendor/features/onboarding/screens/pending_verification_screen.dart';
import 'package:sylonow_vendor/features/onboarding/screens/vendor_onboarding_screen.dart';
import 'package:sylonow_vendor/features/onboarding/screens/cookies_policy_screen.dart';
import 'package:sylonow_vendor/features/onboarding/screens/terms_conditions_screen.dart';
import 'package:sylonow_vendor/features/onboarding/screens/revenue_policy_screen.dart';
import 'package:sylonow_vendor/features/onboarding/screens/privacy_policy_screen.dart';
import 'package:sylonow_vendor/features/onboarding/screens/debug_google_auth_screen.dart';
import 'package:sylonow_vendor/features/orders/screens/orders_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/profile_screen.dart';
import 'package:sylonow_vendor/features/support/screens/support_screen.dart';
import 'package:sylonow_vendor/features/wallet/screens/wallet_screen.dart';
import 'package:sylonow_vendor/features/wallet/screens/withdrawal_screen.dart';
import 'package:sylonow_vendor/features/service_listings/screens/add_service_screen.dart';
import 'package:sylonow_vendor/features/service_listings/screens/service_listings_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/edit_profile_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/business_details_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/payment_settings_screen.dart';
import 'package:sylonow_vendor/features/splash/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/home/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

// Router refresh notifier for handling state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this._ref) {
    // Listen to auth state changes
    _ref.listen(
      authStateProvider,
      (previous, next) {
        notifyListeners();
      },
    );
    
    // Listen to vendor state changes  
    _ref.listen(
      vendorProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }
  
  final Ref _ref;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshStream = GoRouterRefreshStream(ref);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final authState = ref.watch(authStateProvider);
      final vendorState = ref.watch(vendorProvider);
      final isAuthenticated = authState.valueOrNull?.session != null;

      final isGoingToSplash = state.matchedLocation == '/splash' || state.matchedLocation == '/';
      final publicRoutes = ['/welcome', '/phone', '/verify-otp', '/cookies-policy', '/terms-conditions', '/revenue-policy', '/privacy-policy'];
      final isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);

      // Debug logging (essential only)
      if (kDebugMode && state.matchedLocation != '/splash' && state.matchedLocation != '/') {
        print('🔍 Router: ${state.matchedLocation} | Auth: ${isAuthenticated ? 'OK' : 'NO'} | Vendor: ${vendorState.hasValue ? 'OK' : (vendorState.isLoading ? 'LOADING' : 'NO')}');
        if (vendorState.hasValue && vendorState.value != null) {
          final vendor = vendorState.value!;
          print('🔍 Router: Vendor details - Onboarding: ${vendor.isOnboardingComplete}, Verified: ${vendor.isVerified}');
        }
      }
      
      // ALWAYS stay on splash if auth is loading
      if (authState.isLoading) {
        return isGoingToSplash ? null : '/splash';
      }

      // If user is not authenticated, allow public routes or redirect to welcome
      if (!isAuthenticated) {
        return isGoingToPublicRoute ? null : '/welcome';
      }

      // User is authenticated - now check vendor data
      
      // CRITICAL: Stay on splash if vendor data is still loading OR if we don't have vendor data yet
      // This prevents the brief flash of vendor onboarding screen during hot restart
      if (vendorState.isLoading || (!vendorState.hasValue && !vendorState.hasError)) {
        return isGoingToSplash ? null : '/splash';
      }

      // If vendor data failed to load, sign out and go to welcome
      if (vendorState.hasError) {
        unawaited(SupabaseConfig.client.auth.signOut());
        return '/welcome';
      }

      // At this point, we definitely have vendor data (or confirmed there is none)
      if (vendorState.hasValue && vendorState.value != null) {
        final vendor = vendorState.value!;
        final isOnboardingComplete = vendor.isOnboardingComplete;
        final isVerified = vendor.isVerified;

        // Redirect based on vendor status
        if (!isOnboardingComplete) {
          return state.matchedLocation == '/vendor-onboarding' ? null : '/vendor-onboarding';
        }
        
        if (!isVerified) {
          return state.matchedLocation == '/pending-verification' ? null : '/pending-verification';
        }

        // User is fully verified - redirect away from auth/splash screens to home
        if (isGoingToSplash || isGoingToPublicRoute || 
            state.matchedLocation == '/vendor-onboarding' || 
            state.matchedLocation == '/pending-verification') {
          return '/home';
        }

        // Allow navigation to other protected routes
        return null;
      }

      // No vendor data available (confirmed) - redirect to onboarding
      return state.matchedLocation == '/vendor-onboarding' ? null : '/vendor-onboarding';
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Public routes (no auth required)
      GoRoute(
        path: '/welcome', 
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/cookies-policy',
        builder: (_, __) => const CookiesPolicyScreen(),
      ),
      GoRoute(
        path: '/terms-conditions',
        builder: (_, __) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: '/revenue-policy',
        builder: (_, __) => const RevenuePolicyScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (_, __) => const PrivacyPolicyScreen(),
      ),

      GoRoute(
        path: '/phone', 
        builder: (_, __) => const PhoneScreen(),
      ),
      GoRoute(
        path: '/verify-otp', 
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return OtpVerificationScreen(phoneNumber: phoneNumber);
        },
      ),
      
      // Protected routes (auth required)
      GoRoute(
        path: '/vendor-onboarding', 
        builder: (_, __) => const VendorOnboardingScreen(),
      ),
      GoRoute(
        path: '/pending-verification', 
        builder: (_, __) => const PendingVerificationScreen(),
      ),
      GoRoute(
        path: '/home', 
        builder: (_, __) => const HomeScreen(),
      ),
      
      // Additional protected routes
      GoRoute(
        path: '/orders',
          builder: (_, __) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (_, __) => const WalletScreen(),
      ),
      GoRoute(
        path: '/wallet/withdraw',
        builder: (_, __) => const WithdrawalScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (_, __) =>const SupportScreen()
      ),
      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/business-details',
        builder: (_, __) => const BusinessDetailsScreen(),
      ),
      GoRoute(
        path: '/payment-settings',
        builder: (_, __) => const PaymentSettingsScreen(),
      ),
      GoRoute(
        path: '/add-service',
        builder: (_, __) => const AddServiceScreen(),
      ),
      GoRoute(
        path: '/service-listings',
        builder: (_, __) => const ServiceListingsScreen(),
      ),
    ],
  );
});

