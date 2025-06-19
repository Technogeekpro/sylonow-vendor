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
  Future<AuthResponse?> signInWithGoogle() async {
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
    return Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
  }

  /// Signs the user out from both Google and Supabase.
  Future<void> signOut() async {
    if (_googleSignIn == null) {
      initialize();
    }
    await _googleSignIn?.signOut();
    await Supabase.instance.client.auth.signOut();
  }

  bool get isSignedIn => SupabaseConfig.client.auth.currentUser != null;
  
  User? get currentUser => SupabaseConfig.client.auth.currentUser;
} 