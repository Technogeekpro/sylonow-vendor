// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_theaters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vendorTheatersHash() => r'5eed2c560652c012317533e6de99568467debea4';

/// See also [VendorTheaters].
@ProviderFor(VendorTheaters)
final vendorTheatersProvider = AutoDisposeAsyncNotifierProvider<VendorTheaters,
    List<PrivateTheater>>.internal(
  VendorTheaters.new,
  name: r'vendorTheatersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vendorTheatersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VendorTheaters = AutoDisposeAsyncNotifier<List<PrivateTheater>>;
String _$theaterScreensCountHash() =>
    r'ed963effdb15416c205b4946b96df75811febdbd';

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

abstract class _$TheaterScreensCount
    extends BuildlessAutoDisposeAsyncNotifier<int> {
  late final String theaterId;

  FutureOr<int> build(
    String theaterId,
  );
}

/// See also [TheaterScreensCount].
@ProviderFor(TheaterScreensCount)
const theaterScreensCountProvider = TheaterScreensCountFamily();

/// See also [TheaterScreensCount].
class TheaterScreensCountFamily extends Family<AsyncValue<int>> {
  /// See also [TheaterScreensCount].
  const TheaterScreensCountFamily();

  /// See also [TheaterScreensCount].
  TheaterScreensCountProvider call(
    String theaterId,
  ) {
    return TheaterScreensCountProvider(
      theaterId,
    );
  }

  @override
  TheaterScreensCountProvider getProviderOverride(
    covariant TheaterScreensCountProvider provider,
  ) {
    return call(
      provider.theaterId,
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
  String? get name => r'theaterScreensCountProvider';
}

/// See also [TheaterScreensCount].
class TheaterScreensCountProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TheaterScreensCount, int> {
  /// See also [TheaterScreensCount].
  TheaterScreensCountProvider(
    String theaterId,
  ) : this._internal(
          () => TheaterScreensCount()..theaterId = theaterId,
          from: theaterScreensCountProvider,
          name: r'theaterScreensCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$theaterScreensCountHash,
          dependencies: TheaterScreensCountFamily._dependencies,
          allTransitiveDependencies:
              TheaterScreensCountFamily._allTransitiveDependencies,
          theaterId: theaterId,
        );

  TheaterScreensCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.theaterId,
  }) : super.internal();

  final String theaterId;

  @override
  FutureOr<int> runNotifierBuild(
    covariant TheaterScreensCount notifier,
  ) {
    return notifier.build(
      theaterId,
    );
  }

  @override
  Override overrideWith(TheaterScreensCount Function() create) {
    return ProviderOverride(
      origin: this,
      override: TheaterScreensCountProvider._internal(
        () => create()..theaterId = theaterId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        theaterId: theaterId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TheaterScreensCount, int>
      createElement() {
    return _TheaterScreensCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TheaterScreensCountProvider && other.theaterId == theaterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, theaterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TheaterScreensCountRef on AutoDisposeAsyncNotifierProviderRef<int> {
  /// The parameter `theaterId` of this provider.
  String get theaterId;
}

class _TheaterScreensCountProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TheaterScreensCount, int>
    with TheaterScreensCountRef {
  _TheaterScreensCountProviderElement(super.provider);

  @override
  String get theaterId => (origin as TheaterScreensCountProvider).theaterId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
