// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderDetailsHash() => r'7a8a61e579451b6f536d5d55d363fd154582e063';

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

/// See also [orderDetails].
@ProviderFor(orderDetails)
const orderDetailsProvider = OrderDetailsFamily();

/// See also [orderDetails].
class OrderDetailsFamily extends Family<AsyncValue<DashboardOrder>> {
  /// See also [orderDetails].
  const OrderDetailsFamily();

  /// See also [orderDetails].
  OrderDetailsProvider call(
    String orderId,
  ) {
    return OrderDetailsProvider(
      orderId,
    );
  }

  @override
  OrderDetailsProvider getProviderOverride(
    covariant OrderDetailsProvider provider,
  ) {
    return call(
      provider.orderId,
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
  String? get name => r'orderDetailsProvider';
}

/// See also [orderDetails].
class OrderDetailsProvider extends AutoDisposeFutureProvider<DashboardOrder> {
  /// See also [orderDetails].
  OrderDetailsProvider(
    String orderId,
  ) : this._internal(
          (ref) => orderDetails(
            ref as OrderDetailsRef,
            orderId,
          ),
          from: orderDetailsProvider,
          name: r'orderDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderDetailsHash,
          dependencies: OrderDetailsFamily._dependencies,
          allTransitiveDependencies:
              OrderDetailsFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  OrderDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(
    FutureOr<DashboardOrder> Function(OrderDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailsProvider._internal(
        (ref) => create(ref as OrderDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DashboardOrder> createElement() {
    return _OrderDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailsProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OrderDetailsRef on AutoDisposeFutureProviderRef<DashboardOrder> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderDetailsProviderElement
    extends AutoDisposeFutureProviderElement<DashboardOrder>
    with OrderDetailsRef {
  _OrderDetailsProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderDetailsProvider).orderId;
}

String _$dashboardStatsHash() => r'0af78358156989a03b1c4c8cdb9df17d5647a3f7';

/// See also [DashboardStats].
@ProviderFor(DashboardStats)
final dashboardStatsProvider = AutoDisposeAsyncNotifierProvider<DashboardStats,
    ds.DashboardStats?>.internal(
  DashboardStats.new,
  name: r'dashboardStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DashboardStats = AutoDisposeAsyncNotifier<ds.DashboardStats?>;
String _$pendingOrdersHash() => r'263eb8a0cb06cfa869ab8d5e5e0105aee0eda1c8';

/// See also [PendingOrders].
@ProviderFor(PendingOrders)
final pendingOrdersProvider = AutoDisposeAsyncNotifierProvider<PendingOrders,
    List<DashboardOrder>>.internal(
  PendingOrders.new,
  name: r'pendingOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PendingOrders = AutoDisposeAsyncNotifier<List<DashboardOrder>>;
String _$upcomingOrdersHash() => r'1d65afb077480cec1a23a925f90fa06ef4344dd1';

/// See also [UpcomingOrders].
@ProviderFor(UpcomingOrders)
final upcomingOrdersProvider = AutoDisposeAsyncNotifierProvider<UpcomingOrders,
    List<DashboardOrder>>.internal(
  UpcomingOrders.new,
  name: r'upcomingOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpcomingOrders = AutoDisposeAsyncNotifier<List<DashboardOrder>>;
String _$vendorHasTheatersHash() => r'6871f39ff8cf9d282ad3d6986b6f46c39484984c';

/// See also [VendorHasTheaters].
@ProviderFor(VendorHasTheaters)
final vendorHasTheatersProvider =
    AutoDisposeAsyncNotifierProvider<VendorHasTheaters, bool>.internal(
  VendorHasTheaters.new,
  name: r'vendorHasTheatersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vendorHasTheatersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VendorHasTheaters = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
