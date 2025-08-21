import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/private_theater.dart';
import '../models/theater_screen.dart';
import '../models/theater_time_slot.dart';
import '../service/theater_service.dart';
import '../../onboarding/providers/vendor_provider.dart';

// Provider for vendor's theaters
final theatersProvider = AsyncNotifierProvider<TheatersNotifier, List<PrivateTheater>>(
  () => TheatersNotifier(),
);

class TheatersNotifier extends AsyncNotifier<List<PrivateTheater>> {
  late TheaterService _theaterService;

  @override
  Future<List<PrivateTheater>> build() async {
    _theaterService = ref.read(theaterServiceProvider);
    return _loadTheaters();
  }

  Future<List<PrivateTheater>> _loadTheaters() async {
    try {
      print('🔵 TheatersNotifier: Loading theaters...');
      
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.authUserId == null) {
        print('🔴 TheatersNotifier: No auth user ID found');
        throw Exception('Auth user not found');
      }

      print('🔵 TheatersNotifier: Auth User ID: ${vendor!.authUserId}');
      final theaters = await _theaterService.getVendorTheaters(vendor.authUserId!);
      
      print('🟢 TheatersNotifier: Loaded ${theaters.length} theaters');
      return theaters;
    } catch (e) {
      print('🔴 TheatersNotifier: Error loading theaters: $e');
      rethrow;
    }
  }

  // Refresh theaters
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadTheaters());
  }

  // Create new theater
  Future<void> createTheater(PrivateTheater theater) async {
    try {
      print('🔵 TheatersNotifier: Creating theater...');
      
      final vendor = await ref.read(vendorProvider.future);
      if (vendor?.authUserId == null) {
        throw Exception('Cannot create theater without an auth user.');
      }

      // Optimistically update the state
      state = const AsyncLoading();
      
      await _theaterService.createTheater(theater, vendor!.authUserId!);
      
      // Update state with new theater added
      state = await AsyncValue.guard(() async {
        final currentTheaters = await _loadTheaters();
        return currentTheaters;
      });
      
      print('🟢 TheatersNotifier: Theater created successfully');
    } catch (e) {
      print('🔴 TheatersNotifier: Error creating theater: $e');
      // Revert to previous state on error
      state = await AsyncValue.guard(() => _loadTheaters());
      rethrow;
    }
  }

  // Update existing theater
  Future<void> updateTheater(PrivateTheater theater) async {
    try {
      print('🔵 TheatersNotifier: Updating theater: ${theater.id}');
      
      final updatedTheater = await _theaterService.updateTheater(theater);
      
      // Update state with updated theater
      state = await AsyncValue.guard(() async {
        final currentTheaters = state.value ?? [];
        final updatedTheaters = currentTheaters.map((t) {
          return t.id == theater.id ? updatedTheater : t;
        }).toList();
        return updatedTheaters;
      });
      
      print('🟢 TheatersNotifier: Theater updated successfully');
    } catch (e) {
      print('🔴 TheatersNotifier: Error updating theater: $e');
      rethrow;
    }
  }

  // Delete theater
  Future<void> deleteTheater(String theaterId) async {
    try {
      print('🔵 TheatersNotifier: Deleting theater: $theaterId');
      
      await _theaterService.deleteTheater(theaterId);
      
      // Update state by removing the deleted theater
      state = await AsyncValue.guard(() async {
        final currentTheaters = state.value ?? [];
        return currentTheaters.where((t) => t.id != theaterId).toList();
      });
      
      print('🟢 TheatersNotifier: Theater deleted successfully');
    } catch (e) {
      print('🔴 TheatersNotifier: Error deleting theater: $e');
      rethrow;
    }
  }

  // Toggle theater status
  Future<void> toggleTheaterStatus(String theaterId, bool isActive) async {
    try {
      print('🔵 TheatersNotifier: Toggling theater status: $theaterId to $isActive');
      
      final updatedTheater = await _theaterService.toggleTheaterStatus(theaterId, isActive);
      
      // Update state with updated theater
      state = await AsyncValue.guard(() async {
        final currentTheaters = state.value ?? [];
        final updatedTheaters = currentTheaters.map((t) {
          return t.id == theaterId ? updatedTheater : t;
        }).toList();
        return updatedTheaters;
      });
      
      print('🟢 TheatersNotifier: Theater status updated successfully');
    } catch (e) {
      print('🔴 TheatersNotifier: Error toggling theater status: $e');
      rethrow;
    }
  }
}

// Provider for theater screens
final theaterScreensProvider = AsyncNotifierProvider.family<TheaterScreensNotifier, List<TheaterScreen>, String>(
  () => TheaterScreensNotifier(),
);

class TheaterScreensNotifier extends FamilyAsyncNotifier<List<TheaterScreen>, String> {
  late TheaterService _theaterService;

  @override
  Future<List<TheaterScreen>> build(String theaterId) async {
    _theaterService = ref.read(theaterServiceProvider);
    return _loadScreens(theaterId);
  }

  Future<List<TheaterScreen>> _loadScreens(String theaterId) async {
    try {
      print('🔵 TheaterScreensNotifier: Loading screens for theater: $theaterId');
      final screens = await _theaterService.getTheaterScreens(theaterId);
      print('🟢 TheaterScreensNotifier: Loaded ${screens.length} screens');
      return screens;
    } catch (e) {
      print('🔴 TheaterScreensNotifier: Error loading screens: $e');
      rethrow;
    }
  }

  // Create new screen
  Future<void> createScreen(TheaterScreen screen) async {
    try {
      print('🔵 TheaterScreensNotifier: Creating screen...');
      
      await _theaterService.createScreen(screen);
      
      // Refresh the screens list
      state = await AsyncValue.guard(() => _loadScreens(arg));
      
      print('🟢 TheaterScreensNotifier: Screen created successfully');
    } catch (e) {
      print('🔴 TheaterScreensNotifier: Error creating screen: $e');
      rethrow;
    }
  }

  // Update screen
  Future<void> updateScreen(TheaterScreen screen) async {
    try {
      print('🔵 TheaterScreensNotifier: Updating screen: ${screen.id}');
      
      final updatedScreen = await _theaterService.updateScreen(screen);
      
      // Update state with updated screen
      state = await AsyncValue.guard(() async {
        final currentScreens = state.value ?? [];
        final updatedScreens = currentScreens.map((s) {
          return s.id == screen.id ? updatedScreen : s;
        }).toList();
        return updatedScreens;
      });
      
      print('🟢 TheaterScreensNotifier: Screen updated successfully');
    } catch (e) {
      print('🔴 TheaterScreensNotifier: Error updating screen: $e');
      rethrow;
    }
  }

  // Delete screen
  Future<void> deleteScreen(String screenId) async {
    try {
      print('🔵 TheaterScreensNotifier: Deleting screen: $screenId');
      
      await _theaterService.deleteScreen(screenId);
      
      // Update state by removing the deleted screen
      state = await AsyncValue.guard(() async {
        final currentScreens = state.value ?? [];
        return currentScreens.where((s) => s.id != screenId).toList();
      });
      
      print('🟢 TheaterScreensNotifier: Screen deleted successfully');
    } catch (e) {
      print('🔴 TheaterScreensNotifier: Error deleting screen: $e');
      rethrow;
    }
  }
}

// Provider for theater time slots
final theaterTimeSlotsProvider = AsyncNotifierProvider.family<TheaterTimeSlotsNotifier, List<TheaterTimeSlot>, String>(
  () => TheaterTimeSlotsNotifier(),
);

class TheaterTimeSlotsNotifier extends FamilyAsyncNotifier<List<TheaterTimeSlot>, String> {
  late TheaterService _theaterService;

  @override
  Future<List<TheaterTimeSlot>> build(String theaterId) async {
    _theaterService = ref.read(theaterServiceProvider);
    return _loadTimeSlots(theaterId);
  }

  Future<List<TheaterTimeSlot>> _loadTimeSlots(String theaterId) async {
    try {
      print('🔵 TheaterTimeSlotsNotifier: Loading time slots for theater: $theaterId');
      final timeSlots = await _theaterService.getTheaterTimeSlots(theaterId);
      print('🟢 TheaterTimeSlotsNotifier: Loaded ${timeSlots.length} time slots');
      return timeSlots;
    } catch (e) {
      print('🔴 TheaterTimeSlotsNotifier: Error loading time slots: $e');
      rethrow;
    }
  }

  // Create time slots
  Future<void> createTimeSlots(List<TheaterTimeSlot> timeSlots) async {
    try {
      print('🔵 TheaterTimeSlotsNotifier: Creating ${timeSlots.length} time slots...');
      
      await _theaterService.createTimeSlots(timeSlots);
      
      // Refresh the time slots list
      state = await AsyncValue.guard(() => _loadTimeSlots(arg));
      
      print('🟢 TheaterTimeSlotsNotifier: Time slots created successfully');
    } catch (e) {
      print('🔴 TheaterTimeSlotsNotifier: Error creating time slots: $e');
      rethrow;
    }
  }

  // Update time slot
  Future<void> updateTimeSlot(TheaterTimeSlot timeSlot) async {
    try {
      print('🔵 TheaterTimeSlotsNotifier: Updating time slot: ${timeSlot.id}');
      
      final updatedTimeSlot = await _theaterService.updateTimeSlot(timeSlot);
      
      // Update state with updated time slot
      state = await AsyncValue.guard(() async {
        final currentTimeSlots = state.value ?? [];
        final updatedTimeSlots = currentTimeSlots.map((ts) {
          return ts.id == timeSlot.id ? updatedTimeSlot : ts;
        }).toList();
        return updatedTimeSlots;
      });
      
      print('🟢 TheaterTimeSlotsNotifier: Time slot updated successfully');
    } catch (e) {
      print('🔴 TheaterTimeSlotsNotifier: Error updating time slot: $e');
      rethrow;
    }
  }

  // Delete time slots
  Future<void> deleteTimeSlots(List<String> slotIds) async {
    try {
      print('🔵 TheaterTimeSlotsNotifier: Deleting ${slotIds.length} time slots');
      
      await _theaterService.deleteTimeSlots(slotIds);
      
      // Update state by removing the deleted time slots
      state = await AsyncValue.guard(() async {
        final currentTimeSlots = state.value ?? [];
        return currentTimeSlots.where((ts) => !slotIds.contains(ts.id)).toList();
      });
      
      print('🟢 TheaterTimeSlotsNotifier: Time slots deleted successfully');
    } catch (e) {
      print('🔴 TheaterTimeSlotsNotifier: Error deleting time slots: $e');
      rethrow;
    }
  }
}

// Provider for creating new theater state management
final createTheaterStateProvider = StateNotifierProvider<CreateTheaterStateNotifier, CreateTheaterState>(
  (ref) => CreateTheaterStateNotifier(),
);

class CreateTheaterStateNotifier extends StateNotifier<CreateTheaterState> {
  CreateTheaterStateNotifier() : super(const CreateTheaterState());

  void updateBasicInfo({
    String? name,
    String? description,
    int? capacity,
    double? hourlyRate,
  }) {
    state = state.copyWith(
      name: name,
      description: description,
      capacity: capacity,
      hourlyRate: hourlyRate,
    );
  }

  void updateLocation({
    String? address,
    String? city,
    String? stateName,
    String? pinCode,
    double? latitude,
    double? longitude,
  }) {
    state = state.copyWith(
      address: address,
      city: city,
      stateName: stateName,
      pinCode: pinCode,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void updateAmenities(List<String> amenities) {
    state = state.copyWith(amenities: amenities);
  }

  void updateImages(List<String> images) {
    state = state.copyWith(images: images);
  }

  void updateSettings({
    int? bookingDurationHours,
    int? advanceBookingDays,
    String? cancellationPolicy,
  }) {
    state = state.copyWith(
      bookingDurationHours: bookingDurationHours,
      advanceBookingDays: advanceBookingDays,
      cancellationPolicy: cancellationPolicy,
    );
  }

  void reset() {
    state = const CreateTheaterState();
  }

  bool get isValid {
    return state.name?.isNotEmpty == true &&
           state.address?.isNotEmpty == true &&
           state.city?.isNotEmpty == true &&
           state.stateName?.isNotEmpty == true &&
           state.pinCode?.isNotEmpty == true &&
           state.capacity != null &&
           state.hourlyRate != null;
  }
}

class CreateTheaterState {
  final String? name;
  final String? description;
  final String? address;
  final String? city;
  final String? stateName;
  final String? pinCode;
  final double? latitude;
  final double? longitude;
  final int? capacity;
  final List<String>? amenities;
  final List<String>? images;
  final double? hourlyRate;
  final int? bookingDurationHours;
  final int? advanceBookingDays;
  final String? cancellationPolicy;

  const CreateTheaterState({
    this.name,
    this.description,
    this.address,
    this.city,
    this.stateName,
    this.pinCode,
    this.latitude,
    this.longitude,
    this.capacity,
    this.amenities,
    this.images,
    this.hourlyRate,
    this.bookingDurationHours,
    this.advanceBookingDays,
    this.cancellationPolicy,
  });

  CreateTheaterState copyWith({
    String? name,
    String? description,
    String? address,
    String? city,
    String? stateName,
    String? pinCode,
    double? latitude,
    double? longitude,
    int? capacity,
    List<String>? amenities,
    List<String>? images,
    double? hourlyRate,
    int? bookingDurationHours,
    int? advanceBookingDays,
    String? cancellationPolicy,
  }) {
    return CreateTheaterState(
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      stateName: stateName ?? this.stateName,
      pinCode: pinCode ?? this.pinCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      capacity: capacity ?? this.capacity,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      bookingDurationHours: bookingDurationHours ?? this.bookingDurationHours,
      advanceBookingDays: advanceBookingDays ?? this.advanceBookingDays,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
    );
  }
}