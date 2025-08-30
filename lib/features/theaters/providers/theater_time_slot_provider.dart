import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/theater_time_slot.dart';
import '../service/theater_time_slot_service.dart';

part 'theater_time_slot_provider.g.dart';

// Provider to get time slots for a specific screen
@riverpod
Future<List<TheaterTimeSlot>> screenTimeSlots(Ref ref, String screenId) async {
  final service = ref.watch(theaterTimeSlotServiceProvider);
  return service.getScreenTimeSlots(screenId);
}

// Provider to get time slots for a specific theater
@riverpod
Future<List<TheaterTimeSlot>> theaterTimeSlots(Ref ref, String theaterId) async {
  final service = ref.watch(theaterTimeSlotServiceProvider);
  return service.getTheaterTimeSlots(theaterId);
}

// Provider to get available slots for a specific screen (recurring slots)
@riverpod
Future<List<TheaterTimeSlot>> availableTimeSlots(
  Ref ref, {
  required String screenId,
}) async {
  final service = ref.watch(theaterTimeSlotServiceProvider);
  return service.getAvailableSlots(screenId: screenId);
}