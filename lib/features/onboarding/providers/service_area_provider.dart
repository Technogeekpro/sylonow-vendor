import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_area.dart';
import '../service/service_area_service.dart';
import 'vendor_provider.dart';

final serviceAreaServiceProvider = Provider((ref) => ServiceAreaService());

final primaryServiceAreaProvider = FutureProvider.autoDispose<ServiceArea?>((ref) async {
  final vendor = await ref.watch(vendorProvider.future);
  
  if (vendor == null) {
    return null;
  }
  
  final serviceAreaService = ref.read(serviceAreaServiceProvider);
  return await serviceAreaService.getPrimaryServiceArea(vendor.id);
});

final allServiceAreasProvider = FutureProvider.autoDispose.family<List<ServiceArea>, String>((ref, vendorId) async {
  final serviceAreaService = ref.read(serviceAreaServiceProvider);
  return await serviceAreaService.getServiceAreas(vendorId);
}); 