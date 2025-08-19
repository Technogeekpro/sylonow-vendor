import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:sylonow_vendor/core/config/supabase_config.dart';
import 'package:sylonow_vendor/core/services/firebase_analytics_service.dart';
import 'package:sylonow_vendor/features/addons/screens/addons_list_screen.dart';
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
import 'package:sylonow_vendor/features/service_listings/screens/add_service_screen.dart';
import 'package:sylonow_vendor/features/service_listings/screens/service_listings_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/add_theater_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/simple_add_theater_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/theater_bookings_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/theater_booking_detail_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/themed_add_theater_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/manage_screens_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/theater_list_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/vendor_theaters_screen.dart';
import 'package:sylonow_vendor/features/theaters/screens/theater_screens_management.dart';
import 'package:sylonow_vendor/features/theaters/screens/qr_scanner_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/edit_profile_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/business_details_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/payment_settings_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/edit_bank_details_screen.dart';
import 'package:sylonow_vendor/features/profile/screens/app_info_screen.dart';
import 'package:sylonow_vendor/features/notifications/screens/notifications_screen.dart';
import 'package:sylonow_vendor/features/splash/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/theaters/screens/theater_dashboard_screen.dart';
import '../../features/dashboard/screens/booking_details_screen.dart';
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
    observers: [
      if (FirebaseAnalyticsService().observer != null)
        FirebaseAnalyticsService().observer!,
    ],
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
          print('🔍 Router: Vendor details - ID: ${vendor.id?.substring(0, 8) ?? 'null'}, Onboarding: ${vendor.isOnboardingComplete}, Verified: ${vendor.isVerified}, Type: ${vendor.vendorType}');
        } else if (vendorState.hasError) {
          print('🔍 Router: Vendor error: ${vendorState.error}');
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

        if (kDebugMode) {
          print('🔍 Router: Processing vendor - Onboarding: $isOnboardingComplete, Verified: $isVerified, Type: ${vendor.vendorType}');
        }

        // Redirect based on vendor status
        if (!isOnboardingComplete) {
          if (kDebugMode) print('🔀 Router: Redirecting to onboarding (incomplete)');
          return state.matchedLocation == '/vendor-onboarding' ? null : '/vendor-onboarding';
        }
        
        if (!isVerified) {
          if (kDebugMode) print('🔀 Router: Redirecting to pending verification (unverified)');
          return state.matchedLocation == '/pending-verification' ? null : '/pending-verification';
        }

        // User is fully verified - redirect away from auth/splash screens to appropriate dashboard
        if (isGoingToSplash || isGoingToPublicRoute || 
            state.matchedLocation == '/vendor-onboarding' || 
            state.matchedLocation == '/pending-verification') {
          // Redirect based on vendor type
          final destination = vendor.isTheaterProvider ? '/theater-dashboard' : '/home';
          if (kDebugMode) print('🔀 Router: Redirecting verified vendor to $destination');
          return destination;
        }

        // Allow navigation to other protected routes
        if (kDebugMode) print('🔀 Router: Allowing navigation to ${state.matchedLocation}');
        return null;
      }

      // No vendor data available (confirmed) - redirect to onboarding
      if (kDebugMode) print('🔀 Router: No vendor data found, redirecting to onboarding');
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
      GoRoute(
        path: '/theater-dashboard', 
        builder: (_, __) => const TheaterDashboardScreen(),
      ),

      //Theater Bookings screen
      GoRoute(
        path: '/theater-bookings', 
        builder: (_, __) => const TheaterBookingsScreen(),
      ),
      
      // Theater Booking Detail screen
      GoRoute(
        path: '/theater-booking-detail/:bookingId',
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId']!;
          return TheaterBookingDetailScreen(bookingId: bookingId);
        },
      ),
      
      // QR Scanner screen
      GoRoute(
        path: '/qr-scanner/:bookingId',
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId']!;
          return QRScannerScreen(bookingId: bookingId);
        },
      ),


      
      // Additional protected routes
      GoRoute(
        path: '/orders',
          builder: (_, __) => const OrdersScreen(),
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
        path: '/notifications',
        builder: (_, __) => const NotificationsScreen(),
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
        path: '/edit-bank-details',
        builder: (_, __) => const EditBankDetailsScreen(),
      ),
      GoRoute(
        path: '/app-info',
        builder: (_, __) => const AppInfoScreen(),
      ),
      GoRoute(
        path: '/add-service',
        builder: (_, __) => const AddServiceScreen(),
      ),
      GoRoute(
        path: '/add-theater',
        builder: (_, __) => const AddTheaterScreen(),
      ),
      GoRoute(
        path: '/simple-add-theater',
        builder: (_, __) => const SimpleAddTheaterScreen(),
      ),
      GoRoute(
        path: '/themed-add-theater',
        builder: (_, __) => const ThemedAddTheaterScreen(),
      ),
      GoRoute(
        path: '/theater-list',
        builder: (_, __) => const TheaterListScreen(),
      ),
      GoRoute(
        path: '/vendor-theaters',
        builder: (_, __) => const VendorTheatersScreen(),
      ),
      GoRoute(
        path: '/theater/:theaterId/screens',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          return TheaterScreensManagement(theaterId: theaterId);
        },
      ),
      GoRoute(
        path: '/manage-screens/:theaterId',
        builder: (context, state) {
          final theaterId = state.pathParameters['theaterId']!;
          return ManageScreensScreen(theaterId: theaterId);
        },
      ),
      GoRoute(
        path: '/addons',
        builder: (_, __) => const AddonsListScreen(),
      ),
      GoRoute(
        path: '/service-listings',
        builder: (_, __) => const ServiceListingsScreen(),
      ),
      GoRoute(
        path: '/booking-details/:bookingId',
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId']!;
          return BookingDetailsScreen(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: '/order-details/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return BookingDetailsScreen(bookingId: orderId);
        },
      ),
      
      // Legal document routes (protected - accessible when authenticated)
      GoRoute(
        path: '/legal/privacy-policy',
        builder: (_, __) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/legal/terms-conditions',
        builder: (_, __) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: '/legal/revenue-policy',
        builder: (_, __) => const RevenuePolicyScreen(),
      ),
    ],
  );
});

