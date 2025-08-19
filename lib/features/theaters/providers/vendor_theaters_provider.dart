import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/private_theater.dart';
import '../service/theater_management_service.dart';
import '../../onboarding/providers/vendor_provider.dart';

part 'vendor_theaters_provider.g.dart';

@riverpod
class VendorTheaters extends _$VendorTheaters {
  @override
  Future<List<PrivateTheater>> build() async {
    final vendor = await ref.watch(vendorProvider.future);
    if (vendor?.authUserId == null) {
      return [];
    }
    
    return ref.watch(theaterManagementServiceProvider).getVendorTheaters(vendor!.authUserId!);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> deleteTheater(String theaterId) async {
    final service = ref.read(theaterManagementServiceProvider);
    await service.deleteTheater(theaterId);
    ref.invalidateSelf();
  }
}

@riverpod
class TheaterScreensCount extends _$TheaterScreensCount {
  @override
  Future<int> build(String theaterId) async {
    return ref.watch(theaterManagementServiceProvider).getTheaterScreensCount(theaterId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}