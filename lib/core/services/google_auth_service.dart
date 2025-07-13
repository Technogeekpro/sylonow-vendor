import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  GoogleSignIn? _googleSignIn;

  void initialize() {
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      // This is the WEB Client ID, which is correct for Supabase integration
      serverClientId: '828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com',
    );
  }

  /// Initiates the Google Sign-In process and authenticates with Supabase.
  /// Returns the AuthResponse from Supabase if successful, otherwise null.
  /// Now includes app type to differentiate between vendor and customer apps.
  Future<AuthResponse?> signInWithGoogle({String appType = 'vendor'}) async {
    // Ensure service is initialized
    if (_googleSignIn == null) {
      initialize();
    }
    
    // 1. Trigger the Google Authentication flow.
    final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
    
    // If the user cancelled the sign-in, return null.
    if (googleUser == null) {
      print('🔵 Google Sign-In was cancelled by the user.');
      return null; 
    }

    // 2. Obtain the authentication details from the request.
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    // Throw an error if the ID token is missing.
    if (googleAuth.idToken == null) {
      throw 'Failed to get ID token from Google.';
    }

    // 3. Use the ID token to sign in to Supabase.
    final authResponse = await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );

    // 🔴 NEW: Create user profile with app type after successful Google sign-in
    if (authResponse.user != null) {
      await _createUserProfile(authResponse.user!.id, appType);
    }

    return authResponse;
  }

  /// Signs the user out from both Google and Supabase.
  Future<void> signOut() async {
    if (_googleSignIn == null) {
      initialize();
    }
    await _googleSignIn?.signOut();
    await Supabase.instance.client.auth.signOut();
  }

  // 🔴 NEW: Helper method to create user profile with app type
  Future<void> _createUserProfile(String userId, String appType) async {
    try {
      await SupabaseConfig.client.rpc('create_user_profile', params: {
        'user_id': userId,
        'app_type': appType,
      });
      
      print('🟢 User profile created with app type: $appType');
    } catch (e) {
      print('🔴 Failed to create user profile: $e');
      // Don't throw - this is not critical for auth flow
    }
  }

  bool get isSignedIn => SupabaseConfig.client.auth.currentUser != null;
  
  User? get currentUser => SupabaseConfig.client.auth.currentUser;
} 