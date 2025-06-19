import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static late final SupabaseClient client;
  
  static Future<void> initialize() async {
    try {
      print('Initializing Supabase...'); // Debug log
      await Supabase.initialize(
        url: 'https://txgszrxjyanazlrupaty.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR4Z3N6cnhqeWFuYXpscnVwYXR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAyNzU4MjcsImV4cCI6MjA2NTg1MTgyN30.7MDiDGMCEa-E8c3HgIGxSpkOsH9kClD5i5LNSjzFul4',
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce, // Use PKCE flow instead of implicit for better Google integration
        ),
      );
      
      client = Supabase.instance.client;
      print('Supabase initialized successfully'); // Debug log
      
      // Listen for auth state changes
      client.auth.onAuthStateChange.listen((data) {
        print('Auth state changed:'); // Debug log
        print('- Event: ${data.event}'); // Debug log
        print('- Session: ${data.session?.user.email}'); // Debug log
      });
      
    } catch (error) {
      print('Error initializing Supabase: $error'); // Debug log
      rethrow;
    }
  }
}
 