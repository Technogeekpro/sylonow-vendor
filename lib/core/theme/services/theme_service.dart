import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/theme_config.dart';

class ThemeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get the active theme configuration
  Future<ThemeConfig?> getActiveTheme() async {
    try {
      final response = await _supabase
          .from('app_theme_config')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return ThemeConfig.fromJson(_mapDatabaseResponse(response));
    } catch (e) {
      throw Exception('Failed to fetch active theme: $e');
    }
  }

  // Get all theme configurations
  Future<List<ThemeConfig>> getAllThemes() async {
    try {
      final response = await _supabase
          .from('app_theme_config')
          .select()
          .order('created_at', ascending: false);

      return response
          .map<ThemeConfig>((json) => ThemeConfig.fromJson(_mapDatabaseResponse(json)))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch themes: $e');
    }
  }

  // Get theme by ID
  Future<ThemeConfig?> getThemeById(String id) async {
    try {
      final response = await _supabase
          .from('app_theme_config')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return ThemeConfig.fromJson(_mapDatabaseResponse(response));
    } catch (e) {
      throw Exception('Failed to fetch theme by ID: $e');
    }
  }

  // Set active theme
  Future<void> setActiveTheme(String themeId) async {
    try {
      // Start a transaction to ensure only one theme is active
      await _supabase.rpc('set_active_theme', params: {'theme_id': themeId});
    } catch (e) {
      throw Exception('Failed to set active theme: $e');
    }
  }

  // Create new theme configuration
  Future<ThemeConfig> createTheme(Map<String, dynamic> themeData) async {
    try {
      final response = await _supabase
          .from('app_theme_config')
          .insert(themeData)
          .select()
          .single();

      return ThemeConfig.fromJson(_mapDatabaseResponse(response));
    } catch (e) {
      throw Exception('Failed to create theme: $e');
    }
  }

  // Update theme configuration
  Future<ThemeConfig> updateTheme(String id, Map<String, dynamic> themeData) async {
    try {
      final response = await _supabase
          .from('app_theme_config')
          .update(themeData)
          .eq('id', id)
          .select()
          .single();

      return ThemeConfig.fromJson(_mapDatabaseResponse(response));
    } catch (e) {
      throw Exception('Failed to update theme: $e');
    }
  }

  // Delete theme configuration
  Future<void> deleteTheme(String id) async {
    try {
      await _supabase
          .from('app_theme_config')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete theme: $e');
    }
  }

  // Listen to theme changes in real-time
  Stream<ThemeConfig?> watchActiveTheme() {
    return _supabase
        .from('app_theme_config')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .map((data) {
          if (data.isEmpty) return null;
          return ThemeConfig.fromJson(_mapDatabaseResponse(data.first));
        });
  }

  // Helper method to map database response to match our model structure
  Map<String, dynamic> _mapDatabaseResponse(Map<String, dynamic> response) {
    return {
      'id': response['id'],
      'configName': response['config_name'],
      'isActive': response['is_active'],
      'primaryColor': response['primary_color'],
      'primaryLight': response['primary_light'],
      'primaryDark': response['primary_dark'],
      'primarySurface': response['primary_surface'],
      'secondaryColor': response['secondary_color'],
      'secondaryLight': response['secondary_light'],
      'secondaryDark': response['secondary_dark'],
      'accentPink': response['accent_pink'],
      'accentPurple': response['accent_purple'],
      'accentBlue': response['accent_blue'],
      'accentTeal': response['accent_teal'],
      'successColor': response['success_color'],
      'successLight': response['success_light'],
      'successDark': response['success_dark'],
      'errorColor': response['error_color'],
      'errorLight': response['error_light'],
      'errorDark': response['error_dark'],
      'warningColor': response['warning_color'],
      'warningLight': response['warning_light'],
      'warningDark': response['warning_dark'],
      'infoColor': response['info_color'],
      'infoLight': response['info_light'],
      'infoDark': response['info_dark'],
      'backgroundColor': response['background_color'],
      'surfaceColor': response['surface_color'],
      'cardColor': response['card_color'],
      'dividerColor': response['divider_color'],
      'textPrimaryColor': response['text_primary_color'],
      'textSecondaryColor': response['text_secondary_color'],
      'textDisabledColor': response['text_disabled_color'],
      'textOnPrimary': response['text_on_primary'],
      'textOnSurface': response['text_on_surface'],
      'borderColor': response['border_color'],
      'shadowColor': response['shadow_color'],
      'elevationShadow': response['elevation_shadow'],
      'createdAt': response['created_at'],
      'updatedAt': response['updated_at'],
      'createdBy': response['created_by'],
      'version': response['version'],
    };
  }
}