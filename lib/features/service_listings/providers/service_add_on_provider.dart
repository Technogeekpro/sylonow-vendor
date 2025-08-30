import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/service_add_on.dart';
import '../service/service_add_on_service.dart';

part 'service_add_on_provider.g.dart';

/// Provider for service add-ons for a specific service listing
@riverpod
class ServiceAddOnsNotifier extends _$ServiceAddOnsNotifier {
  @override
  Future<List<ServiceAddOn>> build(String serviceListingId) async {
    final service = ServiceAddOnService();
    return service.getAddOnsForService(serviceListingId);
  }

  /// Add a new add-on
  Future<void> addAddOn(ServiceAddOn addOn) async {
    state = const AsyncValue.loading();
    
    try {
      final service = ServiceAddOnService();
      final createdAddOn = await service.createAddOn(addOn);
      
      if (createdAddOn != null) {
        // Refresh the list
        ref.invalidateSelf();
      } else {
        throw Exception('Failed to create add-on');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Update an existing add-on
  Future<void> updateAddOn(ServiceAddOn addOn) async {
    state = const AsyncValue.loading();
    
    try {
      final service = ServiceAddOnService();
      final updatedAddOn = await service.updateAddOn(addOn);
      
      if (updatedAddOn != null) {
        // Refresh the list
        ref.invalidateSelf();
      } else {
        throw Exception('Failed to update add-on');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Delete an add-on
  Future<void> deleteAddOn(String addOnId) async {
    state = const AsyncValue.loading();
    
    try {
      final service = ServiceAddOnService();
      final success = await service.deleteAddOn(addOnId);
      
      if (success) {
        // Refresh the list
        ref.invalidateSelf();
      } else {
        throw Exception('Failed to delete add-on');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Toggle add-on availability
  Future<void> toggleAvailability(String addOnId, bool isAvailable) async {
    try {
      final service = ServiceAddOnService();
      final success = await service.updateAddOnAvailability(addOnId, isAvailable);
      
      if (success) {
        // Update the state locally for immediate feedback
        final currentState = state.value;
        if (currentState != null) {
          final updatedList = currentState.map((addOn) {
            if (addOn.id == addOnId) {
              return addOn.copyWith(isAvailable: isAvailable);
            }
            return addOn;
          }).toList();
          
          state = AsyncValue.data(updatedList);
        }
      } else {
        throw Exception('Failed to toggle add-on availability');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Update add-on stock
  Future<void> updateStock(String addOnId, int stock) async {
    try {
      final service = ServiceAddOnService();
      final success = await service.updateAddOnStock(addOnId, stock);
      
      if (success) {
        // Update the state locally for immediate feedback
        final currentState = state.value;
        if (currentState != null) {
          final updatedList = currentState.map((addOn) {
            if (addOn.id == addOnId) {
              return addOn.copyWith(stock: stock);
            }
            return addOn;
          }).toList();
          
          state = AsyncValue.data(updatedList);
        }
      } else {
        throw Exception('Failed to update add-on stock');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Reorder add-ons
  Future<void> reorderAddOns(List<ServiceAddOn> reorderedAddOns) async {
    try {
      final service = ServiceAddOnService();
      final addOnOrders = <String, int>{};
      
      for (int i = 0; i < reorderedAddOns.length; i++) {
        if (reorderedAddOns[i].id != null) {
          addOnOrders[reorderedAddOns[i].id!] = i;
        }
      }
      
      final success = await service.reorderAddOns(addOnOrders);
      
      if (success) {
        // Update the state locally
        state = AsyncValue.data(reorderedAddOns);
      } else {
        throw Exception('Failed to reorder add-ons');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refresh the add-ons list
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Provider for all add-ons managed by a vendor
@riverpod
class VendorAddOnsNotifier extends _$VendorAddOnsNotifier {
  @override
  Future<List<ServiceAddOn>> build(String vendorId) async {
    final service = ServiceAddOnService();
    // Get all service listings for the vendor first, then get add-ons for each
    try {
      // This would need to be implemented in the service to get add-ons by vendor
      // For now, return empty list
      return [];
    } catch (e) {
      throw Exception('Failed to load vendor add-ons: $e');
    }
  }

  /// Refresh vendor add-ons
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Provider for add-on form state
@riverpod
class AddOnFormNotifier extends _$AddOnFormNotifier {
  @override
  ServiceAddOn? build() {
    return null;
  }

  /// Set the current add-on being edited
  void setAddOn(ServiceAddOn? addOn) {
    state = addOn;
  }

  /// Clear the form
  void clear() {
    state = null;
  }

  /// Update form fields
  void updateName(String name) {
    if (state != null) {
      state = state!.copyWith(name: name);
    }
  }

  void updateDescription(String description) {
    if (state != null) {
      state = state!.copyWith(description: description);
    }
  }

  void updateOriginalPrice(double price) {
    if (state != null) {
      state = state!.copyWith(originalPrice: price);
    }
  }

  void updateDiscountPrice(double? price) {
    if (state != null) {
      state = state!.copyWith(discountPrice: price);
    }
  }

  void updateType(String type) {
    if (state != null) {
      state = state!.copyWith(type: type);
    }
  }

  void updateUnit(String unit) {
    if (state != null) {
      state = state!.copyWith(unit: unit);
    }
  }

  void updateStock(int stock) {
    if (state != null) {
      state = state!.copyWith(stock: stock);
    }
  }

  void updateAvailability(bool isAvailable) {
    if (state != null) {
      state = state!.copyWith(isAvailable: isAvailable);
    }
  }

  void updateImages(List<String> images) {
    if (state != null) {
      state = state!.copyWith(images: images);
    }
  }
}