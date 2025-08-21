import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/addon.dart';
import '../service/addon_service.dart';

part 'addon_provider.g.dart';

// Provider to get all vendor add-ons
@riverpod
Future<List<Addon>> vendorAddons(VendorAddonsRef ref) async {
  final service = ref.watch(addonServiceProvider);
  return service.getVendorAddons();
}

// Provider to get add-ons by category
@riverpod
Future<List<Addon>> addonsByCategory(AddonsByCategoryRef ref, String category) async {
  final service = ref.watch(addonServiceProvider);
  return service.getAddonsByCategory(category);
}

// Provider to get available categories
@riverpod
Future<List<String>> availableCategories(AvailableCategoriesRef ref) async {
  final service = ref.watch(addonServiceProvider);
  return service.getAvailableCategories();
}