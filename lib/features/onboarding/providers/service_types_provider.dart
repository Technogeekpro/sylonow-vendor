import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/service_types_service.dart';

/// Provider for fetching service types from Supabase
final serviceTypesProvider = FutureProvider<List<ServiceType>>((ref) async {
  final service = ref.read(serviceTypesServiceProvider);
  return service.getServiceTypes();
});

/// Provider for the currently selected service type
final selectedServiceTypeProvider = StateProvider<ServiceType?>((ref) => null); 