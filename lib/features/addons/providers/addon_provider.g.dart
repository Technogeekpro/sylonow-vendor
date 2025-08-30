// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vendorAddonsHash() => r'9faea84738a5e7e4b7371b8997765350cfb295fc';

/// See also [vendorAddons].
@ProviderFor(vendorAddons)
final vendorAddonsProvider = AutoDisposeFutureProvider<List<Addon>>.internal(
  vendorAddons,
  name: r'vendorAddonsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$vendorAddonsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef VendorAddonsRef = AutoDisposeFutureProviderRef<List<Addon>>;
String _$addonsByCategoryHash() => r'32cf49e799f8d32259ea52d90b67119d3a73c343';

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

/// See also [addonsByCategory].
@ProviderFor(addonsByCategory)
const addonsByCategoryProvider = AddonsByCategoryFamily();

/// See also [addonsByCategory].
class AddonsByCategoryFamily extends Family<AsyncValue<List<Addon>>> {
  /// See also [addonsByCategory].
  const AddonsByCategoryFamily();

  /// See also [addonsByCategory].
  AddonsByCategoryProvider call(
    String category,
  ) {
    return AddonsByCategoryProvider(
      category,
    );
  }

  @override
  AddonsByCategoryProvider getProviderOverride(
    covariant AddonsByCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'addonsByCategoryProvider';
}

/// See also [addonsByCategory].
class AddonsByCategoryProvider extends AutoDisposeFutureProvider<List<Addon>> {
  /// See also [addonsByCategory].
  AddonsByCategoryProvider(
    String category,
  ) : this._internal(
          (ref) => addonsByCategory(
            ref as AddonsByCategoryRef,
            category,
          ),
          from: addonsByCategoryProvider,
          name: r'addonsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addonsByCategoryHash,
          dependencies: AddonsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              AddonsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  AddonsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<Addon>> Function(AddonsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddonsByCategoryProvider._internal(
        (ref) => create(ref as AddonsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Addon>> createElement() {
    return _AddonsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddonsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddonsByCategoryRef on AutoDisposeFutureProviderRef<List<Addon>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _AddonsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Addon>>
    with AddonsByCategoryRef {
  _AddonsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as AddonsByCategoryProvider).category;
}

String _$availableCategoriesHash() =>
    r'6776477222594dbac74c1a13c3cf2bcf1ab949cb';

/// See also [availableCategories].
@ProviderFor(availableCategories)
final availableCategoriesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  availableCategories,
  name: r'availableCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AvailableCategoriesRef = AutoDisposeFutureProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
