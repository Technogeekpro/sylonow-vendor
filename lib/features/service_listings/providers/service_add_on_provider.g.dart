// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_add_on_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceAddOnsNotifierHash() =>
    r'a80f0930aa414664bffbbf89b07c186a812967f8';

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

abstract class _$ServiceAddOnsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<ServiceAddOn>> {
  late final String serviceListingId;

  FutureOr<List<ServiceAddOn>> build(
    String serviceListingId,
  );
}

/// Provider for service add-ons for a specific service listing
///
/// Copied from [ServiceAddOnsNotifier].
@ProviderFor(ServiceAddOnsNotifier)
const serviceAddOnsNotifierProvider = ServiceAddOnsNotifierFamily();

/// Provider for service add-ons for a specific service listing
///
/// Copied from [ServiceAddOnsNotifier].
class ServiceAddOnsNotifierFamily
    extends Family<AsyncValue<List<ServiceAddOn>>> {
  /// Provider for service add-ons for a specific service listing
  ///
  /// Copied from [ServiceAddOnsNotifier].
  const ServiceAddOnsNotifierFamily();

  /// Provider for service add-ons for a specific service listing
  ///
  /// Copied from [ServiceAddOnsNotifier].
  ServiceAddOnsNotifierProvider call(
    String serviceListingId,
  ) {
    return ServiceAddOnsNotifierProvider(
      serviceListingId,
    );
  }

  @override
  ServiceAddOnsNotifierProvider getProviderOverride(
    covariant ServiceAddOnsNotifierProvider provider,
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
  String? get name => r'serviceAddOnsNotifierProvider';
}

/// Provider for service add-ons for a specific service listing
///
/// Copied from [ServiceAddOnsNotifier].
class ServiceAddOnsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ServiceAddOnsNotifier,
        List<ServiceAddOn>> {
  /// Provider for service add-ons for a specific service listing
  ///
  /// Copied from [ServiceAddOnsNotifier].
  ServiceAddOnsNotifierProvider(
    String serviceListingId,
  ) : this._internal(
          () => ServiceAddOnsNotifier()..serviceListingId = serviceListingId,
          from: serviceAddOnsNotifierProvider,
          name: r'serviceAddOnsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceAddOnsNotifierHash,
          dependencies: ServiceAddOnsNotifierFamily._dependencies,
          allTransitiveDependencies:
              ServiceAddOnsNotifierFamily._allTransitiveDependencies,
          serviceListingId: serviceListingId,
        );

  ServiceAddOnsNotifierProvider._internal(
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
  FutureOr<List<ServiceAddOn>> runNotifierBuild(
    covariant ServiceAddOnsNotifier notifier,
  ) {
    return notifier.build(
      serviceListingId,
    );
  }

  @override
  Override overrideWith(ServiceAddOnsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ServiceAddOnsNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ServiceAddOnsNotifier,
      List<ServiceAddOn>> createElement() {
    return _ServiceAddOnsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceAddOnsNotifierProvider &&
        other.serviceListingId == serviceListingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceListingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceAddOnsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<ServiceAddOn>> {
  /// The parameter `serviceListingId` of this provider.
  String get serviceListingId;
}

class _ServiceAddOnsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ServiceAddOnsNotifier,
        List<ServiceAddOn>> with ServiceAddOnsNotifierRef {
  _ServiceAddOnsNotifierProviderElement(super.provider);

  @override
  String get serviceListingId =>
      (origin as ServiceAddOnsNotifierProvider).serviceListingId;
}

String _$vendorAddOnsNotifierHash() =>
    r'fd0c566e9e7af6462d6a86b7499a1d3e0ee3a4ce';

abstract class _$VendorAddOnsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<ServiceAddOn>> {
  late final String vendorId;

  FutureOr<List<ServiceAddOn>> build(
    String vendorId,
  );
}

/// Provider for all add-ons managed by a vendor
///
/// Copied from [VendorAddOnsNotifier].
@ProviderFor(VendorAddOnsNotifier)
const vendorAddOnsNotifierProvider = VendorAddOnsNotifierFamily();

/// Provider for all add-ons managed by a vendor
///
/// Copied from [VendorAddOnsNotifier].
class VendorAddOnsNotifierFamily
    extends Family<AsyncValue<List<ServiceAddOn>>> {
  /// Provider for all add-ons managed by a vendor
  ///
  /// Copied from [VendorAddOnsNotifier].
  const VendorAddOnsNotifierFamily();

  /// Provider for all add-ons managed by a vendor
  ///
  /// Copied from [VendorAddOnsNotifier].
  VendorAddOnsNotifierProvider call(
    String vendorId,
  ) {
    return VendorAddOnsNotifierProvider(
      vendorId,
    );
  }

  @override
  VendorAddOnsNotifierProvider getProviderOverride(
    covariant VendorAddOnsNotifierProvider provider,
  ) {
    return call(
      provider.vendorId,
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
  String? get name => r'vendorAddOnsNotifierProvider';
}

/// Provider for all add-ons managed by a vendor
///
/// Copied from [VendorAddOnsNotifier].
class VendorAddOnsNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    VendorAddOnsNotifier, List<ServiceAddOn>> {
  /// Provider for all add-ons managed by a vendor
  ///
  /// Copied from [VendorAddOnsNotifier].
  VendorAddOnsNotifierProvider(
    String vendorId,
  ) : this._internal(
          () => VendorAddOnsNotifier()..vendorId = vendorId,
          from: vendorAddOnsNotifierProvider,
          name: r'vendorAddOnsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vendorAddOnsNotifierHash,
          dependencies: VendorAddOnsNotifierFamily._dependencies,
          allTransitiveDependencies:
              VendorAddOnsNotifierFamily._allTransitiveDependencies,
          vendorId: vendorId,
        );

  VendorAddOnsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vendorId,
  }) : super.internal();

  final String vendorId;

  @override
  FutureOr<List<ServiceAddOn>> runNotifierBuild(
    covariant VendorAddOnsNotifier notifier,
  ) {
    return notifier.build(
      vendorId,
    );
  }

  @override
  Override overrideWith(VendorAddOnsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VendorAddOnsNotifierProvider._internal(
        () => create()..vendorId = vendorId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vendorId: vendorId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VendorAddOnsNotifier,
      List<ServiceAddOn>> createElement() {
    return _VendorAddOnsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VendorAddOnsNotifierProvider && other.vendorId == vendorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vendorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VendorAddOnsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<ServiceAddOn>> {
  /// The parameter `vendorId` of this provider.
  String get vendorId;
}

class _VendorAddOnsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VendorAddOnsNotifier,
        List<ServiceAddOn>> with VendorAddOnsNotifierRef {
  _VendorAddOnsNotifierProviderElement(super.provider);

  @override
  String get vendorId => (origin as VendorAddOnsNotifierProvider).vendorId;
}

String _$addOnFormNotifierHash() => r'cb986cdb2130a4faf87fe9f2977bebe22bba8636';

/// Provider for add-on form state
///
/// Copied from [AddOnFormNotifier].
@ProviderFor(AddOnFormNotifier)
final addOnFormNotifierProvider =
    AutoDisposeNotifierProvider<AddOnFormNotifier, ServiceAddOn?>.internal(
  AddOnFormNotifier.new,
  name: r'addOnFormNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addOnFormNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddOnFormNotifier = AutoDisposeNotifier<ServiceAddOn?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
