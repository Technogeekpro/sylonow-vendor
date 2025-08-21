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
  @JsonKey(name: 'service_listings_count')
  int get serviceListingsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders_count')
  int get totalOrdersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'gross_sales')
  double get grossSales => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'service_listings_count') int serviceListingsCount,
      @JsonKey(name: 'total_orders_count') int totalOrdersCount,
      @JsonKey(name: 'gross_sales') double grossSales});
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
    Object? serviceListingsCount = null,
    Object? totalOrdersCount = null,
    Object? grossSales = null,
  }) {
    return _then(_value.copyWith(
      serviceListingsCount: null == serviceListingsCount
          ? _value.serviceListingsCount
          : serviceListingsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrdersCount: null == totalOrdersCount
          ? _value.totalOrdersCount
          : totalOrdersCount // ignore: cast_nullable_to_non_nullable
              as int,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
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
      {@JsonKey(name: 'service_listings_count') int serviceListingsCount,
      @JsonKey(name: 'total_orders_count') int totalOrdersCount,
      @JsonKey(name: 'gross_sales') double grossSales});
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
    Object? serviceListingsCount = null,
    Object? totalOrdersCount = null,
    Object? grossSales = null,
  }) {
    return _then(_$DashboardStatsImpl(
      serviceListingsCount: null == serviceListingsCount
          ? _value.serviceListingsCount
          : serviceListingsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrdersCount: null == totalOrdersCount
          ? _value.totalOrdersCount
          : totalOrdersCount // ignore: cast_nullable_to_non_nullable
              as int,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl(
      {@JsonKey(name: 'service_listings_count')
      required this.serviceListingsCount,
      @JsonKey(name: 'total_orders_count') required this.totalOrdersCount,
      @JsonKey(name: 'gross_sales') required this.grossSales});

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  @JsonKey(name: 'service_listings_count')
  final int serviceListingsCount;
  @override
  @JsonKey(name: 'total_orders_count')
  final int totalOrdersCount;
  @override
  @JsonKey(name: 'gross_sales')
  final double grossSales;

  @override
  String toString() {
    return 'DashboardStats(serviceListingsCount: $serviceListingsCount, totalOrdersCount: $totalOrdersCount, grossSales: $grossSales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.serviceListingsCount, serviceListingsCount) ||
                other.serviceListingsCount == serviceListingsCount) &&
            (identical(other.totalOrdersCount, totalOrdersCount) ||
                other.totalOrdersCount == totalOrdersCount) &&
            (identical(other.grossSales, grossSales) ||
                other.grossSales == grossSales));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, serviceListingsCount, totalOrdersCount, grossSales);

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
      {@JsonKey(name: 'service_listings_count')
      required final int serviceListingsCount,
      @JsonKey(name: 'total_orders_count') required final int totalOrdersCount,
      @JsonKey(name: 'gross_sales')
      required final double grossSales}) = _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  @JsonKey(name: 'service_listings_count')
  int get serviceListingsCount;
  @override
  @JsonKey(name: 'total_orders_count')
  int get totalOrdersCount;
  @override
  @JsonKey(name: 'gross_sales')
  double get grossSales;
  @override
  @JsonKey(ignore: true)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
