// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeServiceHash() => r'5a9a08d0f231f867e337c67d26698ea379751abf';

/// See also [themeService].
@ProviderFor(themeService)
final themeServiceProvider = AutoDisposeProvider<ThemeService>.internal(
  themeService,
  name: r'themeServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$themeServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ThemeServiceRef = AutoDisposeProviderRef<ThemeService>;
String _$appThemeDataHash() => r'd12d8e5f19ec6d44c0d433057e0c734f6065f545';

/// See also [appThemeData].
@ProviderFor(appThemeData)
final appThemeDataProvider = AutoDisposeProvider<ThemeData>.internal(
  appThemeData,
  name: r'appThemeDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appThemeDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppThemeDataRef = AutoDisposeProviderRef<ThemeData>;
String _$themeByIdHash() => r'1a0300ef7a59ce63439b003a2874c4b7b7fd55c4';

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

/// See also [themeById].
@ProviderFor(themeById)
const themeByIdProvider = ThemeByIdFamily();

/// See also [themeById].
class ThemeByIdFamily extends Family<AsyncValue<ThemeConfig?>> {
  /// See also [themeById].
  const ThemeByIdFamily();

  /// See also [themeById].
  ThemeByIdProvider call(
    String id,
  ) {
    return ThemeByIdProvider(
      id,
    );
  }

  @override
  ThemeByIdProvider getProviderOverride(
    covariant ThemeByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'themeByIdProvider';
}

/// See also [themeById].
class ThemeByIdProvider extends AutoDisposeFutureProvider<ThemeConfig?> {
  /// See also [themeById].
  ThemeByIdProvider(
    String id,
  ) : this._internal(
          (ref) => themeById(
            ref as ThemeByIdRef,
            id,
          ),
          from: themeByIdProvider,
          name: r'themeByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$themeByIdHash,
          dependencies: ThemeByIdFamily._dependencies,
          allTransitiveDependencies: ThemeByIdFamily._allTransitiveDependencies,
          id: id,
        );

  ThemeByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ThemeConfig?> Function(ThemeByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ThemeByIdProvider._internal(
        (ref) => create(ref as ThemeByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ThemeConfig?> createElement() {
    return _ThemeByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThemeByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ThemeByIdRef on AutoDisposeFutureProviderRef<ThemeConfig?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ThemeByIdProviderElement
    extends AutoDisposeFutureProviderElement<ThemeConfig?> with ThemeByIdRef {
  _ThemeByIdProviderElement(super.provider);

  @override
  String get id => (origin as ThemeByIdProvider).id;
}

String _$activeThemeHash() => r'6d2b6b07033d6ae512a27409a2ce233510dc4f5a';

/// See also [ActiveTheme].
@ProviderFor(ActiveTheme)
final activeThemeProvider =
    AutoDisposeAsyncNotifierProvider<ActiveTheme, ThemeConfig?>.internal(
  ActiveTheme.new,
  name: r'activeThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveTheme = AutoDisposeAsyncNotifier<ThemeConfig?>;
String _$themeManagerHash() => r'9c05f8ee2c9fc8b7f7622697463d40bb5bbb4c92';

/// See also [ThemeManager].
@ProviderFor(ThemeManager)
final themeManagerProvider =
    AutoDisposeAsyncNotifierProvider<ThemeManager, List<ThemeConfig>>.internal(
  ThemeManager.new,
  name: r'themeManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$themeManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeManager = AutoDisposeAsyncNotifier<List<ThemeConfig>>;
String _$themeWatcherHash() => r'7a355b68b052306e324b8d258ccdcbe88dbf4443';

/// See also [ThemeWatcher].
@ProviderFor(ThemeWatcher)
final themeWatcherProvider =
    AutoDisposeStreamNotifierProvider<ThemeWatcher, ThemeConfig?>.internal(
  ThemeWatcher.new,
  name: r'themeWatcherProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$themeWatcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeWatcher = AutoDisposeStreamNotifier<ThemeConfig?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
