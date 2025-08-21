import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_addon.dart';
import '../services/service_addon_service.dart';

// Service provider
final serviceAddonServiceProvider = Provider<ServiceAddonService>((ref) {
  return ServiceAddonService();
});

// State notifier for managing service addons
class ServiceAddonNotifier extends StateNotifier<AsyncValue<List<ServiceAddon>>> {
  ServiceAddonNotifier(this._service) : super(const AsyncValue.loading()) {
    loadAddons();
  }

  final ServiceAddonService _service;

  /// Load all addons for the current vendor
  Future<void> loadAddons() async {
    state = const AsyncValue.loading();
    try {
      final addons = await _service.getVendorAddons();
      state = AsyncValue.data(addons);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Create a new addon
  Future<void> createAddon(ServiceAddon addon) async {
    try {
      final newAddon = await _service.createAddon(addon);
      state = state.whenData((addons) => [...addons, newAddon]);
    } catch (error) {
      // Re-throw to let UI handle the error
      rethrow;
    }
  }

  /// Update an existing addon
  Future<void> updateAddon(ServiceAddon addon) async {
    try {
      final updatedAddon = await _service.updateAddon(addon);
      state = state.whenData((addons) => addons
          .map((a) => a.id == updatedAddon.id ? updatedAddon : a)
          .toList());
    } catch (error) {
      rethrow;
    }
  }

  /// Delete an addon
  Future<void> deleteAddon(String addonId) async {
    try {
      await _service.deleteAddon(addonId);
      state = state.whenData((addons) => addons.where((a) => a.id != addonId).toList());
    } catch (error) {
      rethrow;
    }
  }

  /// Toggle addon availability
  Future<void> toggleAvailability(String addonId, bool isAvailable) async {
    try {
      final updatedAddon = await _service.toggleAvailability(addonId, isAvailable);
      state = state.whenData((addons) => addons
          .map((a) => a.id == updatedAddon.id ? updatedAddon : a)
          .toList());
    } catch (error) {
      rethrow;
    }
  }

  /// Update addon stock
  Future<void> updateStock(String addonId, int stock) async {
    try {
      final updatedAddon = await _service.updateStock(addonId, stock);
      state = state.whenData((addons) => addons
          .map((a) => a.id == updatedAddon.id ? updatedAddon : a)
          .toList());
    } catch (error) {
      rethrow;
    }
  }

  /// Reorder addons
  Future<void> reorderAddons(List<String> addonIds) async {
    try {
      await _service.reorderAddons(addonIds);
      // Reload to get the updated sort order
      await loadAddons();
    } catch (error) {
      rethrow;
    }
  }

  /// Refresh addons
  Future<void> refresh() async {
    await loadAddons();
  }
}

// Provider for the service addon notifier
final serviceAddonProvider = StateNotifierProvider<ServiceAddonNotifier, AsyncValue<List<ServiceAddon>>>((ref) {
  final service = ref.watch(serviceAddonServiceProvider);
  return ServiceAddonNotifier(service);
});

// Provider for getting a specific addon by ID
final serviceAddonByIdProvider = Provider.family<ServiceAddon?, String>((ref, addonId) {
  final addonsAsync = ref.watch(serviceAddonProvider);
  return addonsAsync.whenOrNull(
    data: (addons) => addons.firstWhere(
      (addon) => addon.id == addonId,
      orElse: () => throw StateError('Addon not found'),
    ),
  );
});

// Provider for getting available addons only
final availableServiceAddonsProvider = Provider<AsyncValue<List<ServiceAddon>>>((ref) {
  final addonsAsync = ref.watch(serviceAddonProvider);
  return addonsAsync.whenData(
    (addons) => addons.where((addon) => addon.isAvailable).toList(),
  );
});

// Provider for getting addons count
final serviceAddonsCountProvider = Provider<int>((ref) {
  final addonsAsync = ref.watch(serviceAddonProvider);
  return addonsAsync.whenOrNull(data: (addons) => addons.length) ?? 0;
});