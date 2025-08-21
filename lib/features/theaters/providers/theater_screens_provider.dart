import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/theater_screen.dart';
import '../service/theater_management_service.dart';

part 'theater_screens_provider.g.dart';

@riverpod
class TheaterScreens extends _$TheaterScreens {
  @override
  Future<List<TheaterScreen>> build(String theaterId) async {
    return ref.watch(theaterManagementServiceProvider).getTheaterScreens(theaterId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> addScreen(TheaterScreen screen) async {
    final service = ref.read(theaterManagementServiceProvider);
    await service.addTheaterScreen(screen);
    ref.invalidateSelf();
  }

  Future<void> updateScreen(String screenId, Map<String, dynamic> updates) async {
    final service = ref.read(theaterManagementServiceProvider);
    await service.updateTheaterScreen(screenId, updates);
    ref.invalidateSelf();
  }

  Future<void> deleteScreen(String screenId) async {
    final service = ref.read(theaterManagementServiceProvider);
    await service.deleteTheaterScreen(screenId);
    ref.invalidateSelf();
  }
}