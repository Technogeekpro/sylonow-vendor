import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static SupabaseClient? _client;
  static bool _isInitialized = false;
  
  static SupabaseClient get client {
    if (_client == null) {
      throw StateError(
        'SupabaseConfig has not been initialized. Call SupabaseConfig.initialize() first.',
      );
    }
    return _client!;
  }
  
  static bool get isInitialized => _isInitialized;
  
  // Debug method to test Supabase connection
  static Future<bool> testConnection() async {
    try {
      if (!_isInitialized) {
        print('🔴 Supabase not initialized');
        return false;
      }
      
      // Test a simple query to verify connection
      await _client!.from('vendors').select('count').limit(1);
      print('🟢 Supabase connection test successful');
      return true;
    } catch (e) {
      print('🔴 Supabase connection test failed: $e');
      return false;
    }
  }
  
  static Future<void> initialize() async {
    try {
      print('Initializing Supabase...'); // Debug log
      
      // Check if already initialized and working
      if (_isInitialized && _client != null) {
        print('Supabase already initialized, skipping...'); // Debug log
        return;
      }
      
      await Supabase.initialize(
        url: 'https://txgszrxjyanazlrupaty.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR4Z3N6cnhqeWFuYXpscnVwYXR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAyNzU4MjcsImV4cCI6MjA2NTg1MTgyN30.7MDiDGMCEa-E8c3HgIGxSpkOsH9kClD5i5LNSjzFul4',
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce, // Use PKCE flow instead of implicit for better Google integration
        ),
      );
      
      _client = Supabase.instance.client;
      _isInitialized = true;
      print('Supabase initialized successfully'); // Debug log
      
      // Listen for auth state changes
      _client!.auth.onAuthStateChange.listen((data) {
        print('Auth state changed:'); // Debug log
        print('- Event: ${data.event}'); // Debug log
        print('- Session: ${data.session?.user.email}'); // Debug log
      });
      
    } catch (error) {
      print('Error initializing Supabase: $error'); // Debug log
      _client = null;
      _isInitialized = false;
      rethrow;
    }
  }
  
  // Check if Supabase is actually working, not just initialized
  static Future<bool> isSupabaseWorking() async {
    try {
      if (!_isInitialized || _client == null) {
        return false;
      }
      
      // Test if we can access the client and make a simple query
      final client = _client!;
      await client.from('vendors').select('count').limit(1);
      return true;
    } catch (e) {
      print('🔴 Supabase not working: $e');
      return false;
    }
  }
  
  // Get client even if state says not initialized - sometimes Supabase.instance works
  static SupabaseClient? getClientSafely() {
    try {
      return Supabase.instance.client;
    } catch (e) {
      print('🔴 Cannot get Supabase client: $e');
      return null;
    }
  }
  
  // Force sync our internal state with actual Supabase state
  static Future<bool> syncState() async {
    try {
      print('🔄 Syncing Supabase state...');
      
      final client = getClientSafely();
      if (client != null) {
        _client = client;
        _isInitialized = true;
        
        // Test if it actually works
        final working = await isSupabaseWorking();
        if (working) {
          print('🟢 Supabase state synced successfully');
          return true;
        }
      }
      
      print('🔴 Supabase state sync failed');
      return false;
    } catch (e) {
      print('🔴 Error syncing Supabase state: $e');
      return false;
    }
  }
}
 