import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/connectivity_service.dart';

part 'connectivity_provider.g.dart';

@riverpod
ConnectivityService connectivityService(Ref ref) {
  final service = ConnectivityService();
  
  // Clean up service when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
}

@riverpod
class ConnectivityStatus extends _$ConnectivityStatus {
  @override
  Stream<bool> build() {
    final service = ref.watch(connectivityServiceProvider);
    
    // Return the connectivity stream
    return service.connectivityStream;
  }

  // Method to manually check connectivity
  Future<bool> checkConnectivity() async {
    final service = ref.read(connectivityServiceProvider);
    return await service.hasInternetConnection();
  }

  // Get connectivity status as string
  Future<String> getStatusString() async {
    final service = ref.read(connectivityServiceProvider);
    return await service.getConnectivityStatus();
  }
}

// Provider for current connectivity state (boolean)
@riverpod
class CurrentConnectivity extends _$CurrentConnectivity {
  @override
  Future<bool> build() async {
    final service = ref.watch(connectivityServiceProvider);
    
    // Get initial connectivity status
    final initialStatus = await service.hasInternetConnection();
    
    // Listen to changes and update state
    service.connectivityStream.listen((isConnected) {
      // Update state when connectivity changes
      state = AsyncValue.data(isConnected);
    });
    
    return initialStatus;
  }

  // Force refresh connectivity status
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(connectivityServiceProvider);
      return await service.hasInternetConnection();
    });
  }
}