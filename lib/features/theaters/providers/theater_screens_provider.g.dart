// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_screens_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$theaterScreensHash() => r'8007260a7ce448f393483949a6bc7b2526df9d0f';

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

abstract class _$TheaterScreens
    extends BuildlessAutoDisposeAsyncNotifier<List<TheaterScreen>> {
  late final String theaterId;

  FutureOr<List<TheaterScreen>> build(
    String theaterId,
  );
}

/// See also [TheaterScreens].
@ProviderFor(TheaterScreens)
const theaterScreensProvider = TheaterScreensFamily();

/// See also [TheaterScreens].
class TheaterScreensFamily extends Family<AsyncValue<List<TheaterScreen>>> {
  /// See also [TheaterScreens].
  const TheaterScreensFamily();

  /// See also [TheaterScreens].
  TheaterScreensProvider call(
    String theaterId,
  ) {
    return TheaterScreensProvider(
      theaterId,
    );
  }

  @override
  TheaterScreensProvider getProviderOverride(
    covariant TheaterScreensProvider provider,
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
  String? get name => r'theaterScreensProvider';
}

/// See also [TheaterScreens].
class TheaterScreensProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TheaterScreens, List<TheaterScreen>> {
  /// See also [TheaterScreens].
  TheaterScreensProvider(
    String theaterId,
  ) : this._internal(
          () => TheaterScreens()..theaterId = theaterId,
          from: theaterScreensProvider,
          name: r'theaterScreensProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$theaterScreensHash,
          dependencies: TheaterScreensFamily._dependencies,
          allTransitiveDependencies:
              TheaterScreensFamily._allTransitiveDependencies,
          theaterId: theaterId,
        );

  TheaterScreensProvider._internal(
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
  FutureOr<List<TheaterScreen>> runNotifierBuild(
    covariant TheaterScreens notifier,
  ) {
    return notifier.build(
      theaterId,
    );
  }

  @override
  Override overrideWith(TheaterScreens Function() create) {
    return ProviderOverride(
      origin: this,
      override: TheaterScreensProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TheaterScreens, List<TheaterScreen>>
      createElement() {
    return _TheaterScreensProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TheaterScreensProvider && other.theaterId == theaterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, theaterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TheaterScreensRef
    on AutoDisposeAsyncNotifierProviderRef<List<TheaterScreen>> {
  /// The parameter `theaterId` of this provider.
  String get theaterId;
}

class _TheaterScreensProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TheaterScreens,
        List<TheaterScreen>> with TheaterScreensRef {
  _TheaterScreensProviderElement(super.provider);

  @override
  String get theaterId => (origin as TheaterScreensProvider).theaterId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
