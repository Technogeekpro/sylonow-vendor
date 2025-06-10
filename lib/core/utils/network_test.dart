import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';

class NetworkTest {
  /// Test basic connectivity to Supabase
  static Future<bool> testSupabaseConnectivity() async {
    try {
      print('🔍 Testing Supabase connectivity...');
      
      // Test basic HTTP connectivity
      final response = await http.get(
        Uri.parse('https://bsxkxgtwxtggicjocqvp.supabase.co/rest/v1/'),
        headers: {
          'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJzeGt4Z3R3eHRnZ2ljam9jcXZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgwOTg3NzEsImV4cCI6MjA2MzY3NDc3MX0.tF41-kL97cw1EjRGaKLrR-c265Bsw5a-q7IurnVB6ok',
        },
      ).timeout(const Duration(seconds: 10));
      
      print('🟢 Supabase HTTP test successful: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 401; // 401 is expected without auth
    } catch (e) {
      print('🔴 Supabase connectivity test failed: $e');
      return false;
    }
  }
  
  /// Test Google services connectivity
  static Future<bool> testGoogleConnectivity() async {
    try {
      print('🔍 Testing Google connectivity...');
      
      final response = await http.get(
        Uri.parse('https://www.googleapis.com/'),
      ).timeout(const Duration(seconds: 10));
      
      print('🟢 Google connectivity test successful: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('🔴 Google connectivity test failed: $e');
      return false;
    }
  }
  
  /// Test general internet connectivity
  static Future<bool> testInternetConnectivity() async {
    try {
      print('🔍 Testing internet connectivity...');
      
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('🟢 Internet connectivity test successful');
        return true;
      }
      return false;
    } catch (e) {
      print('🔴 Internet connectivity test failed: $e');
      return false;
    }
  }
  
  /// Test Supabase authentication and storage access
  static Future<Map<String, dynamic>> testSupabaseAuth() async {
    try {
      print('🔍 Testing Supabase authentication and storage...');
      
      final client = SupabaseConfig.client;
      final user = client.auth.currentUser;
      final session = client.auth.currentSession;
      
      Map<String, dynamic> results = {
        'user_authenticated': user != null,
        'session_present': session != null,
        'session_expired': session?.isExpired ?? true,
        'user_id': user?.id,
        'user_email': user?.email ?? user?.phone,
      };
      
      if (user != null && session != null && !session.isExpired) {
        try {
          // Test storage bucket access
          final buckets = await client.storage.listBuckets();
          results['storage_access'] = true;
          results['available_buckets'] = buckets.map((b) => b.name).toList();
          
          // Test specific bucket access
          try {
            await client.storage.from('vendor-documents').list(path: user.id);
            results['vendor_documents_access'] = true;
          } catch (e) {
            results['vendor_documents_access'] = false;
            results['vendor_documents_error'] = e.toString();
          }
          
          try {
            await client.storage.from('profile-pictures').list(path: user.id);
            results['profile_pictures_access'] = true;
          } catch (e) {
            results['profile_pictures_access'] = false;
            results['profile_pictures_error'] = e.toString();
          }
          
        } catch (e) {
          results['storage_access'] = false;
          results['storage_error'] = e.toString();
        }
      }
      
      print('🟢 Supabase auth test completed');
      print('Results: $results');
      return results;
      
    } catch (e) {
      print('🔴 Supabase auth test failed: $e');
      return {
        'error': e.toString(),
        'user_authenticated': false,
        'session_present': false,
      };
    }
  }
  
  /// Run all connectivity tests
  static Future<Map<String, bool>> runAllTests() async {
    print('🔍 Running network connectivity tests...');
    
    final results = <String, bool>{};
    
    results['internet'] = await testInternetConnectivity();
    results['google'] = await testGoogleConnectivity();
    results['supabase'] = await testSupabaseConnectivity();
    
    print('🔍 Network test results:');
    results.forEach((test, success) {
      print('  $test: ${success ? "✅ PASS" : "❌ FAIL"}');
    });
    
    return results;
  }
  
  /// Comprehensive test including authentication
  static Future<Map<String, dynamic>> runComprehensiveTest() async {
    print('🔍 Running comprehensive Supabase tests...');
    
    final networkResults = await runAllTests();
    final authResults = await testSupabaseAuth();
    
    return {
      'network': networkResults,
      'authentication': authResults,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
} 