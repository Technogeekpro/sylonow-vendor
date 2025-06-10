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
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      final vendorState = ref.read(vendorProvider);
      
      print('🔵 Router redirect - Location: ${state.matchedLocation}, Auth: $isAuthenticated');
      
      // Handle splash screen - always allow
      if (state.matchedLocation == '/' || state.matchedLocation == '/splash') {
        print('🔵 Router: Allowing access to splash screen');
        return null;
      }
      
      // Allow access to public routes when not authenticated
      if (!isAuthenticated) {
        print('🔵 Router: User not authenticated, checking route');
        if (['/welcome', '/phone', '/verify-otp', '/cookies-policy', '/terms-conditions', '/revenue-policy', '/privacy-policy'].contains(state.matchedLocation)) {
          print('🔵 Router: Allowing access to public route');
          return null;
        }
        print('🔵 Router: Redirecting to splash for auth check');
        return '/splash';
      }
      
      // User is authenticated - let them access protected routes
      // The splash screen handles the initial routing logic
      print('🔵 Router: User authenticated, allowing access to: ${state.matchedLocation}');
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

