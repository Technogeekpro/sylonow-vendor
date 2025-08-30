// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) {
  return _DashboardData.fromJson(json);
}

/// @nodoc
mixin _$DashboardData {
  DashboardStats get stats => throw _privateConstructorUsedError;
  @JsonKey(name: 'latest_pending_booking')
  Booking? get latestPendingBooking => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<ActivityItem> get recentActivities => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
          DashboardData value, $Res Function(DashboardData) then) =
      _$DashboardDataCopyWithImpl<$Res, DashboardData>;
  @useResult
  $Res call(
      {DashboardStats stats,
      @JsonKey(name: 'latest_pending_booking') Booking? latestPendingBooking,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<ActivityItem> recentActivities});

  $DashboardStatsCopyWith<$Res> get stats;
  $BookingCopyWith<$Res>? get latestPendingBooking;
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res, $Val extends DashboardData>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? latestPendingBooking = freezed,
    Object? recentActivities = null,
  }) {
    return _then(_value.copyWith(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as DashboardStats,
      latestPendingBooking: freezed == latestPendingBooking
          ? _value.latestPendingBooking
          : latestPendingBooking // ignore: cast_nullable_to_non_nullable
              as Booking?,
      recentActivities: null == recentActivities
          ? _value.recentActivities
          : recentActivities // ignore: cast_nullable_to_non_nullable
              as List<ActivityItem>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DashboardStatsCopyWith<$Res> get stats {
    return $DashboardStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BookingCopyWith<$Res>? get latestPendingBooking {
    if (_value.latestPendingBooking == null) {
      return null;
    }

    return $BookingCopyWith<$Res>(_value.latestPendingBooking!, (value) {
      return _then(_value.copyWith(latestPendingBooking: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardDataImplCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$$DashboardDataImplCopyWith(
          _$DashboardDataImpl value, $Res Function(_$DashboardDataImpl) then) =
      __$$DashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DashboardStats stats,
      @JsonKey(name: 'latest_pending_booking') Booking? latestPendingBooking,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<ActivityItem> recentActivities});

  @override
  $DashboardStatsCopyWith<$Res> get stats;
  @override
  $BookingCopyWith<$Res>? get latestPendingBooking;
}

/// @nodoc
class __$$DashboardDataImplCopyWithImpl<$Res>
    extends _$DashboardDataCopyWithImpl<$Res, _$DashboardDataImpl>
    implements _$$DashboardDataImplCopyWith<$Res> {
  __$$DashboardDataImplCopyWithImpl(
      _$DashboardDataImpl _value, $Res Function(_$DashboardDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? latestPendingBooking = freezed,
    Object? recentActivities = null,
  }) {
    return _then(_$DashboardDataImpl(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as DashboardStats,
      latestPendingBooking: freezed == latestPendingBooking
          ? _value.latestPendingBooking
          : latestPendingBooking // ignore: cast_nullable_to_non_nullable
              as Booking?,
      recentActivities: null == recentActivities
          ? _value._recentActivities
          : recentActivities // ignore: cast_nullable_to_non_nullable
              as List<ActivityItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardDataImpl implements _DashboardData {
  const _$DashboardDataImpl(
      {required this.stats,
      @JsonKey(name: 'latest_pending_booking') this.latestPendingBooking,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<ActivityItem> recentActivities = const []})
      : _recentActivities = recentActivities;

  factory _$DashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardDataImplFromJson(json);

  @override
  final DashboardStats stats;
  @override
  @JsonKey(name: 'latest_pending_booking')
  final Booking? latestPendingBooking;
  final List<ActivityItem> _recentActivities;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<ActivityItem> get recentActivities {
    if (_recentActivities is EqualUnmodifiableListView)
      return _recentActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivities);
  }

  @override
  String toString() {
    return 'DashboardData(stats: $stats, latestPendingBooking: $latestPendingBooking, recentActivities: $recentActivities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardDataImpl &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.latestPendingBooking, latestPendingBooking) ||
                other.latestPendingBooking == latestPendingBooking) &&
            const DeepCollectionEquality()
                .equals(other._recentActivities, _recentActivities));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, stats, latestPendingBooking,
      const DeepCollectionEquality().hash(_recentActivities));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      __$$DashboardDataImplCopyWithImpl<_$DashboardDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardDataImplToJson(
      this,
    );
  }
}

abstract class _DashboardData implements DashboardData {
  const factory _DashboardData(
      {required final DashboardStats stats,
      @JsonKey(name: 'latest_pending_booking')
      final Booking? latestPendingBooking,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<ActivityItem> recentActivities}) = _$DashboardDataImpl;

  factory _DashboardData.fromJson(Map<String, dynamic> json) =
      _$DashboardDataImpl.fromJson;

  @override
  DashboardStats get stats;
  @override
  @JsonKey(name: 'latest_pending_booking')
  Booking? get latestPendingBooking;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<ActivityItem> get recentActivities;
  @override
  @JsonKey(ignore: true)
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
