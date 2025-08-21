import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  /// Initializes the Google Sign-In service.
  Future<void> initialize() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize();
      _isInitialized = true;
    }
  }

  /// Initiates the Google Sign-In process and authenticates with Supabase.
  /// Returns the AuthResponse from Supabase if successful, otherwise null.
  /// Now includes app type to differentiate between vendor and customer apps.
  Future<AuthResponse?> signInWithGoogle({String appType = 'vendor'}) async {
    // Ensure service is initialized
    await initialize();
    
    try {
      // 1. Trigger the Google Authentication flow.
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      
      // If the user cancelled the sign-in, return null.
      if (googleUser == null) {
        print('🔵 Google Sign-In was cancelled by the user.');
        return null; 
      }

      // 2. Get authorization for required scopes
      const scopes = ['email', 'profile'];
      final authorization = await googleUser.authorizationClient.authorizationForScopes(scopes);
      
      if (authorization == null) {
        throw 'Failed to get authorization from Google.';
      }

      // 3. Get the access token from authorization
      final accessToken = authorization.accessToken;
      
      if (accessToken == null) {
        throw 'Failed to get access token from Google.';
      }

      // Use the access token for Supabase authentication
      final authResponse = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: accessToken,
        accessToken: accessToken,
      );

      // 🔴 NEW: Create user profile with app type after successful Google sign-in
      if (authResponse.user != null) {
        await _createUserProfile(authResponse.user!.id, appType);
      }

      return authResponse;
    } catch (e) {
      print('🔴 Google Sign-In error: $e');
      return null;
    }
  }

  /// Signs the user out from both Google and Supabase.
  Future<void> signOut() async {
    await initialize();
    await _googleSignIn.signOut();
    await Supabase.instance.client.auth.signOut();
  }

  // 🔴 NEW: Helper method to create user profile with app type
  Future<void> _createUserProfile(String userId, String appType) async {
    try {
      // Check if user profile already exists
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        // Create new user profile with app type
        await Supabase.instance.client.from('users').insert({
          'id': userId,
          'app_type': appType,
          'created_at': DateTime.now().toIso8601String(),
        });
        print('🟢 User profile created with app type: $appType');
      } else {
        print('🔵 User profile already exists');
      }
    } catch (e) {
      print('🔴 Error creating user profile: $e');
    }
  }
}