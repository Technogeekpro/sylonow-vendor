// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_theaters')
  int get totalTheaters => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_theaters')
  int get activeTheaters => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_orders')
  int get pendingOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_orders')
  int get completedOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'gross_sales')
  double get grossSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_earnings')
  double get totalEarnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_earnings')
  double get monthlyEarnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'orders_this_week')
  int get ordersThisWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'orders_today')
  int get ordersToday => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
          DashboardStats value, $Res Function(DashboardStats) then) =
      _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'total_theaters') int totalTheaters,
      @JsonKey(name: 'active_theaters') int activeTheaters,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'pending_orders') int pendingOrders,
      @JsonKey(name: 'completed_orders') int completedOrders,
      @JsonKey(name: 'gross_sales') double grossSales,
      @JsonKey(name: 'total_earnings') double totalEarnings,
      @JsonKey(name: 'monthly_earnings') double monthlyEarnings,
      @JsonKey(name: 'orders_this_week') int ordersThisWeek,
      @JsonKey(name: 'orders_today') int ordersToday});
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = null,
    Object? fullName = freezed,
    Object? totalTheaters = null,
    Object? activeTheaters = null,
    Object? totalOrders = null,
    Object? pendingOrders = null,
    Object? completedOrders = null,
    Object? grossSales = null,
    Object? totalEarnings = null,
    Object? monthlyEarnings = null,
    Object? ordersThisWeek = null,
    Object? ordersToday = null,
  }) {
    return _then(_value.copyWith(
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalTheaters: null == totalTheaters
          ? _value.totalTheaters
          : totalTheaters // ignore: cast_nullable_to_non_nullable
              as int,
      activeTheaters: null == activeTheaters
          ? _value.activeTheaters
          : activeTheaters // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalEarnings: null == totalEarnings
          ? _value.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyEarnings: null == monthlyEarnings
          ? _value.monthlyEarnings
          : monthlyEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      ordersThisWeek: null == ordersThisWeek
          ? _value.ordersThisWeek
          : ordersThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      ordersToday: null == ordersToday
          ? _value.ordersToday
          : ordersToday // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(_$DashboardStatsImpl value,
          $Res Function(_$DashboardStatsImpl) then) =
      __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'total_theaters') int totalTheaters,
      @JsonKey(name: 'active_theaters') int activeTheaters,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'pending_orders') int pendingOrders,
      @JsonKey(name: 'completed_orders') int completedOrders,
      @JsonKey(name: 'gross_sales') double grossSales,
      @JsonKey(name: 'total_earnings') double totalEarnings,
      @JsonKey(name: 'monthly_earnings') double monthlyEarnings,
      @JsonKey(name: 'orders_this_week') int ordersThisWeek,
      @JsonKey(name: 'orders_today') int ordersToday});
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
      _$DashboardStatsImpl _value, $Res Function(_$DashboardStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = null,
    Object? fullName = freezed,
    Object? totalTheaters = null,
    Object? activeTheaters = null,
    Object? totalOrders = null,
    Object? pendingOrders = null,
    Object? completedOrders = null,
    Object? grossSales = null,
    Object? totalEarnings = null,
    Object? monthlyEarnings = null,
    Object? ordersThisWeek = null,
    Object? ordersToday = null,
  }) {
    return _then(_$DashboardStatsImpl(
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalTheaters: null == totalTheaters
          ? _value.totalTheaters
          : totalTheaters // ignore: cast_nullable_to_non_nullable
              as int,
      activeTheaters: null == activeTheaters
          ? _value.activeTheaters
          : activeTheaters // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalEarnings: null == totalEarnings
          ? _value.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyEarnings: null == monthlyEarnings
          ? _value.monthlyEarnings
          : monthlyEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      ordersThisWeek: null == ordersThisWeek
          ? _value.ordersThisWeek
          : ordersThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      ordersToday: null == ordersToday
          ? _value.ordersToday
          : ordersToday // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl(
      {@JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'full_name') this.fullName,
      @JsonKey(name: 'total_theaters') this.totalTheaters = 0,
      @JsonKey(name: 'active_theaters') this.activeTheaters = 0,
      @JsonKey(name: 'total_orders') this.totalOrders = 0,
      @JsonKey(name: 'pending_orders') this.pendingOrders = 0,
      @JsonKey(name: 'completed_orders') this.completedOrders = 0,
      @JsonKey(name: 'gross_sales') this.grossSales = 0.0,
      @JsonKey(name: 'total_earnings') this.totalEarnings = 0.0,
      @JsonKey(name: 'monthly_earnings') this.monthlyEarnings = 0.0,
      @JsonKey(name: 'orders_this_week') this.ordersThisWeek = 0,
      @JsonKey(name: 'orders_today') this.ordersToday = 0});

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  @JsonKey(name: 'total_theaters')
  final int totalTheaters;
  @override
  @JsonKey(name: 'active_theaters')
  final int activeTheaters;
  @override
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @override
  @JsonKey(name: 'pending_orders')
  final int pendingOrders;
  @override
  @JsonKey(name: 'completed_orders')
  final int completedOrders;
  @override
  @JsonKey(name: 'gross_sales')
  final double grossSales;
  @override
  @JsonKey(name: 'total_earnings')
  final double totalEarnings;
  @override
  @JsonKey(name: 'monthly_earnings')
  final double monthlyEarnings;
  @override
  @JsonKey(name: 'orders_this_week')
  final int ordersThisWeek;
  @override
  @JsonKey(name: 'orders_today')
  final int ordersToday;

  @override
  String toString() {
    return 'DashboardStats(vendorId: $vendorId, fullName: $fullName, totalTheaters: $totalTheaters, activeTheaters: $activeTheaters, totalOrders: $totalOrders, pendingOrders: $pendingOrders, completedOrders: $completedOrders, grossSales: $grossSales, totalEarnings: $totalEarnings, monthlyEarnings: $monthlyEarnings, ordersThisWeek: $ordersThisWeek, ordersToday: $ordersToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.totalTheaters, totalTheaters) ||
                other.totalTheaters == totalTheaters) &&
            (identical(other.activeTheaters, activeTheaters) ||
                other.activeTheaters == activeTheaters) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.pendingOrders, pendingOrders) ||
                other.pendingOrders == pendingOrders) &&
            (identical(other.completedOrders, completedOrders) ||
                other.completedOrders == completedOrders) &&
            (identical(other.grossSales, grossSales) ||
                other.grossSales == grossSales) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings) &&
            (identical(other.monthlyEarnings, monthlyEarnings) ||
                other.monthlyEarnings == monthlyEarnings) &&
            (identical(other.ordersThisWeek, ordersThisWeek) ||
                other.ordersThisWeek == ordersThisWeek) &&
            (identical(other.ordersToday, ordersToday) ||
                other.ordersToday == ordersToday));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      vendorId,
      fullName,
      totalTheaters,
      activeTheaters,
      totalOrders,
      pendingOrders,
      completedOrders,
      grossSales,
      totalEarnings,
      monthlyEarnings,
      ordersThisWeek,
      ordersToday);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(
      this,
    );
  }
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats(
          {@JsonKey(name: 'vendor_id') required final String vendorId,
          @JsonKey(name: 'full_name') final String? fullName,
          @JsonKey(name: 'total_theaters') final int totalTheaters,
          @JsonKey(name: 'active_theaters') final int activeTheaters,
          @JsonKey(name: 'total_orders') final int totalOrders,
          @JsonKey(name: 'pending_orders') final int pendingOrders,
          @JsonKey(name: 'completed_orders') final int completedOrders,
          @JsonKey(name: 'gross_sales') final double grossSales,
          @JsonKey(name: 'total_earnings') final double totalEarnings,
          @JsonKey(name: 'monthly_earnings') final double monthlyEarnings,
          @JsonKey(name: 'orders_this_week') final int ordersThisWeek,
          @JsonKey(name: 'orders_today') final int ordersToday}) =
      _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  @JsonKey(name: 'total_theaters')
  int get totalTheaters;
  @override
  @JsonKey(name: 'active_theaters')
  int get activeTheaters;
  @override
  @JsonKey(name: 'total_orders')
  int get totalOrders;
  @override
  @JsonKey(name: 'pending_orders')
  int get pendingOrders;
  @override
  @JsonKey(name: 'completed_orders')
  int get completedOrders;
  @override
  @JsonKey(name: 'gross_sales')
  double get grossSales;
  @override
  @JsonKey(name: 'total_earnings')
  double get totalEarnings;
  @override
  @JsonKey(name: 'monthly_earnings')
  double get monthlyEarnings;
  @override
  @JsonKey(name: 'orders_this_week')
  int get ordersThisWeek;
  @override
  @JsonKey(name: 'orders_today')
  int get ordersToday;
  @override
  @JsonKey(ignore: true)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
