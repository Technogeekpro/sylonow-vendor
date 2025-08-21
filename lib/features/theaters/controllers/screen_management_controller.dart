import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/theater_screen.dart';
import '../models/theater_time_slot.dart';
import '../service/theater_service.dart';

// Provider for screen management controller with theater ID parameter
final screenManagementControllerProvider = 
    ChangeNotifierProvider.family<ScreenManagementController, String>((ref, theaterId) {
  return ScreenManagementController(ref, theaterId);
});

class ScreenManagementController extends ChangeNotifier {
  final Ref _ref;
  final String _theaterId;
  final TheaterService _theaterService;

  ScreenManagementController(this._ref, this._theaterId) 
      : _theaterService = _ref.read(theaterServiceProvider) {
    _loadData();
  }

  // State Variables
  List<TheaterScreen> _screens = [];
  List<TheaterTimeSlot> _timeSlots = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<TheaterScreen> get screens => _screens;
  List<TheaterTimeSlot> get timeSlots => _timeSlots;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load initial data
  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('🔵 Loading data for theater: $_theaterId');
      
      // Load screens and time slots
      await Future.wait([
        _loadScreens(),
        _loadTimeSlots(),
      ]);
      
      print('🟢 Data loaded successfully - Screens: ${_screens.length}, Time Slots: ${_timeSlots.length}');
    } catch (e) {
      print('🔴 Error loading data: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load screens for this theater
  Future<void> _loadScreens() async {
    try {
      _screens = await _theaterService.getTheaterScreens(_theaterId);
      print('🔵 Loaded ${_screens.length} screens');
    } catch (e) {
      print('🔴 Error loading screens: $e');
      _screens = [];
    }
  }

  // Load time slots for this theater
  Future<void> _loadTimeSlots() async {
    try {
      _timeSlots = await _theaterService.getTheaterTimeSlots(_theaterId);
      print('🔵 Loaded ${_timeSlots.length} time slots');
    } catch (e) {
      print('🔴 Error loading time slots: $e');
      _timeSlots = [];
    }
  }

  // Refresh all data
  Future<void> refresh() async {
    await _loadData();
  }

  // Screen Management Methods
  Future<void> addScreen(TheaterScreen screen) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Create screen with theater ID
      final newScreen = screen.copyWith(theaterId: _theaterId);
      final createdScreen = await _theaterService.createScreen(newScreen);
      
      _screens.add(createdScreen);
      print('🟢 Screen added successfully: ${createdScreen.screenName}');
    } catch (e) {
      print('🔴 Error adding screen: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateScreen(TheaterScreen screen) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updatedScreen = await _theaterService.updateScreen(screen);
      
      final index = _screens.indexWhere((s) => s.id == screen.id);
      if (index != -1) {
        _screens[index] = updatedScreen;
      }
      
      print('🟢 Screen updated successfully: ${updatedScreen.screenName}');
    } catch (e) {
      print('🔴 Error updating screen: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteScreen(String screenId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _theaterService.deleteScreen(screenId);
      
      _screens.removeWhere((s) => s.id == screenId);
      // Also remove associated time slots
      _timeSlots.removeWhere((ts) => ts.screenId == screenId);
      
      print('🟢 Screen deleted successfully');
    } catch (e) {
      print('🔴 Error deleting screen: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Time Slot Management Methods
  Future<void> addTimeSlot(TheaterTimeSlot timeSlot) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Create time slot with theater ID
      final newTimeSlot = timeSlot.copyWith(theaterId: _theaterId);
      final createdTimeSlots = await _theaterService.createTimeSlots([newTimeSlot]);
      
      if (createdTimeSlots.isNotEmpty) {
        _timeSlots.add(createdTimeSlots.first);
      }
      
      print('🟢 Time slot added successfully');
    } catch (e) {
      print('🔴 Error adding time slot: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMultipleTimeSlots(List<TheaterTimeSlot> timeSlots) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Create time slots with theater ID
      final newTimeSlots = timeSlots
          .map((ts) => ts.copyWith(theaterId: _theaterId))
          .toList();
      
      final createdTimeSlots = await _theaterService.createTimeSlots(newTimeSlots);
      
      _timeSlots.addAll(createdTimeSlots);
      print('🟢 ${createdTimeSlots.length} time slots added successfully');
    } catch (e) {
      print('🔴 Error adding time slots: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTimeSlot(TheaterTimeSlot timeSlot) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updatedTimeSlot = await _theaterService.updateTimeSlot(timeSlot);
      
      final index = _timeSlots.indexWhere((ts) => ts.id == timeSlot.id);
      if (index != -1) {
        _timeSlots[index] = updatedTimeSlot;
      }
      
      print('🟢 Time slot updated successfully');
    } catch (e) {
      print('🔴 Error updating time slot: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTimeSlot(String timeSlotId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _theaterService.deleteTimeSlots([timeSlotId]);
      
      _timeSlots.removeWhere((ts) => ts.id == timeSlotId);
      print('🟢 Time slot deleted successfully');
    } catch (e) {
      print('🔴 Error deleting time slot: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAllTimeSlots() async {
    try {
      _isLoading = true;
      notifyListeners();

      final timeSlotIds = _timeSlots.map((ts) => ts.id).toList();
      
      if (timeSlotIds.isNotEmpty) {
        await _theaterService.deleteTimeSlots(timeSlotIds);
        _timeSlots.clear();
        print('🟢 All time slots deleted successfully');
      }
    } catch (e) {
      print('🔴 Error deleting all time slots: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper Methods
  List<TheaterTimeSlot> getTimeSlotsForScreen(String screenId) {
    return _timeSlots.where((ts) => ts.screenId == screenId).toList();
  }

  List<TheaterTimeSlot> getGeneralTimeSlots() {
    return _timeSlots.where((ts) => ts.screenId == null || ts.screenId!.isEmpty).toList();
  }

  // Generate time slots automatically
  Future<void> generateTimeSlots({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int durationHours,
    required double basePrice,
    required double pricePerHour,
    String? screenId,
    double weekdayMultiplier = 1.0,
    double weekendMultiplier = 1.5,
    double holidayMultiplier = 2.0,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final slots = <TheaterTimeSlot>[];
      
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;
      final durationMinutes = durationHours * 60;
      
      for (int currentMinutes = startMinutes; 
           currentMinutes + durationMinutes <= endMinutes; 
           currentMinutes += durationMinutes) {
        
        final startHour = currentMinutes ~/ 60;
        final startMinute = currentMinutes % 60;
        final endCurrentMinutes = currentMinutes + durationMinutes;
        final endHour = endCurrentMinutes ~/ 60;
        final endMinuteValue = endCurrentMinutes % 60;
        
        final slot = TheaterTimeSlot(
          id: '',
          theaterId: _theaterId,
          screenId: screenId,
          startTime: '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}',
          endTime: '${endHour.toString().padLeft(2, '0')}:${endMinuteValue.toString().padLeft(2, '0')}',
          basePrice: basePrice,
          pricePerHour: pricePerHour,
          weekdayMultiplier: weekdayMultiplier,
          weekendMultiplier: weekendMultiplier,
          holidayMultiplier: holidayMultiplier,
          maxDurationHours: durationHours,
          minDurationHours: durationHours,
        );
        
        slots.add(slot);
      }
      
      if (slots.isNotEmpty) {
        await addMultipleTimeSlots(slots);
      }
      
      print('🟢 Generated ${slots.length} time slots successfully');
    } catch (e) {
      print('🔴 Error generating time slots: $e');
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}