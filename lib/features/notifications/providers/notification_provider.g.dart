// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationStreamHash() =>
    r'1def6b2bad4e2dad1d66d762c083ecc7abde2025';

/// See also [notificationStream].
@ProviderFor(notificationStream)
final notificationStreamProvider =
    AutoDisposeStreamProvider<List<VendorNotification>>.internal(
  notificationStream,
  name: r'notificationStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationStreamRef
    = AutoDisposeStreamProviderRef<List<VendorNotification>>;
String _$hasUnreadNotificationsHash() =>
    r'6ce17b1b29f3d1410d7b47b19b91c877b1568534';

/// See also [hasUnreadNotifications].
@ProviderFor(hasUnreadNotifications)
final hasUnreadNotificationsProvider = AutoDisposeFutureProvider<bool>.internal(
  hasUnreadNotifications,
  name: r'hasUnreadNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasUnreadNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasUnreadNotificationsRef = AutoDisposeFutureProviderRef<bool>;
String _$notificationListHash() => r'9cf4b55b68ca2c6d74eb208070ace46fd27cbbbb';

/// See also [NotificationList].
@ProviderFor(NotificationList)
final notificationListProvider = AutoDisposeAsyncNotifierProvider<
    NotificationList, List<VendorNotification>>.internal(
  NotificationList.new,
  name: r'notificationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationList = AutoDisposeAsyncNotifier<List<VendorNotification>>;
String _$unreadCountHash() => r'9d0db951982d1e761479c419a9e9f7dd53388ba1';

/// See also [UnreadCount].
@ProviderFor(UnreadCount)
final unreadCountProvider =
    AutoDisposeAsyncNotifierProvider<UnreadCount, int>.internal(
  UnreadCount.new,
  name: r'unreadCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$unreadCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UnreadCount = AutoDisposeAsyncNotifier<int>;
String _$notificationsByTypeHash() =>
    r'927b35e11f58be7a171181d9db23687e84d9a739';

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

abstract class _$NotificationsByType
    extends BuildlessAutoDisposeAsyncNotifier<List<VendorNotification>> {
  late final String type;

  FutureOr<List<VendorNotification>> build(
    String type,
  );
}

/// See also [NotificationsByType].
@ProviderFor(NotificationsByType)
const notificationsByTypeProvider = NotificationsByTypeFamily();

/// See also [NotificationsByType].
class NotificationsByTypeFamily
    extends Family<AsyncValue<List<VendorNotification>>> {
  /// See also [NotificationsByType].
  const NotificationsByTypeFamily();

  /// See also [NotificationsByType].
  NotificationsByTypeProvider call(
    String type,
  ) {
    return NotificationsByTypeProvider(
      type,
    );
  }

  @override
  NotificationsByTypeProvider getProviderOverride(
    covariant NotificationsByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'notificationsByTypeProvider';
}

/// See also [NotificationsByType].
class NotificationsByTypeProvider extends AutoDisposeAsyncNotifierProviderImpl<
    NotificationsByType, List<VendorNotification>> {
  /// See also [NotificationsByType].
  NotificationsByTypeProvider(
    String type,
  ) : this._internal(
          () => NotificationsByType()..type = type,
          from: notificationsByTypeProvider,
          name: r'notificationsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notificationsByTypeHash,
          dependencies: NotificationsByTypeFamily._dependencies,
          allTransitiveDependencies:
              NotificationsByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  NotificationsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  FutureOr<List<VendorNotification>> runNotifierBuild(
    covariant NotificationsByType notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(NotificationsByType Function() create) {
    return ProviderOverride(
      origin: this,
      override: NotificationsByTypeProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NotificationsByType,
      List<VendorNotification>> createElement() {
    return _NotificationsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationsByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NotificationsByTypeRef
    on AutoDisposeAsyncNotifierProviderRef<List<VendorNotification>> {
  /// The parameter `type` of this provider.
  String get type;
}

class _NotificationsByTypeProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<NotificationsByType,
        List<VendorNotification>> with NotificationsByTypeRef {
  _NotificationsByTypeProviderElement(super.provider);

  @override
  String get type => (origin as NotificationsByTypeProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
