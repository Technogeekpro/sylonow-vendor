// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_time_slot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$screenTimeSlotsHash() => r'fa1dd8451e757e6715d0b5c77ad9fb7d8ca8fec3';

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

/// See also [screenTimeSlots].
@ProviderFor(screenTimeSlots)
const screenTimeSlotsProvider = ScreenTimeSlotsFamily();

/// See also [screenTimeSlots].
class ScreenTimeSlotsFamily extends Family<AsyncValue<List<TheaterTimeSlot>>> {
  /// See also [screenTimeSlots].
  const ScreenTimeSlotsFamily();

  /// See also [screenTimeSlots].
  ScreenTimeSlotsProvider call(
    String screenId,
  ) {
    return ScreenTimeSlotsProvider(
      screenId,
    );
  }

  @override
  ScreenTimeSlotsProvider getProviderOverride(
    covariant ScreenTimeSlotsProvider provider,
  ) {
    return call(
      provider.screenId,
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
  String? get name => r'screenTimeSlotsProvider';
}

/// See also [screenTimeSlots].
class ScreenTimeSlotsProvider
    extends AutoDisposeFutureProvider<List<TheaterTimeSlot>> {
  /// See also [screenTimeSlots].
  ScreenTimeSlotsProvider(
    String screenId,
  ) : this._internal(
          (ref) => screenTimeSlots(
            ref as ScreenTimeSlotsRef,
            screenId,
          ),
          from: screenTimeSlotsProvider,
          name: r'screenTimeSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$screenTimeSlotsHash,
          dependencies: ScreenTimeSlotsFamily._dependencies,
          allTransitiveDependencies:
              ScreenTimeSlotsFamily._allTransitiveDependencies,
          screenId: screenId,
        );

  ScreenTimeSlotsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.screenId,
  }) : super.internal();

  final String screenId;

  @override
  Override overrideWith(
    FutureOr<List<TheaterTimeSlot>> Function(ScreenTimeSlotsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScreenTimeSlotsProvider._internal(
        (ref) => create(ref as ScreenTimeSlotsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        screenId: screenId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TheaterTimeSlot>> createElement() {
    return _ScreenTimeSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScreenTimeSlotsProvider && other.screenId == screenId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, screenId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ScreenTimeSlotsRef
    on AutoDisposeFutureProviderRef<List<TheaterTimeSlot>> {
  /// The parameter `screenId` of this provider.
  String get screenId;
}

class _ScreenTimeSlotsProviderElement
    extends AutoDisposeFutureProviderElement<List<TheaterTimeSlot>>
    with ScreenTimeSlotsRef {
  _ScreenTimeSlotsProviderElement(super.provider);

  @override
  String get screenId => (origin as ScreenTimeSlotsProvider).screenId;
}

String _$theaterTimeSlotsHash() => r'3eb63c818c2d71a6ff76f171a39a55ebc79ceca3';

/// See also [theaterTimeSlots].
@ProviderFor(theaterTimeSlots)
const theaterTimeSlotsProvider = TheaterTimeSlotsFamily();

/// See also [theaterTimeSlots].
class TheaterTimeSlotsFamily extends Family<AsyncValue<List<TheaterTimeSlot>>> {
  /// See also [theaterTimeSlots].
  const TheaterTimeSlotsFamily();

  /// See also [theaterTimeSlots].
  TheaterTimeSlotsProvider call(
    String theaterId,
  ) {
    return TheaterTimeSlotsProvider(
      theaterId,
    );
  }

  @override
  TheaterTimeSlotsProvider getProviderOverride(
    covariant TheaterTimeSlotsProvider provider,
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
  String? get name => r'theaterTimeSlotsProvider';
}

/// See also [theaterTimeSlots].
class TheaterTimeSlotsProvider
    extends AutoDisposeFutureProvider<List<TheaterTimeSlot>> {
  /// See also [theaterTimeSlots].
  TheaterTimeSlotsProvider(
    String theaterId,
  ) : this._internal(
          (ref) => theaterTimeSlots(
            ref as TheaterTimeSlotsRef,
            theaterId,
          ),
          from: theaterTimeSlotsProvider,
          name: r'theaterTimeSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$theaterTimeSlotsHash,
          dependencies: TheaterTimeSlotsFamily._dependencies,
          allTransitiveDependencies:
              TheaterTimeSlotsFamily._allTransitiveDependencies,
          theaterId: theaterId,
        );

  TheaterTimeSlotsProvider._internal(
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
  Override overrideWith(
    FutureOr<List<TheaterTimeSlot>> Function(TheaterTimeSlotsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TheaterTimeSlotsProvider._internal(
        (ref) => create(ref as TheaterTimeSlotsRef),
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
  AutoDisposeFutureProviderElement<List<TheaterTimeSlot>> createElement() {
    return _TheaterTimeSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TheaterTimeSlotsProvider && other.theaterId == theaterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, theaterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TheaterTimeSlotsRef
    on AutoDisposeFutureProviderRef<List<TheaterTimeSlot>> {
  /// The parameter `theaterId` of this provider.
  String get theaterId;
}

class _TheaterTimeSlotsProviderElement
    extends AutoDisposeFutureProviderElement<List<TheaterTimeSlot>>
    with TheaterTimeSlotsRef {
  _TheaterTimeSlotsProviderElement(super.provider);

  @override
  String get theaterId => (origin as TheaterTimeSlotsProvider).theaterId;
}

String _$availableTimeSlotsHash() =>
    r'8dbd9a77321c86a9e2ac3141e228ce1d4464b5a7';

/// See also [availableTimeSlots].
@ProviderFor(availableTimeSlots)
const availableTimeSlotsProvider = AvailableTimeSlotsFamily();

/// See also [availableTimeSlots].
class AvailableTimeSlotsFamily
    extends Family<AsyncValue<List<TheaterTimeSlot>>> {
  /// See also [availableTimeSlots].
  const AvailableTimeSlotsFamily();

  /// See also [availableTimeSlots].
  AvailableTimeSlotsProvider call({
    required String screenId,
  }) {
    return AvailableTimeSlotsProvider(
      screenId: screenId,
    );
  }

  @override
  AvailableTimeSlotsProvider getProviderOverride(
    covariant AvailableTimeSlotsProvider provider,
  ) {
    return call(
      screenId: provider.screenId,
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
  String? get name => r'availableTimeSlotsProvider';
}

/// See also [availableTimeSlots].
class AvailableTimeSlotsProvider
    extends AutoDisposeFutureProvider<List<TheaterTimeSlot>> {
  /// See also [availableTimeSlots].
  AvailableTimeSlotsProvider({
    required String screenId,
  }) : this._internal(
          (ref) => availableTimeSlots(
            ref as AvailableTimeSlotsRef,
            screenId: screenId,
          ),
          from: availableTimeSlotsProvider,
          name: r'availableTimeSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableTimeSlotsHash,
          dependencies: AvailableTimeSlotsFamily._dependencies,
          allTransitiveDependencies:
              AvailableTimeSlotsFamily._allTransitiveDependencies,
          screenId: screenId,
        );

  AvailableTimeSlotsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.screenId,
  }) : super.internal();

  final String screenId;

  @override
  Override overrideWith(
    FutureOr<List<TheaterTimeSlot>> Function(AvailableTimeSlotsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableTimeSlotsProvider._internal(
        (ref) => create(ref as AvailableTimeSlotsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        screenId: screenId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TheaterTimeSlot>> createElement() {
    return _AvailableTimeSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableTimeSlotsProvider && other.screenId == screenId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, screenId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AvailableTimeSlotsRef
    on AutoDisposeFutureProviderRef<List<TheaterTimeSlot>> {
  /// The parameter `screenId` of this provider.
  String get screenId;
}

class _AvailableTimeSlotsProviderElement
    extends AutoDisposeFutureProviderElement<List<TheaterTimeSlot>>
    with AvailableTimeSlotsRef {
  _AvailableTimeSlotsProviderElement(super.provider);

  @override
  String get screenId => (origin as AvailableTimeSlotsProvider).screenId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
