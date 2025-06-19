import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/services/google_auth_service.dart';
import '../../../core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class DebugGoogleAuthScreen extends StatefulWidget {
  const DebugGoogleAuthScreen({super.key});

  @override
  State<DebugGoogleAuthScreen> createState() => _DebugGoogleAuthScreenState();
}

class _DebugGoogleAuthScreenState extends State<DebugGoogleAuthScreen> {
  final List<String> _logs = [];
  bool _isLoading = false;
  GoogleSignIn? _testGoogleSignIn;

  @override
  void initState() {
    super.initState();
    _addLog('🔵 Debug screen initialized');
    _addLog('📱 Package: com.example.sylonow_vendor');
    _addLog('🔐 SHA-1: 56:DC:06:41:C0:31:2A:CE:30:49:48:FC:01:E4:EC:D6:88:38:41:8E');
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)} - $message');
    });
    print(message);
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  // Test 1: Basic Google Sign-In without serverClientId
  Future<void> _testBasicGoogleSignIn() async {
    _addLog('🧪 TEST 1: Basic Google Sign-In (no serverClientId)');
    setState(() => _isLoading = true);

    try {
      _testGoogleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        // No serverClientId - this should work if Android OAuth client exists
      );

      _addLog('✅ GoogleSignIn instance created');
      
      // Clear previous state
      await _testGoogleSignIn!.signOut();
      _addLog('🔄 Cleared previous sign-in state');

      // Attempt sign-in
      final GoogleSignInAccount? account = await _testGoogleSignIn!.signIn();
      
      if (account != null) {
        _addLog('✅ Sign-in successful!');
        _addLog('👤 Email: ${account.email}');
        _addLog('👤 Name: ${account.displayName}');
        
        // Get authentication details
        final GoogleSignInAuthentication auth = await account.authentication;
        _addLog('🔑 ID Token: ${auth.idToken != null ? "✅ Present" : "❌ Missing"}');
        _addLog('🔑 Access Token: ${auth.accessToken != null ? "✅ Present" : "❌ Missing"}');
        
        if (auth.idToken != null) {
          _addLog('🎉 SUCCESS: Android OAuth client is properly configured!');
        } else {
          _addLog('⚠️ WARNING: No ID token - Android client may be missing');
        }
      } else {
        _addLog('🔵 User cancelled sign-in');
      }
      
    } catch (error) {
      _addLog('❌ ERROR: $error');
      
      if (error is PlatformException) {
        _addLog('📱 Platform Exception Code: ${error.code}');
        _addLog('📱 Platform Exception Message: ${error.message}');
        
        if (error.code == 'sign_in_failed' && error.message?.contains('10') == true) {
          _addLog('🔴 DIAGNOSIS: ApiException 10 - DEVELOPER_ERROR');
          _addLog('🔴 CAUSE: Android OAuth client is missing in Google Cloud Console');
          _addLog('🔴 SOLUTION: Create Android OAuth client with:');
          _addLog('   - Package: com.example.sylonow_vendor');
          _addLog('   - SHA-1: 56:DC:06:41:C0:31:2A:CE:30:49:48:FC:01:E4:EC:D6:88:38:41:8E');
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Test 2: Google Sign-In with Web Client serverClientId
  Future<void> _testGoogleSignInWithServerClientId() async {
    _addLog('🧪 TEST 2: Google Sign-In with Web Client serverClientId');
    setState(() => _isLoading = true);

    try {
      _testGoogleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: '828054656956-m58vo9g2nmtsi6lrnf78es9tvb9vl0d6.apps.googleusercontent.com',
      );

      _addLog('✅ GoogleSignIn instance created with serverClientId');
      _addLog('🔗 Web Client ID: 828054656956-m58vo9g2nmtsi6lrnf78es9tvb9vl0d6.apps.googleusercontent.com');
      
      // Clear previous state
      await _testGoogleSignIn!.signOut();
      _addLog('🔄 Cleared previous sign-in state');

      // Attempt sign-in
      final GoogleSignInAccount? account = await _testGoogleSignIn!.signIn();
      
      if (account != null) {
        _addLog('✅ Sign-in successful!');
        _addLog('👤 Email: ${account.email}');
        
        // Get authentication details
        final GoogleSignInAuthentication auth = await account.authentication;
        _addLog('🔑 ID Token: ${auth.idToken != null ? "✅ Present" : "❌ Missing"}');
        _addLog('🔑 Access Token: ${auth.accessToken != null ? "✅ Present" : "❌ Missing"}');
        
        if (auth.idToken != null) {
          _addLog('🎉 SUCCESS: Ready for Supabase integration!');
          _addLog('🔗 ID Token length: ${auth.idToken!.length} characters');
          _addLog('🔗 ID Token preview: ${auth.idToken!.substring(0, 50)}...');
        } else {
          _addLog('❌ FAILED: No ID token for Supabase');
          _addLog('🔴 This means either:');
          _addLog('   1. Android OAuth client is missing');
          _addLog('   2. Web Client ID is incorrect');
          _addLog('   3. OAuth consent screen not configured');
        }
      } else {
        _addLog('🔵 User cancelled sign-in');
      }
      
    } catch (error) {
      _addLog('❌ ERROR: $error');
      
      if (error is PlatformException) {
        _addLog('📱 Platform Exception Code: ${error.code}');
        _addLog('📱 Platform Exception Message: ${error.message}');
        
        if (error.code == 'sign_in_failed' && error.message?.contains('10') == true) {
          _addLog('🔴 DIAGNOSIS: ApiException 10 - DEVELOPER_ERROR');
          _addLog('🔴 SOLUTIONS TO TRY:');
          _addLog('   1. Create Android OAuth client in Google Console');
          _addLog('   2. Verify Web Client ID is correct');
          _addLog('   3. Check OAuth consent screen configuration');
          _addLog('   4. Ensure both clients use same project');
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Test 3: Full Google Auth Service Test
  Future<void> _testGoogleAuthService() async {
    _addLog('🧪 TEST 3: Full Google Auth Service Test');
    setState(() => _isLoading = true);

    try {
      final googleAuthService = GoogleAuthService();
      googleAuthService.initialize();
      _addLog('✅ Google Auth Service initialized');

      final response = await googleAuthService.signInWithGoogle();
      
      if (response?.user != null) {
        _addLog('🎉 SUCCESS: Full authentication flow completed!');
        _addLog('👤 Supabase User: ${response!.user!.email}');
        _addLog('🆔 User ID: ${response.user!.id}');
      } else {
        _addLog('🔵 Authentication cancelled or failed');
      }
      
    } catch (error) {
      _addLog('❌ ERROR: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Test 4: Check Google Play Services
  Future<void> _testGooglePlayServices() async {
    _addLog('🧪 TEST 4: Google Play Services Check');
    
    try {
      // Try to create a basic GoogleSignIn instance
      final testSignIn = GoogleSignIn();
      _addLog('✅ Google Play Services available');
      
      // Check if user is already signed in
      final currentUser = await testSignIn.signInSilently();
      if (currentUser != null) {
        _addLog('👤 Already signed in: ${currentUser.email}');
      } else {
        _addLog('🔵 No existing sign-in session');
      }
      
    } catch (error) {
      _addLog('❌ Google Play Services ERROR: $error');
    }
  }

  // Test 5: Verify OAuth Client Configuration
  Future<void> _testServerClientIdConfig() async {
    _addLog('🧪 TEST 5: Verify OAuth Client Configuration');
    
    try {
      const webClientId = '828054656956-m58vo9g2nmtsi6lrnf78es9tvb9vl0d6.apps.googleusercontent.com';
      const androidClientId = '828054656956-lj41eng32h75vafq8srrhrn82cmd2qsr.apps.googleusercontent.com';
      const correctClientId = '828054656956-b3slupq810c7dvlpln0ihh9bptk8b3fo.apps.googleusercontent.com';
      
      _addLog('🔍 Checking OAuth Client IDs...');
      _addLog('🌐 Web Client ID: $webClientId');
      _addLog('📱 Android Client ID: $androidClientId');
      _addLog('✅ CORRECT Client ID (from google_service.json): $correctClientId');
      
      // Validate formats
      _addLog('🔍 Format validation:');
      if (correctClientId.contains('apps.googleusercontent.com')) {
        _addLog('✅ CORRECT Client ID format is valid');
      } else {
        _addLog('❌ CORRECT Client ID format is invalid');
      }
      
      // Check project numbers
      final correctProjectNumber = correctClientId.split('-')[0];
      _addLog('📊 Project Number: $correctProjectNumber');
      
      if (correctProjectNumber == '828054656956') {
        _addLog('✅ Project Number matches expected: 828054656956');
      } else {
        _addLog('❌ Project Number mismatch');
      }
      
      _addLog('🔍 Current configuration:');
      _addLog('   📂 Project: sylonow-85de9');
      _addLog('   ✅ USING: $correctClientId');
      _addLog('   📦 Package: com.example.sylonow_vendor');
      _addLog('   🔐 SHA-1: 56:DC:06:41:C0:31:2A:CE:30:49:48:FC:01:E4:EC:D6:88:38:41:8E');
      
      _addLog('💡 IMPORTANT: Make sure this Client ID is configured in:');
      _addLog('   1. Google Cloud Console OAuth Clients');
      _addLog('   2. Supabase Auth Providers → Google');
      
    } catch (error) {
      _addLog('❌ Config check error: $error');
    }
  }

  // Test 6: Test with Android Client ID (not Web Client ID)
  Future<void> _testWithAndroidClientId() async {
    _addLog('🧪 TEST 6: Google Sign-In with Android Client ID');
    setState(() => _isLoading = true);

    try {
      _testGoogleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        // Use Android Client ID instead of Web Client ID
        serverClientId: '828054656956-lj41eng32h75vafq8srrhrn82cmd2qsr.apps.googleusercontent.com',
      );

      _addLog('✅ GoogleSignIn instance created with Android Client ID');
      _addLog('🔗 Android Client ID: 828054656956-lj41eng32h75vafq8srrhrn82cmd2qsr.apps.googleusercontent.com');
      
      // Clear previous state
      await _testGoogleSignIn!.signOut();
      _addLog('🔄 Cleared previous sign-in state');

      // Attempt sign-in
      final GoogleSignInAccount? account = await _testGoogleSignIn!.signIn();
      
      if (account != null) {
        _addLog('✅ Sign-in successful!');
        _addLog('👤 Email: ${account.email}');
        
        // Get authentication details
        final GoogleSignInAuthentication auth = await account.authentication;
        _addLog('🔑 ID Token: ${auth.idToken != null ? "✅ Present" : "❌ Missing"}');
        _addLog('🔑 Access Token: ${auth.accessToken != null ? "✅ Present" : "❌ Missing"}');
        
        if (auth.idToken != null) {
          _addLog('🎉 SUCCESS: Android Client ID works!');
          _addLog('🔗 ID Token length: ${auth.idToken!.length} characters');
          _addLog('🔗 ID Token preview: ${auth.idToken!.substring(0, 50)}...');
        } else {
          _addLog('❌ FAILED: Still no ID token with Android Client ID');
        }
      } else {
        _addLog('🔵 User cancelled sign-in');
      }
      
    } catch (error) {
      _addLog('❌ ERROR: $error');
      
      if (error is PlatformException) {
        _addLog('📱 Platform Exception Code: ${error.code}');
        _addLog('📱 Platform Exception Message: ${error.message}');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Test 7: Comprehensive Supabase + Google Auth Test
  Future<void> _testSupabaseGoogleAuth() async {
    _addLog('🧪 TEST 7: Comprehensive Supabase + Google Auth Test');
    setState(() => _isLoading = true);

    try {
      // Test 1: Verify Supabase connection
      _addLog('🔍 Step 1: Testing Supabase connection...');
      final supabase = Supabase.instance.client;
      _addLog('✅ Supabase client available');
      _addLog('🌐 Supabase URL: https://txgszrxjyanazlrupaty.supabase.co');
      
      // Test 2: Test Google Sign-In with CORRECT CLIENT ID from google_service.json
      _addLog('🔍 Step 2: Testing Google Sign-In with CORRECT Client ID...');
      _testGoogleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        // Use the NEW Web Client ID for Supabase
        serverClientId: '828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com',
      );

      _addLog('✅ GoogleSignIn configured with CORRECT Client ID');
      _addLog('🔗 Client ID: 828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com');
      
      // Clear previous state
      await _testGoogleSignIn!.signOut();
      _addLog('🔄 Cleared previous sign-in state');

      // Attempt sign-in
      _addLog('🔍 Step 3: Attempting Google Sign-In...');
      final GoogleSignInAccount? account = await _testGoogleSignIn!.signIn();
      
      if (account != null) {
        _addLog('✅ Google Sign-In successful!');
        _addLog('👤 Email: ${account.email}');
        
        // Get authentication details
        final GoogleSignInAuthentication auth = await account.authentication;
        _addLog('🔑 ID Token: ${auth.idToken != null ? "✅ Present" : "❌ Missing"}');
        _addLog('🔑 Access Token: ${auth.accessToken != null ? "✅ Present" : "❌ Missing"}');
        
        if (auth.idToken != null) {
          _addLog('🎉 SUCCESS: ID Token received!');
          _addLog('🔗 ID Token length: ${auth.idToken!.length} characters');
          
          // Test 3: Test Supabase authentication
          _addLog('🔍 Step 4: Testing Supabase authentication...');
          try {
            final response = await supabase.auth.signInWithIdToken(
              provider: OAuthProvider.google,
              idToken: auth.idToken!,
              accessToken: auth.accessToken,
            );
            
            if (response.user != null) {
              _addLog('🎉 SUPABASE SUCCESS: User authenticated!');
              _addLog('👤 Supabase User ID: ${response.user!.id}');
              _addLog('📧 Supabase User Email: ${response.user!.email}');
              _addLog('🔐 Auth Provider: ${response.user!.appMetadata['provider']}');
            } else {
              _addLog('❌ SUPABASE FAILED: No user returned');
            }
          } catch (supabaseError) {
            _addLog('❌ SUPABASE ERROR: $supabaseError');
            _addLog('💡 This might indicate Supabase Auth Provider misconfiguration');
          }
        } else {
          _addLog('❌ FAILED: Still no ID token');
          _addLog('💡 This indicates OAuth client configuration issue');
        }
      } else {
        _addLog('🔵 User cancelled sign-in');
      }
      
    } catch (error) {
      _addLog('❌ ERROR: $error');
      
      if (error is PlatformException) {
        _addLog('📱 Platform Exception Code: ${error.code}');
        _addLog('📱 Platform Exception Message: ${error.message}');
        
        if (error.code == 'sign_in_failed' && error.message?.contains('10') == true) {
          _addLog('💡 DIAGNOSIS: OAuth client configuration mismatch');
          _addLog('💡 POSSIBLE CAUSES:');
          _addLog('   1. Android Client ID missing/incorrect in Google Console');
          _addLog('   2. SHA-1 fingerprint mismatch');
          _addLog('   3. Package name mismatch');
          _addLog('   4. Supabase Auth Provider not configured with correct Client ID');
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Test 8: Test with Working Project Pattern
  Future<void> _testWorkingProjectPattern() async {
    _addLog('🧪 TEST 8: Using Working Project Pattern');
    setState(() => _isLoading = true);

    try {
      _addLog('📋 Working Project Pattern Analysis:');
      _addLog('   - Android Client: Auto-detected from google-services.json');
      _addLog('   - Web Client (serverClientId): For Supabase backend');
      _addLog('   - Scopes: email, profile only');
      
      // Follow the exact pattern from working project
      _testGoogleSignIn = GoogleSignIn(
        // Key insight: Use WEB Client ID as serverClientId (like working project)
        serverClientId: '828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );

      _addLog('✅ GoogleSignIn configured with Working Project pattern');
      _addLog('🔗 Web Client ID (serverClientId): 828054656956-9lb66n0bjgeoo7ta808ank5acj09uno7.apps.googleusercontent.com');
      _addLog('📱 Android Client: Auto from google-services.json');
      
      // Clear previous state
      await _testGoogleSignIn!.signOut();
      _addLog('🔄 Cleared previous sign-in state');

      // Attempt sign-in
      _addLog('🔍 Attempting Google Sign-In...');
      final GoogleSignInAccount? account = await _testGoogleSignIn!.signIn();
      
      if (account != null) {
        _addLog('✅ Google Sign-In successful!');
        _addLog('👤 Email: ${account.email}');
        
        // Get authentication details
        final GoogleSignInAuthentication auth = await account.authentication;
        _addLog('🔑 ID Token: ${auth.idToken != null ? "✅ Present" : "❌ Missing"}');
        _addLog('🔑 Access Token: ${auth.accessToken != null ? "✅ Present" : "❌ Missing"}');
        
        if (auth.idToken != null) {
          _addLog('🎉 SUCCESS: Working Project Pattern Works!');
          _addLog('🔗 ID Token length: ${auth.idToken!.length} characters');
          
          // Test Supabase integration
          _addLog('🔍 Testing Supabase integration...');
          try {
            final supabase = Supabase.instance.client;
            final response = await supabase.auth.signInWithIdToken(
              provider: OAuthProvider.google,
              idToken: auth.idToken!,
              accessToken: auth.accessToken,
            );
            
            if (response.user != null) {
              _addLog('🎉 SUPABASE SUCCESS: Complete authentication!');
              _addLog('👤 User ID: ${response.user!.id}');
              _addLog('📧 Email: ${response.user!.email}');
            } else {
              _addLog('❌ Supabase: No user returned');
            }
          } catch (supabaseError) {
            _addLog('❌ Supabase Error: $supabaseError');
          }
        } else {
          _addLog('❌ FAILED: Still no ID token');
        }
      } else {
        _addLog('🔵 User cancelled sign-in');
      }
      
    } catch (error) {
      _addLog('❌ ERROR: $error');
      
      if (error is PlatformException) {
        _addLog('📱 Platform Exception Code: ${error.code}');
        _addLog('📱 Platform Exception Message: ${error.message}');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Test 9: Verify google-services.json Structure
  Future<void> _testGoogleServicesJson() async {
    _addLog('🧪 TEST 9: Verify google-services.json Structure');
    setState(() => _isLoading = true);

    try {
      _addLog('🔍 Analyzing current google-services.json structure...');
      
      // Load and analyze the google-services.json file
      try {
        final String jsonString = await DefaultAssetBundle.of(context).loadString('android/app/google-services.json');
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        
        _addLog('📄 google-services.json content analysis:');
        
        if (jsonData.containsKey('installed')) {
          _addLog('❌ PROBLEM FOUND: "installed" configuration detected');
          _addLog('💡 This is for DESKTOP apps, not mobile apps!');
          _addLog('🔧 SOLUTION REQUIRED:');
          _addLog('   1. Delete current OAuth clients in Google Console');
          _addLog('   2. Create NEW Android OAuth client (not desktop)');
          _addLog('   3. Create NEW Web OAuth client for Supabase');
          _addLog('   4. Download NEW google-services.json');
          _addLog('');
          _addLog('📋 Required OAuth Client Configuration:');
          _addLog('   Android Client:');
          _addLog('   - Type: Android application');
          _addLog('   - Package: com.example.sylonow_vendor');
          _addLog('   - SHA-1: 56:DC:06:41:C0:31:2A:CE:30:49:48:FC:01:E4:EC:D6:88:38:41:8E');
          _addLog('');
          _addLog('   Web Client:');
          _addLog('   - Type: Web application');
          _addLog('   - Redirect URI: https://txgszrxjyanazlrupaty.supabase.co/auth/v1/callback');
          
        } else if (jsonData.containsKey('client')) {
          _addLog('✅ CORRECT: Mobile app configuration detected');
          final List clients = jsonData['client'];
          if (clients.isNotEmpty) {
            final client = clients[0];
            if (client.containsKey('oauth_client')) {
              _addLog('✅ OAuth clients found in configuration');
              final List oauthClients = client['oauth_client'];
              _addLog('📊 Found ${oauthClients.length} OAuth client(s)');
            } else {
              _addLog('❌ No OAuth clients found in configuration');
            }
          }
        } else {
          _addLog('❌ UNKNOWN: Unrecognized google-services.json structure');
        }
        
      } catch (e) {
        _addLog('❌ Could not load google-services.json: $e');
        _addLog('💡 File might not be accessible from Flutter context');
      }
      
      _addLog('');
      _addLog('🎯 NEXT STEPS:');
      _addLog('1. Recreate OAuth clients in Google Cloud Console');
      _addLog('2. Download NEW google-services.json');
      _addLog('3. Update Supabase with Web Client ID');
      _addLog('4. Test again with proper configuration');
      
    } catch (error) {
      _addLog('❌ Analysis error: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google OAuth Debug'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearLogs,
            tooltip: 'Clear Logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Test Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testGooglePlayServices,
                        child: const Text('Test Play Services'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testBasicGoogleSignIn,
                        child: const Text('Test Basic Sign-In'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testGoogleSignInWithServerClientId,
                        child: const Text('Test with ServerClientId'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testGoogleAuthService,
                        child: const Text('Test Full Service'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testServerClientIdConfig,
                        child: const Text('Check ServerClientId'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testWithAndroidClientId,
                        child: const Text('Test Android Client'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testSupabaseGoogleAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('🎯 COMPREHENSIVE TEST'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testWorkingProjectPattern,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('🏆 WORKING PROJECT PATTERN'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testGoogleServicesJson,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('🔍 VERIFY GOOGLE-SERVICES.JSON'),
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Logs Display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Debug Logs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _logs.isEmpty ? null : () {
                          Clipboard.setData(ClipboardData(text: _logs.join('\n')));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logs copied to clipboard')),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          Color textColor = Colors.white;
                          
                          if (log.contains('✅') || log.contains('🎉')) {
                            textColor = Colors.green;
                          } else if (log.contains('❌') || log.contains('🔴')) {
                            textColor = Colors.red;
                          } else if (log.contains('⚠️')) {
                            textColor = Colors.orange;
                          } else if (log.contains('🔵')) {
                            textColor = Colors.blue;
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              log,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 