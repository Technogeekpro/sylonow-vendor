import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_listing.dart';
import '../service/service_listing_service.dart';
import '../../onboarding/providers/vendor_provider.dart';

// Provider for vendor's service listings
final serviceListingsProvider = AsyncNotifierProvider<ServiceListingsNotifier, List<ServiceListing>>(
  () => ServiceListingsNotifier(),
);

class ServiceListingsNotifier extends AsyncNotifier<List<ServiceListing>> {
  late ServiceListingService _serviceListingService;

  @override
  Future<List<ServiceListing>> build() async {
    _serviceListingService = ref.read(serviceListingServiceProvider);
    return _loadListings();
  }

  Future<List<ServiceListing>> _loadListings() async {
    try {
      print('🔵 ServiceListingsNotifier: Loading listings...');
      
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.id == null) {
        print('🔴 ServiceListingsNotifier: No vendor ID found');
        throw Exception('Vendor not found');
      }

      print('🔵 ServiceListingsNotifier: Vendor ID: ${vendor!.id}');
      final listings = await _serviceListingService.getVendorListings(vendor.id);
      
      print('🟢 ServiceListingsNotifier: Loaded ${listings.length} listings');
      return listings;
    } catch (e) {
      print('🔴 ServiceListingsNotifier: Error loading listings: $e');
      rethrow;
    }
  }

  // Refresh listings
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadListings());
  }

  // Create new listing
  Future<void> createListing(ServiceListing listing) async {
    try {
      print('🔵 ServiceListingsNotifier: Creating listing...');
      
      final vendor = await ref.read(vendorProvider.future);
      if (vendor == null) {
        throw Exception('Cannot create listing without a vendor.');
      }

      // Optimistically update the state
      state = const AsyncLoading();
      
      await _serviceListingService.createListing(listing, vendor.id);
      
      // Update state with new listing added
      state = await AsyncValue.guard(() async {
        final currentListings = await _loadListings();
        return currentListings;
      });
      
      print('🟢 ServiceListingsNotifier: Listing created successfully');
    } catch (e) {
      print('🔴 ServiceListingsNotifier: Error creating listing: $e');
      // Revert to previous state on error
      state = await AsyncValue.guard(() => _loadListings());
      rethrow;
    }
  }

  // Update existing listing
  Future<void> updateListing(ServiceListing listing) async {
    try {
      print('🔵 ServiceListingsNotifier: Updating listing: ${listing.id}');
      
      final updatedListing = await _serviceListingService.updateListing(listing);
      
      // Update state with updated listing
      state = await AsyncValue.guard(() async {
        final currentListings = state.value ?? [];
        final updatedListings = currentListings.map((l) {
          return l.id == listing.id ? updatedListing : l;
        }).toList();
        return updatedListings;
      });
      
      print('🟢 ServiceListingsNotifier: Listing updated successfully');
    } catch (e) {
      print('🔴 ServiceListingsNotifier: Error updating listing: $e');
      rethrow;
    }
  }

  // Delete listing
  Future<void> deleteListing(String listingId) async {
    try {
      print('🔵 ServiceListingsNotifier: Deleting listing: $listingId');
      
      await _serviceListingService.deleteListing(listingId);
      
      // Update state by removing the deleted listing
      state = await AsyncValue.guard(() async {
        final currentListings = state.value ?? [];
        return currentListings.where((l) => l.id != listingId).toList();
      });
      
      print('🟢 ServiceListingsNotifier: Listing deleted successfully');
    } catch (e) {
      print('🔴 ServiceListingsNotifier: Error deleting listing: $e');
      rethrow;
    }
  }

  // Toggle listing status
  Future<void> toggleListingStatus(String listingId, bool isActive) async {
    try {
      print('🔵 ServiceListingsNotifier: Toggling listing status: $listingId to $isActive');
      
      final updatedListing = await _serviceListingService.toggleListingStatus(listingId, isActive);
      
      // Update state with updated listing
      state = await AsyncValue.guard(() async {
        final currentListings = state.value ?? [];
        final updatedListings = currentListings.map((l) {
          return l.id == listingId ? updatedListing : l;
        }).toList();
        return updatedListings;
      });
      
      print('🟢 ServiceListingsNotifier: Listing status updated successfully');
    } catch (e) {
      print('🔴 ServiceListingsNotifier: Error toggling listing status: $e');
      rethrow;
    }
  }
}

// Provider for creating new listing state management
final createListingStateProvider = StateNotifierProvider<CreateListingStateNotifier, CreateListingState>(
  (ref) => CreateListingStateNotifier(),
);

class CreateListingStateNotifier extends StateNotifier<CreateListingState> {
  CreateListingStateNotifier() : super(const CreateListingState());

  void updateBasicInfo({
    String? title,
    String? category,
    List<String>? themeTags,
  }) {
    state = state.copyWith(
      title: title,
      category: category,
      themeTags: themeTags,
    );
  }

  void updatePricing({
    double? originalPrice,
    double? offerPrice,
    String? promotionalTag,
  }) {
    state = state.copyWith(
      originalPrice: originalPrice,
      offerPrice: offerPrice,
      promotionalTag: promotionalTag,
    );
  }

  void updateDetails({
    String? description,
    List<String>? inclusions,
    bool? customizationAvailable,
    String? customizationNote,
    String? setupTime,
    String? bookingNotice,
  }) {
    state = state.copyWith(
      description: description,
      inclusions: inclusions,
      customizationAvailable: customizationAvailable,
      customizationNote: customizationNote,
      setupTime: setupTime,
      bookingNotice: bookingNotice,
    );
  }

  void updateArea({
    List<String>? pincodes,
    List<String>? venueTypes,
  }) {
    state = state.copyWith(
      pincodes: pincodes,
      venueTypes: venueTypes,
    );
  }

  void updateMedia({
    String? coverPhoto,
    List<String>? photos,
    String? videoUrl,
  }) {
    state = state.copyWith(
      coverPhoto: coverPhoto,
      photos: photos,
      videoUrl: videoUrl,
    );
  }

  void reset() {
    state = const CreateListingState();
  }

  bool get isValid {
    return state.title?.isNotEmpty == true &&
           state.category?.isNotEmpty == true &&
           state.originalPrice != null &&
           state.offerPrice != null &&
           state.setupTime?.isNotEmpty == true &&
           state.bookingNotice?.isNotEmpty == true;
  }
}

class CreateListingState {
  final String? title;
  final String? category;
  final List<String>? themeTags;
  final String? coverPhoto;
  final List<String>? photos;
  final String? videoUrl;
  final double? originalPrice;
  final double? offerPrice;
  final String? promotionalTag;
  final String? description;
  final List<String>? inclusions;
  final bool? customizationAvailable;
  final String? customizationNote;
  final String? setupTime;
  final String? bookingNotice;
  final List<String>? pincodes;
  final List<String>? venueTypes;

  const CreateListingState({
    this.title,
    this.category,
    this.themeTags,
    this.coverPhoto,
    this.photos,
    this.videoUrl,
    this.originalPrice,
    this.offerPrice,
    this.promotionalTag,
    this.description,
    this.inclusions,
    this.customizationAvailable,
    this.customizationNote,
    this.setupTime,
    this.bookingNotice,
    this.pincodes,
    this.venueTypes,
  });

  CreateListingState copyWith({
    String? title,
    String? category,
    List<String>? themeTags,
    String? coverPhoto,
    List<String>? photos,
    String? videoUrl,
    double? originalPrice,
    double? offerPrice,
    String? promotionalTag,
    String? description,
    List<String>? inclusions,
    bool? customizationAvailable,
    String? customizationNote,
    String? setupTime,
    String? bookingNotice,
    List<String>? pincodes,
    List<String>? venueTypes,
  }) {
    return CreateListingState(
      title: title ?? this.title,
      category: category ?? this.category,
      themeTags: themeTags ?? this.themeTags,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      photos: photos ?? this.photos,
      videoUrl: videoUrl ?? this.videoUrl,
      originalPrice: originalPrice ?? this.originalPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      promotionalTag: promotionalTag ?? this.promotionalTag,
      description: description ?? this.description,
      inclusions: inclusions ?? this.inclusions,
      customizationAvailable: customizationAvailable ?? this.customizationAvailable,
      customizationNote: customizationNote ?? this.customizationNote,
      setupTime: setupTime ?? this.setupTime,
      bookingNotice: bookingNotice ?? this.bookingNotice,
      pincodes: pincodes ?? this.pincodes,
      venueTypes: venueTypes ?? this.venueTypes,
    );
  }
} 