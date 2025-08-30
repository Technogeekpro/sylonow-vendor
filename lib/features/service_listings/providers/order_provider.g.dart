// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceListingOrderCountsHash() =>
    r'827b0a9652c1788a4b1717e43d36fd3cccc02335';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [serviceListingOrderCounts].
@ProviderFor(serviceListingOrderCounts)
const serviceListingOrderCountsProvider = ServiceListingOrderCountsFamily();

/// See also [serviceListingOrderCounts].
class ServiceListingOrderCountsFamily
    extends Family<AsyncValue<Map<String, int>>> {
  /// See also [serviceListingOrderCounts].
  const ServiceListingOrderCountsFamily();

  /// See also [serviceListingOrderCounts].
  ServiceListingOrderCountsProvider call(
    String serviceListingId,
  ) {
    return ServiceListingOrderCountsProvider(
      serviceListingId,
    );
  }

  @override
  ServiceListingOrderCountsProvider getProviderOverride(
    covariant ServiceListingOrderCountsProvider provider,
  ) {
    return call(
      provider.serviceListingId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'serviceListingOrderCountsProvider';
}

/// See also [serviceListingOrderCounts].
class ServiceListingOrderCountsProvider
    extends AutoDisposeFutureProvider<Map<String, int>> {
  /// See also [serviceListingOrderCounts].
  ServiceListingOrderCountsProvider(
    String serviceListingId,
  ) : this._internal(
          (ref) => serviceListingOrderCounts(
            ref as ServiceListingOrderCountsRef,
            serviceListingId,
          ),
          from: serviceListingOrderCountsProvider,
          name: r'serviceListingOrderCountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceListingOrderCountsHash,
          dependencies: ServiceListingOrderCountsFamily._dependencies,
          allTransitiveDependencies:
              ServiceListingOrderCountsFamily._allTransitiveDependencies,
          serviceListingId: serviceListingId,
        );

  ServiceListingOrderCountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceListingId,
  }) : super.internal();

  final String serviceListingId;

  @override
  Override overrideWith(
    FutureOr<Map<String, int>> Function(ServiceListingOrderCountsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceListingOrderCountsProvider._internal(
        (ref) => create(ref as ServiceListingOrderCountsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceListingId: serviceListingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, int>> createElement() {
    return _ServiceListingOrderCountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceListingOrderCountsProvider &&
        other.serviceListingId == serviceListingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceListingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceListingOrderCountsRef
    on AutoDisposeFutureProviderRef<Map<String, int>> {
  /// The parameter `serviceListingId` of this provider.
  String get serviceListingId;
}

class _ServiceListingOrderCountsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, int>>
    with ServiceListingOrderCountsRef {
  _ServiceListingOrderCountsProviderElement(super.provider);

  @override
  String get serviceListingId =>
      (origin as ServiceListingOrderCountsProvider).serviceListingId;
}

String _$serviceListingOrdersHash() =>
    r'6ac75418f324b0ebc077f9ea090b442dbeb02c0f';

abstract class _$ServiceListingOrders
    extends BuildlessAutoDisposeAsyncNotifier<List<Order>> {
  late final String serviceListingId;

  FutureOr<List<Order>> build(
    String serviceListingId,
  );
}

/// See also [ServiceListingOrders].
@ProviderFor(ServiceListingOrders)
const serviceListingOrdersProvider = ServiceListingOrdersFamily();

/// See also [ServiceListingOrders].
class ServiceListingOrdersFamily extends Family<AsyncValue<List<Order>>> {
  /// See also [ServiceListingOrders].
  const ServiceListingOrdersFamily();

  /// See also [ServiceListingOrders].
  ServiceListingOrdersProvider call(
    String serviceListingId,
  ) {
    return ServiceListingOrdersProvider(
      serviceListingId,
    );
  }

  @override
  ServiceListingOrdersProvider getProviderOverride(
    covariant ServiceListingOrdersProvider provider,
  ) {
    return call(
      provider.serviceListingId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'serviceListingOrdersProvider';
}

/// See also [ServiceListingOrders].
class ServiceListingOrdersProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ServiceListingOrders, List<Order>> {
  /// See also [ServiceListingOrders].
  ServiceListingOrdersProvider(
    String serviceListingId,
  ) : this._internal(
          () => ServiceListingOrders()..serviceListingId = serviceListingId,
          from: serviceListingOrdersProvider,
          name: r'serviceListingOrdersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceListingOrdersHash,
          dependencies: ServiceListingOrdersFamily._dependencies,
          allTransitiveDependencies:
              ServiceListingOrdersFamily._allTransitiveDependencies,
          serviceListingId: serviceListingId,
        );

  ServiceListingOrdersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceListingId,
  }) : super.internal();

  final String serviceListingId;

  @override
  FutureOr<List<Order>> runNotifierBuild(
    covariant ServiceListingOrders notifier,
  ) {
    return notifier.build(
      serviceListingId,
    );
  }

  @override
  Override overrideWith(ServiceListingOrders Function() create) {
    return ProviderOverride(
      origin: this,
      override: ServiceListingOrdersProvider._internal(
        () => create()..serviceListingId = serviceListingId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceListingId: serviceListingId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ServiceListingOrders, List<Order>>
      createElement() {
    return _ServiceListingOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceListingOrdersProvider &&
        other.serviceListingId == serviceListingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceListingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceListingOrdersRef
    on AutoDisposeAsyncNotifierProviderRef<List<Order>> {
  /// The parameter `serviceListingId` of this provider.
  String get serviceListingId;
}

class _ServiceListingOrdersProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ServiceListingOrders,
        List<Order>> with ServiceListingOrdersRef {
  _ServiceListingOrdersProviderElement(super.provider);

  @override
  String get serviceListingId =>
      (origin as ServiceListingOrdersProvider).serviceListingId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
