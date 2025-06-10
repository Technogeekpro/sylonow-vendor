import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static late final SupabaseClient client;
  
  static Future<void> initialize() async {
    try {
      print('Initializing Supabase...'); // Debug log
      await Supabase.initialize(
        url: 'https://bsxkxgtwxtggicjocqvp.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJzeGt4Z3R3eHRnZ2ljam9jcXZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgwOTg3NzEsImV4cCI6MjA2MzY3NDc3MX0.tF41-kL97cw1EjRGaKLrR-c265Bsw5a-q7IurnVB6ok',
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
 