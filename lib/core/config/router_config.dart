import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:sylonow_vendor/features/service_listings/screens/add_service_screen.dart';
import 'package:sylonow_vendor/features/service_listings/screens/service_listings_screen.dart';
import 'package:sylonow_vendor/splash/splash_screen.dart';
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
        print('🔵 Router: Auth state changed, notifying listeners');
        notifyListeners();
      },
    );
    
    // Listen to vendor state changes  
    _ref.listen(
      vendorProvider,
      (previous, next) {
        print('🔵 Router: Vendor state changed, notifying listeners');
        notifyListeners();
      },
    );
  }
  
  final Ref _ref;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshStream = GoRouterRefreshStream(ref);
  
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final authState = ref.watch(authStateProvider);
      final vendorState = ref.watch(vendorProvider);
      final isAuthenticated = authState.valueOrNull?.session != null;

      final isGoingToSplash = state.matchedLocation == '/splash';
      final publicRoutes = ['/welcome', '/phone', '/verify-otp', '/cookies-policy', '/terms-conditions', '/revenue-policy', '/privacy-policy', '/debug-google'];
      final isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);

      // While providers are loading, stay on splash screen
      if (authState.isLoading || (isAuthenticated && vendorState.isLoading && !vendorState.hasValue)) {
        return isGoingToSplash ? null : '/splash';
      }

      // If user is not authenticated
      if (!isAuthenticated) {
        // Allow access to public routes, otherwise redirect to welcome
        return isGoingToPublicRoute ? null : '/welcome';
      }

      // From here, user is authenticated.

      // If there was an error loading vendor data, redirect to welcome
      if (vendorState.hasError) {
        return '/welcome';
      }

      // If we have vendor data, decide where to go
      if (vendorState.hasValue) {
        final vendor = vendorState.value;
        final isOnboardingComplete = vendor?.isOnboardingComplete ?? false;
        final isVerified = vendor?.isVerified ?? false;

        // If onboarding is not complete, redirect to onboarding screen
        if (!isOnboardingComplete) {
          return state.matchedLocation == '/vendor-onboarding' ? null : '/vendor-onboarding';
        }

        // If onboarding is complete but not verified, redirect to pending screen
        if (!isVerified) {
          return state.matchedLocation == '/pending-verification' ? null : '/pending-verification';
        }

        // If user is fully onboarded and verified, but tries to access splash/auth/onboarding routes, redirect to home
        if (isGoingToSplash || isGoingToPublicRoute || state.matchedLocation == '/vendor-onboarding' || state.matchedLocation == '/pending-verification') {
          return '/home';
        }
      }
      
      // In all other cases, allow navigation
      return null;
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
        path: '/debug-google',
        builder: (_, __) => const DebugGoogleAuthScreen(),
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
        path: '/support',
        builder: (_, __) =>const SupportScreen()
      ),
      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
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

