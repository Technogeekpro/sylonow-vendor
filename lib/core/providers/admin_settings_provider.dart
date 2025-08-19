import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_settings.dart';
import '../services/admin_settings_service.dart';

part 'admin_settings_provider.g.dart';

@riverpod
AdminSettingsService adminSettingsService(Ref ref) {
  return AdminSettingsService();
}

// Provider for admin settings with caching
@riverpod
class AdminSettingsData extends _$AdminSettingsData {
  @override
  Future<AdminSettings> build() async {
    final service = ref.watch(adminSettingsServiceProvider);
    return await service.getAdminSettings();
  }

  // Force refresh admin settings
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(adminSettingsServiceProvider);
      return await service.getAdminSettings(forceRefresh: true);
    });
  }

  // Clear cache and refresh
  Future<void> clearCacheAndRefresh() async {
    final service = ref.read(adminSettingsServiceProvider);
    service.clearCache();
    await refresh();
  }
}

// Provider specifically for support contact information
@riverpod
class SupportContact extends _$SupportContact {
  @override
  Future<Map<String, String>> build() async {
    final service = ref.watch(adminSettingsServiceProvider);
    return await service.getSupportContact();
  }

  // Refresh support contact info
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(adminSettingsServiceProvider);
      return await service.getSupportContact(forceRefresh: true);
    });
  }
}

// Provider for maintenance mode check
@riverpod
class MaintenanceMode extends _$MaintenanceMode {
  @override
  Future<bool> build() async {
    final service = ref.watch(adminSettingsServiceProvider);
    return await service.isMaintenanceMode();
  }

  // Check maintenance mode
  Future<bool> check() async {
    final service = ref.read(adminSettingsServiceProvider);
    final isMaintenanceMode = await service.isMaintenanceMode(forceRefresh: true);
    state = AsyncData(isMaintenanceMode);
    return isMaintenanceMode;
  }
}

// Provider for force update check
@riverpod
class ForceUpdate extends _$ForceUpdate {
  @override
  Future<bool> build() async {
    final service = ref.watch(adminSettingsServiceProvider);
    return await service.isForceUpdateRequired();
  }

  // Check force update requirement
  Future<bool> check() async {
    final service = ref.read(adminSettingsServiceProvider);
    final isForceUpdate = await service.isForceUpdateRequired(forceRefresh: true);
    state = AsyncData(isForceUpdate);
    return isForceUpdate;
  }
}

// Convenience provider for support email
@riverpod
Future<String> supportEmail(Ref ref) async {
  final adminSettings = await ref.watch(adminSettingsDataProvider.future);
  return adminSettings.supportEmail ?? AdminSettings.defaultSettings.supportEmail!;
}

// Convenience provider for support phone
@riverpod
Future<String> supportPhone(Ref ref) async {
  final adminSettings = await ref.watch(adminSettingsDataProvider.future);
  return adminSettings.supportPhone ?? AdminSettings.defaultSettings.supportPhone!;
}