// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityServiceHash() =>
    r'69ed6e1850d812c4c2ad3886552ee14f280234b1';

/// See also [connectivityService].
@ProviderFor(connectivityService)
final connectivityServiceProvider =
    AutoDisposeProvider<ConnectivityService>.internal(
  connectivityService,
  name: r'connectivityServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConnectivityServiceRef = AutoDisposeProviderRef<ConnectivityService>;
String _$connectivityStatusHash() =>
    r'd09840fe24761ebd4e80e793733fdc3129eebe81';

/// See also [ConnectivityStatus].
@ProviderFor(ConnectivityStatus)
final connectivityStatusProvider =
    AutoDisposeStreamNotifierProvider<ConnectivityStatus, bool>.internal(
  ConnectivityStatus.new,
  name: r'connectivityStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectivityStatus = AutoDisposeStreamNotifier<bool>;
String _$currentConnectivityHash() =>
    r'a8f6dba620efbd335dedd2310093def29fa82ee9';

/// See also [CurrentConnectivity].
@ProviderFor(CurrentConnectivity)
final currentConnectivityProvider =
    AutoDisposeAsyncNotifierProvider<CurrentConnectivity, bool>.internal(
  CurrentConnectivity.new,
  name: r'currentConnectivityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentConnectivityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentConnectivity = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
