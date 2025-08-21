import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_settings.dart';

class AdminSettingsService {
  static final AdminSettingsService _instance = AdminSettingsService._internal();
  factory AdminSettingsService() => _instance;
  AdminSettingsService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // Cache for admin settings
  AdminSettings? _cachedSettings;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(hours: 1);

  /// Get admin settings with caching
  Future<AdminSettings> getAdminSettings({bool forceRefresh = false}) async {
    try {
      // Check if we have cached data and it's still valid
      if (!forceRefresh && 
          _cachedSettings != null && 
          _lastFetchTime != null && 
          DateTime.now().difference(_lastFetchTime!) < _cacheExpiry) {
        return _cachedSettings!;
      }

      print('🔍 AdminSettingsService: Fetching admin settings from database...');

      // Fetch from database using key-value structure
      final response = await _client
          .from('admin_settings')
          .select('setting_key, setting_value')
          .inFilter('setting_key', ['support_email', 'support_phone', 'app_version', 'maintenance_mode', 'force_update']);

      AdminSettings settings;
      if (response.isNotEmpty) {
        // Convert key-value pairs to AdminSettings object
        Map<String, dynamic> settingsMap = {};
        
        for (var row in response) {
          final key = row['setting_key'] as String;
          final value = row['setting_value'];
          
          // Map database keys to model keys
          switch (key) {
            case 'support_email':
              settingsMap['support_email'] = value is String ? value.replaceAll('"', '') : value;
              break;
            case 'support_phone':
              settingsMap['support_phone'] = value is String ? value.replaceAll('"', '') : value;
              break;
            case 'app_version':
              settingsMap['app_version'] = value;
              break;
            case 'maintenance_mode':
              settingsMap['maintenance_mode'] = value;
              break;
            case 'force_update':
              settingsMap['force_update'] = value;
              break;
          }
        }
        
        settings = AdminSettings.fromJson(settingsMap);
        print('✅ AdminSettingsService: Admin settings fetched successfully');
        print('📧 Support Email: ${settings.supportEmail}');
        print('📞 Support Phone: ${settings.supportPhone}');
      } else {
        print('⚠️ AdminSettingsService: No admin settings found, using defaults');
        settings = AdminSettings.defaultSettings;
      }

      // Update cache
      _cachedSettings = settings;
      _lastFetchTime = DateTime.now();

      return settings;
    } catch (e) {
      print('❌ AdminSettingsService: Error fetching admin settings: $e');
      
      // Return cached data if available, otherwise return defaults
      if (_cachedSettings != null) {
        print('🔄 AdminSettingsService: Returning cached admin settings due to error');
        return _cachedSettings!;
      } else {
        print('🔄 AdminSettingsService: Returning default admin settings due to error');
        return AdminSettings.defaultSettings;
      }
    }
  }

  /// Get only support contact information (optimized for support screen)
  Future<Map<String, String>> getSupportContact({bool forceRefresh = false}) async {
    try {
      final settings = await getAdminSettings(forceRefresh: forceRefresh);
      return {
        'email': settings.supportEmail ?? AdminSettings.defaultSettings.supportEmail!,
        'phone': settings.supportPhone ?? AdminSettings.defaultSettings.supportPhone!,
      };
    } catch (e) {
      print('❌ AdminSettingsService: Error getting support contact: $e');
      return {
        'email': AdminSettings.defaultSettings.supportEmail!,
        'phone': AdminSettings.defaultSettings.supportPhone!,
      };
    }
  }

  /// Check if app is in maintenance mode
  Future<bool> isMaintenanceMode({bool forceRefresh = false}) async {
    try {
      final settings = await getAdminSettings(forceRefresh: forceRefresh);
      return settings.maintenanceMode;
    } catch (e) {
      print('❌ AdminSettingsService: Error checking maintenance mode: $e');
      return false; // Default to not in maintenance mode
    }
  }

  /// Check if force update is required
  Future<bool> isForceUpdateRequired({bool forceRefresh = false}) async {
    try {
      final settings = await getAdminSettings(forceRefresh: forceRefresh);
      return settings.forceUpdate;
    } catch (e) {
      print('❌ AdminSettingsService: Error checking force update: $e');
      return false; // Default to no force update
    }
  }

  /// Clear cache (useful for manual refresh)
  void clearCache() {
    _cachedSettings = null;
    _lastFetchTime = null;
    print('🧹 AdminSettingsService: Cache cleared');
  }

  /// Get cache status for debugging
  Map<String, dynamic> getCacheStatus() {
    return {
      'hasCachedData': _cachedSettings != null,
      'lastFetchTime': _lastFetchTime?.toIso8601String(),
      'cacheAge': _lastFetchTime != null 
          ? DateTime.now().difference(_lastFetchTime!).inMinutes 
          : null,
      'cacheExpired': _lastFetchTime != null 
          ? DateTime.now().difference(_lastFetchTime!) > _cacheExpiry
          : true,
    };
  }
}