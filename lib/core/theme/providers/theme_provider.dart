import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import '../models/theme_config.dart';
import '../services/theme_service.dart';
import '../app_theme.dart';

part 'theme_provider.g.dart';

@riverpod
ThemeService themeService(ThemeServiceRef ref) {
  return ThemeService();
}

@riverpod
class ActiveTheme extends _$ActiveTheme {
  @override
  Future<ThemeConfig?> build() async {
    try {
      final themeService = ref.watch(themeServiceProvider);
      return await themeService.getActiveTheme();
    } catch (e) {
      // If there's an error, return null and we'll use default theme
      return null;
    }
  }

  // Refresh the active theme
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final themeService = ref.read(themeServiceProvider);
      return await themeService.getActiveTheme();
    });
  }

  // Set a new active theme
  Future<void> setActiveTheme(String themeId) async {
    try {
      final themeService = ref.read(themeServiceProvider);
      await themeService.setActiveTheme(themeId);
      await refresh();
    } catch (e) {
      // Handle error by keeping current state
      rethrow;
    }
  }
}

@riverpod
class ThemeManager extends _$ThemeManager {
  @override
  Future<List<ThemeConfig>> build() async {
    final themeService = ref.watch(themeServiceProvider);
    return await themeService.getAllThemes();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final themeService = ref.read(themeServiceProvider);
      return await themeService.getAllThemes();
    });
  }

  Future<ThemeConfig> createTheme(Map<String, dynamic> themeData) async {
    final themeService = ref.read(themeServiceProvider);
    final newTheme = await themeService.createTheme(themeData);
    await refresh();
    return newTheme;
  }

  Future<ThemeConfig> updateTheme(String id, Map<String, dynamic> themeData) async {
    final themeService = ref.read(themeServiceProvider);
    final updatedTheme = await themeService.updateTheme(id, themeData);
    await refresh();
    ref.read(activeThemeProvider.notifier).refresh();
    return updatedTheme;
  }

  Future<void> deleteTheme(String id) async {
    final themeService = ref.read(themeServiceProvider);
    await themeService.deleteTheme(id);
    await refresh();
    ref.read(activeThemeProvider.notifier).refresh();
  }
}

// Provider that returns the actual ThemeData based on active theme config
@riverpod
ThemeData appThemeData(AppThemeDataRef ref) {
  final activeThemeAsync = ref.watch(activeThemeProvider);
  
  return activeThemeAsync.when(
    data: (themeConfig) {
      if (themeConfig == null) {
        // Use default theme if no active theme is found
        return AppTheme.lightTheme;
      }
      // Create theme data from the theme config
      return AppTheme.createThemeFromConfig(themeConfig);
    },
    loading: () => AppTheme.lightTheme, // Use default while loading
    error: (_, __) => AppTheme.lightTheme, // Use default on error
  );
}

// Real-time theme watcher
@riverpod
class ThemeWatcher extends _$ThemeWatcher {
  @override
  Stream<ThemeConfig?> build() {
    final themeService = ref.watch(themeServiceProvider);
    return themeService.watchActiveTheme();
  }
}

// Provider to get theme by ID
@riverpod
Future<ThemeConfig?> themeById(ThemeByIdRef ref, String id) async {
  final themeService = ref.watch(themeServiceProvider);
  return await themeService.getThemeById(id);
}