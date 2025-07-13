import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import '../config/supabase_config.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  print('🔵 AuthStateProvider: Setting up auth state stream...');
  
  final controller = StreamController<AuthState>();
  
  // Get the initial session and emit it immediately
  final currentSession = SupabaseConfig.client.auth.currentSession;
  print('🔵 AuthStateProvider: Initial session check - ${currentSession?.user.id ?? 'null'}');
  
  if (currentSession != null) {
    controller.add(AuthState(AuthChangeEvent.signedIn, currentSession));
  } else {
    controller.add(const AuthState(AuthChangeEvent.signedOut, null));
  }
  
  // Listen to auth state changes and forward them
  final subscription = SupabaseConfig.client.auth.onAuthStateChange.listen((authState) {
    print('🔵 AuthStateProvider: Auth state changed - Event: ${authState.event}, User: ${authState.session?.user.id ?? 'null'}');
    controller.add(authState);
  });
  
  // Clean up when provider is disposed
  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });
  
  return controller.stream;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) {
      final user = state.session?.user;
      print('🔵 CurrentUserProvider: Current user - ${user?.id ?? 'null'}');
      return user;
    },
    loading: () {
      print('🔵 CurrentUserProvider: Auth state loading...');
      return null;
    },
    error: (error, stack) {
      print('🔴 CurrentUserProvider: Auth state error - $error');
      return null;
    },
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  final isAuth = user != null;
  print('🔵 IsAuthenticatedProvider: Authentication status - $isAuth');
  return isAuth;
}); 

// Check whether user is verified and onboarding is complete
class VendorStatusProvider extends ChangeNotifier {
  final client = SupabaseConfig.client;
  bool _isVendorVerified = false;
  bool _isOnboardingComplete = false;

  bool get isVendorVerified => _isVendorVerified;
  bool get isOnboardingComplete => _isOnboardingComplete;

  void checkVendorStatus(ref) async {
    final user = ref.watch(currentUserProvider);
    if (user != null) {
      final vendor = await client.from('vendors').select('is_verified, is_onboarding_complete').eq('auth_user_id', user.id).single();
      _isVendorVerified = vendor['is_verified'];
      _isOnboardingComplete = vendor['is_onboarding_complete'];
    }
  }
}

final vendorStatusProvider = ChangeNotifierProvider<VendorStatusProvider>((ref) {
  return VendorStatusProvider();
});
