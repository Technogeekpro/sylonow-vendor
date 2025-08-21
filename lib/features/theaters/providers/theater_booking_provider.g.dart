// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vendorBookingsHash() => r'c8df45dc77376b2a385d39c75765bd8c784338b9';

/// See also [VendorBookings].
@ProviderFor(VendorBookings)
final vendorBookingsProvider = AutoDisposeAsyncNotifierProvider<VendorBookings,
    List<TheaterBooking>>.internal(
  VendorBookings.new,
  name: r'vendorBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vendorBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VendorBookings = AutoDisposeAsyncNotifier<List<TheaterBooking>>;
String _$bookingStatsHash() => r'ddb8fff9664d7fb865a357d0c8644810063e7658';

/// See also [BookingStats].
@ProviderFor(BookingStats)
final bookingStatsProvider = AutoDisposeAsyncNotifierProvider<BookingStats,
    Map<String, dynamic>>.internal(
  BookingStats.new,
  name: r'bookingStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookingStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookingStats = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$todayBookingsHash() => r'3c3d6e9e36ce17f811a0289b007b7699abf15675';

/// See also [TodayBookings].
@ProviderFor(TodayBookings)
final todayBookingsProvider = AutoDisposeAsyncNotifierProvider<TodayBookings,
    List<TheaterBooking>>.internal(
  TodayBookings.new,
  name: r'todayBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodayBookings = AutoDisposeAsyncNotifier<List<TheaterBooking>>;
String _$upcomingBookingsHash() => r'e2d5a517c38ef7e1f0f2fb60f17003bfc4571b37';

/// See also [UpcomingBookings].
@ProviderFor(UpcomingBookings)
final upcomingBookingsProvider = AutoDisposeAsyncNotifierProvider<
    UpcomingBookings, List<TheaterBooking>>.internal(
  UpcomingBookings.new,
  name: r'upcomingBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpcomingBookings = AutoDisposeAsyncNotifier<List<TheaterBooking>>;
String _$theaterBookingsHash() => r'2ec5919fdc9ae218be6406d3e89beb99331f7bdc';

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

abstract class _$TheaterBookings
    extends BuildlessAutoDisposeAsyncNotifier<List<TheaterBooking>> {
  late final String theaterId;

  FutureOr<List<TheaterBooking>> build(
    String theaterId,
  );
}

/// See also [TheaterBookings].
@ProviderFor(TheaterBookings)
const theaterBookingsProvider = TheaterBookingsFamily();

/// See also [TheaterBookings].
class TheaterBookingsFamily extends Family<AsyncValue<List<TheaterBooking>>> {
  /// See also [TheaterBookings].
  const TheaterBookingsFamily();

  /// See also [TheaterBookings].
  TheaterBookingsProvider call(
    String theaterId,
  ) {
    return TheaterBookingsProvider(
      theaterId,
    );
  }

  @override
  TheaterBookingsProvider getProviderOverride(
    covariant TheaterBookingsProvider provider,
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
  String? get name => r'theaterBookingsProvider';
}

/// See also [TheaterBookings].
class TheaterBookingsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TheaterBookings, List<TheaterBooking>> {
  /// See also [TheaterBookings].
  TheaterBookingsProvider(
    String theaterId,
  ) : this._internal(
          () => TheaterBookings()..theaterId = theaterId,
          from: theaterBookingsProvider,
          name: r'theaterBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$theaterBookingsHash,
          dependencies: TheaterBookingsFamily._dependencies,
          allTransitiveDependencies:
              TheaterBookingsFamily._allTransitiveDependencies,
          theaterId: theaterId,
        );

  TheaterBookingsProvider._internal(
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
  FutureOr<List<TheaterBooking>> runNotifierBuild(
    covariant TheaterBookings notifier,
  ) {
    return notifier.build(
      theaterId,
    );
  }

  @override
  Override overrideWith(TheaterBookings Function() create) {
    return ProviderOverride(
      origin: this,
      override: TheaterBookingsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TheaterBookings, List<TheaterBooking>>
      createElement() {
    return _TheaterBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TheaterBookingsProvider && other.theaterId == theaterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, theaterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TheaterBookingsRef
    on AutoDisposeAsyncNotifierProviderRef<List<TheaterBooking>> {
  /// The parameter `theaterId` of this provider.
  String get theaterId;
}

class _TheaterBookingsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TheaterBookings,
        List<TheaterBooking>> with TheaterBookingsRef {
  _TheaterBookingsProviderElement(super.provider);

  @override
  String get theaterId => (origin as TheaterBookingsProvider).theaterId;
}

String _$bookingDetailHash() => r'738672d261284a1336b39710312d75d3ceabaf1f';

abstract class _$BookingDetail
    extends BuildlessAutoDisposeAsyncNotifier<TheaterBooking?> {
  late final String bookingId;

  FutureOr<TheaterBooking?> build(
    String bookingId,
  );
}

/// See also [BookingDetail].
@ProviderFor(BookingDetail)
const bookingDetailProvider = BookingDetailFamily();

/// See also [BookingDetail].
class BookingDetailFamily extends Family<AsyncValue<TheaterBooking?>> {
  /// See also [BookingDetail].
  const BookingDetailFamily();

  /// See also [BookingDetail].
  BookingDetailProvider call(
    String bookingId,
  ) {
    return BookingDetailProvider(
      bookingId,
    );
  }

  @override
  BookingDetailProvider getProviderOverride(
    covariant BookingDetailProvider provider,
  ) {
    return call(
      provider.bookingId,
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
  String? get name => r'bookingDetailProvider';
}

/// See also [BookingDetail].
class BookingDetailProvider extends AutoDisposeAsyncNotifierProviderImpl<
    BookingDetail, TheaterBooking?> {
  /// See also [BookingDetail].
  BookingDetailProvider(
    String bookingId,
  ) : this._internal(
          () => BookingDetail()..bookingId = bookingId,
          from: bookingDetailProvider,
          name: r'bookingDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingDetailHash,
          dependencies: BookingDetailFamily._dependencies,
          allTransitiveDependencies:
              BookingDetailFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  BookingDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  FutureOr<TheaterBooking?> runNotifierBuild(
    covariant BookingDetail notifier,
  ) {
    return notifier.build(
      bookingId,
    );
  }

  @override
  Override overrideWith(BookingDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookingDetailProvider._internal(
        () => create()..bookingId = bookingId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BookingDetail, TheaterBooking?>
      createElement() {
    return _BookingDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingDetailProvider && other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookingDetailRef on AutoDisposeAsyncNotifierProviderRef<TheaterBooking?> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _BookingDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BookingDetail,
        TheaterBooking?> with BookingDetailRef {
  _BookingDetailProviderElement(super.provider);

  @override
  String get bookingId => (origin as BookingDetailProvider).bookingId;
}

String _$filteredBookingsHash() => r'a2af19a5f55f1ce79fb066cc8ff45f596e31e062';

abstract class _$FilteredBookings
    extends BuildlessAutoDisposeAsyncNotifier<List<TheaterBooking>> {
  late final String status;

  FutureOr<List<TheaterBooking>> build(
    String status,
  );
}

/// See also [FilteredBookings].
@ProviderFor(FilteredBookings)
const filteredBookingsProvider = FilteredBookingsFamily();

/// See also [FilteredBookings].
class FilteredBookingsFamily extends Family<AsyncValue<List<TheaterBooking>>> {
  /// See also [FilteredBookings].
  const FilteredBookingsFamily();

  /// See also [FilteredBookings].
  FilteredBookingsProvider call(
    String status,
  ) {
    return FilteredBookingsProvider(
      status,
    );
  }

  @override
  FilteredBookingsProvider getProviderOverride(
    covariant FilteredBookingsProvider provider,
  ) {
    return call(
      provider.status,
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
  String? get name => r'filteredBookingsProvider';
}

/// See also [FilteredBookings].
class FilteredBookingsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FilteredBookings, List<TheaterBooking>> {
  /// See also [FilteredBookings].
  FilteredBookingsProvider(
    String status,
  ) : this._internal(
          () => FilteredBookings()..status = status,
          from: filteredBookingsProvider,
          name: r'filteredBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredBookingsHash,
          dependencies: FilteredBookingsFamily._dependencies,
          allTransitiveDependencies:
              FilteredBookingsFamily._allTransitiveDependencies,
          status: status,
        );

  FilteredBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String status;

  @override
  FutureOr<List<TheaterBooking>> runNotifierBuild(
    covariant FilteredBookings notifier,
  ) {
    return notifier.build(
      status,
    );
  }

  @override
  Override overrideWith(FilteredBookings Function() create) {
    return ProviderOverride(
      origin: this,
      override: FilteredBookingsProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FilteredBookings,
      List<TheaterBooking>> createElement() {
    return _FilteredBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredBookingsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FilteredBookingsRef
    on AutoDisposeAsyncNotifierProviderRef<List<TheaterBooking>> {
  /// The parameter `status` of this provider.
  String get status;
}

class _FilteredBookingsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FilteredBookings,
        List<TheaterBooking>> with FilteredBookingsRef {
  _FilteredBookingsProviderElement(super.provider);

  @override
  String get status => (origin as FilteredBookingsProvider).status;
}

String _$searchedBookingsHash() => r'656a9db1ac35d54b4be37414958958ab55cd53e9';

abstract class _$SearchedBookings
    extends BuildlessAutoDisposeAsyncNotifier<List<TheaterBooking>> {
  late final String query;

  FutureOr<List<TheaterBooking>> build(
    String query,
  );
}

/// See also [SearchedBookings].
@ProviderFor(SearchedBookings)
const searchedBookingsProvider = SearchedBookingsFamily();

/// See also [SearchedBookings].
class SearchedBookingsFamily extends Family<AsyncValue<List<TheaterBooking>>> {
  /// See also [SearchedBookings].
  const SearchedBookingsFamily();

  /// See also [SearchedBookings].
  SearchedBookingsProvider call(
    String query,
  ) {
    return SearchedBookingsProvider(
      query,
    );
  }

  @override
  SearchedBookingsProvider getProviderOverride(
    covariant SearchedBookingsProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchedBookingsProvider';
}

/// See also [SearchedBookings].
class SearchedBookingsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SearchedBookings, List<TheaterBooking>> {
  /// See also [SearchedBookings].
  SearchedBookingsProvider(
    String query,
  ) : this._internal(
          () => SearchedBookings()..query = query,
          from: searchedBookingsProvider,
          name: r'searchedBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchedBookingsHash,
          dependencies: SearchedBookingsFamily._dependencies,
          allTransitiveDependencies:
              SearchedBookingsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchedBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  FutureOr<List<TheaterBooking>> runNotifierBuild(
    covariant SearchedBookings notifier,
  ) {
    return notifier.build(
      query,
    );
  }

  @override
  Override overrideWith(SearchedBookings Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchedBookingsProvider._internal(
        () => create()..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SearchedBookings,
      List<TheaterBooking>> createElement() {
    return _SearchedBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchedBookingsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchedBookingsRef
    on AutoDisposeAsyncNotifierProviderRef<List<TheaterBooking>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchedBookingsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SearchedBookings,
        List<TheaterBooking>> with SearchedBookingsRef {
  _SearchedBookingsProviderElement(super.provider);

  @override
  String get query => (origin as SearchedBookingsProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
