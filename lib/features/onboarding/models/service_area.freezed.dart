// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_area.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceArea _$ServiceAreaFromJson(Map<String, dynamic> json) {
  return _ServiceArea.fromJson(json);
}

/// @nodoc
mixin _$ServiceArea {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'area_name')
  String get areaName => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String? get postalCode => throw _privateConstructorUsedError;
  Map<String, dynamic>? get coordinates => throw _privateConstructorUsedError;
  @JsonKey(name: 'radius_km')
  double? get radiusKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ServiceArea to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceAreaCopyWith<ServiceArea> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceAreaCopyWith<$Res> {
  factory $ServiceAreaCopyWith(
          ServiceArea value, $Res Function(ServiceArea) then) =
      _$ServiceAreaCopyWithImpl<$Res, ServiceArea>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'area_name') String areaName,
      String? city,
      String? state,
      @JsonKey(name: 'postal_code') String? postalCode,
      Map<String, dynamic>? coordinates,
      @JsonKey(name: 'radius_km') double? radiusKm,
      @JsonKey(name: 'is_primary') bool isPrimary,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$ServiceAreaCopyWithImpl<$Res, $Val extends ServiceArea>
    implements $ServiceAreaCopyWith<$Res> {
  _$ServiceAreaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? areaName = null,
    Object? city = freezed,
    Object? state = freezed,
    Object? postalCode = freezed,
    Object? coordinates = freezed,
    Object? radiusKm = freezed,
    Object? isPrimary = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      areaName: null == areaName
          ? _value.areaName
          : areaName // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      radiusKm: freezed == radiusKm
          ? _value.radiusKm
          : radiusKm // ignore: cast_nullable_to_non_nullable
              as double?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceAreaImplCopyWith<$Res>
    implements $ServiceAreaCopyWith<$Res> {
  factory _$$ServiceAreaImplCopyWith(
          _$ServiceAreaImpl value, $Res Function(_$ServiceAreaImpl) then) =
      __$$ServiceAreaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'area_name') String areaName,
      String? city,
      String? state,
      @JsonKey(name: 'postal_code') String? postalCode,
      Map<String, dynamic>? coordinates,
      @JsonKey(name: 'radius_km') double? radiusKm,
      @JsonKey(name: 'is_primary') bool isPrimary,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$ServiceAreaImplCopyWithImpl<$Res>
    extends _$ServiceAreaCopyWithImpl<$Res, _$ServiceAreaImpl>
    implements _$$ServiceAreaImplCopyWith<$Res> {
  __$$ServiceAreaImplCopyWithImpl(
      _$ServiceAreaImpl _value, $Res Function(_$ServiceAreaImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceArea
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? areaName = null,
    Object? city = freezed,
    Object? state = freezed,
    Object? postalCode = freezed,
    Object? coordinates = freezed,
    Object? radiusKm = freezed,
    Object? isPrimary = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ServiceAreaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      areaName: null == areaName
          ? _value.areaName
          : areaName // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      radiusKm: freezed == radiusKm
          ? _value.radiusKm
          : radiusKm // ignore: cast_nullable_to_non_nullable
              as double?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceAreaImpl implements _ServiceArea {
  const _$ServiceAreaImpl(
      {required this.id,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'area_name') required this.areaName,
      this.city,
      this.state,
      @JsonKey(name: 'postal_code') this.postalCode,
      final Map<String, dynamic>? coordinates,
      @JsonKey(name: 'radius_km') this.radiusKm,
      @JsonKey(name: 'is_primary') this.isPrimary = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _coordinates = coordinates;

  factory _$ServiceAreaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceAreaImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'area_name')
  final String areaName;
  @override
  final String? city;
  @override
  final String? state;
  @override
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  final Map<String, dynamic>? _coordinates;
  @override
  Map<String, dynamic>? get coordinates {
    final value = _coordinates;
    if (value == null) return null;
    if (_coordinates is EqualUnmodifiableMapView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'radius_km')
  final double? radiusKm;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ServiceArea(id: $id, vendorId: $vendorId, areaName: $areaName, city: $city, state: $state, postalCode: $postalCode, coordinates: $coordinates, radiusKm: $radiusKm, isPrimary: $isPrimary, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceAreaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.areaName, areaName) ||
                other.areaName == areaName) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates) &&
            (identical(other.radiusKm, radiusKm) ||
                other.radiusKm == radiusKm) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vendorId,
      areaName,
      city,
      state,
      postalCode,
      const DeepCollectionEquality().hash(_coordinates),
      radiusKm,
      isPrimary,
      createdAt,
      updatedAt);

  /// Create a copy of ServiceArea
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceAreaImplCopyWith<_$ServiceAreaImpl> get copyWith =>
      __$$ServiceAreaImplCopyWithImpl<_$ServiceAreaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceAreaImplToJson(
      this,
    );
  }
}

abstract class _ServiceArea implements ServiceArea {
  const factory _ServiceArea(
          {required final String id,
          @JsonKey(name: 'vendor_id') required final String vendorId,
          @JsonKey(name: 'area_name') required final String areaName,
          final String? city,
          final String? state,
          @JsonKey(name: 'postal_code') final String? postalCode,
          final Map<String, dynamic>? coordinates,
          @JsonKey(name: 'radius_km') final double? radiusKm,
          @JsonKey(name: 'is_primary') final bool isPrimary,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$ServiceAreaImpl;

  factory _ServiceArea.fromJson(Map<String, dynamic> json) =
      _$ServiceAreaImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'area_name')
  String get areaName;
  @override
  String? get city;
  @override
  String? get state;
  @override
  @JsonKey(name: 'postal_code')
  String? get postalCode;
  @override
  Map<String, dynamic>? get coordinates;
  @override
  @JsonKey(name: 'radius_km')
  double? get radiusKm;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of ServiceArea
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceAreaImplCopyWith<_$ServiceAreaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
