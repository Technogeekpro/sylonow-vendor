// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_add_on.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceAddOn _$ServiceAddOnFromJson(Map<String, dynamic> json) {
  return _ServiceAddOn.fromJson(json);
}

/// @nodoc
mixin _$ServiceAddOn {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_listing_id')
  String get serviceListingId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_price')
  double get originalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_price')
  double? get discountPrice => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // add_on, upgrade, accessory
  String get unit =>
      throw _privateConstructorUsedError; // piece, hour, set, kg, meter, liter
  int get stock => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceAddOnCopyWith<ServiceAddOn> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceAddOnCopyWith<$Res> {
  factory $ServiceAddOnCopyWith(
          ServiceAddOn value, $Res Function(ServiceAddOn) then) =
      _$ServiceAddOnCopyWithImpl<$Res, ServiceAddOn>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'service_listing_id') String serviceListingId,
      String name,
      @JsonKey(name: 'original_price') double originalPrice,
      @JsonKey(name: 'discount_price') double? discountPrice,
      String? description,
      List<String> images,
      String type,
      String unit,
      int stock,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$ServiceAddOnCopyWithImpl<$Res, $Val extends ServiceAddOn>
    implements $ServiceAddOnCopyWith<$Res> {
  _$ServiceAddOnCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? serviceListingId = null,
    Object? name = null,
    Object? originalPrice = null,
    Object? discountPrice = freezed,
    Object? description = freezed,
    Object? images = null,
    Object? type = null,
    Object? unit = null,
    Object? stock = null,
    Object? isAvailable = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceListingId: null == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$ServiceAddOnImplCopyWith<$Res>
    implements $ServiceAddOnCopyWith<$Res> {
  factory _$$ServiceAddOnImplCopyWith(
          _$ServiceAddOnImpl value, $Res Function(_$ServiceAddOnImpl) then) =
      __$$ServiceAddOnImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'service_listing_id') String serviceListingId,
      String name,
      @JsonKey(name: 'original_price') double originalPrice,
      @JsonKey(name: 'discount_price') double? discountPrice,
      String? description,
      List<String> images,
      String type,
      String unit,
      int stock,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$ServiceAddOnImplCopyWithImpl<$Res>
    extends _$ServiceAddOnCopyWithImpl<$Res, _$ServiceAddOnImpl>
    implements _$$ServiceAddOnImplCopyWith<$Res> {
  __$$ServiceAddOnImplCopyWithImpl(
      _$ServiceAddOnImpl _value, $Res Function(_$ServiceAddOnImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? serviceListingId = null,
    Object? name = null,
    Object? originalPrice = null,
    Object? discountPrice = freezed,
    Object? description = freezed,
    Object? images = null,
    Object? type = null,
    Object? unit = null,
    Object? stock = null,
    Object? isAvailable = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ServiceAddOnImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceListingId: null == serviceListingId
          ? _value.serviceListingId
          : serviceListingId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$ServiceAddOnImpl implements _ServiceAddOn {
  const _$ServiceAddOnImpl(
      {this.id,
      @JsonKey(name: 'service_listing_id') required this.serviceListingId,
      required this.name,
      @JsonKey(name: 'original_price') required this.originalPrice,
      @JsonKey(name: 'discount_price') this.discountPrice,
      this.description,
      final List<String> images = const [],
      this.type = 'add_on',
      this.unit = 'piece',
      this.stock = 0,
      @JsonKey(name: 'is_available') this.isAvailable = true,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _images = images;

  factory _$ServiceAddOnImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceAddOnImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'service_listing_id')
  final String serviceListingId;
  @override
  final String name;
  @override
  @JsonKey(name: 'original_price')
  final double originalPrice;
  @override
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @override
  final String? description;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final String type;
// add_on, upgrade, accessory
  @override
  @JsonKey()
  final String unit;
// piece, hour, set, kg, meter, liter
  @override
  @JsonKey()
  final int stock;
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ServiceAddOn(id: $id, serviceListingId: $serviceListingId, name: $name, originalPrice: $originalPrice, discountPrice: $discountPrice, description: $description, images: $images, type: $type, unit: $unit, stock: $stock, isAvailable: $isAvailable, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceAddOnImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceListingId, serviceListingId) ||
                other.serviceListingId == serviceListingId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.discountPrice, discountPrice) ||
                other.discountPrice == discountPrice) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      serviceListingId,
      name,
      originalPrice,
      discountPrice,
      description,
      const DeepCollectionEquality().hash(_images),
      type,
      unit,
      stock,
      isAvailable,
      sortOrder,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceAddOnImplCopyWith<_$ServiceAddOnImpl> get copyWith =>
      __$$ServiceAddOnImplCopyWithImpl<_$ServiceAddOnImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceAddOnImplToJson(
      this,
    );
  }
}

abstract class _ServiceAddOn implements ServiceAddOn {
  const factory _ServiceAddOn(
          {final String? id,
          @JsonKey(name: 'service_listing_id')
          required final String serviceListingId,
          required final String name,
          @JsonKey(name: 'original_price') required final double originalPrice,
          @JsonKey(name: 'discount_price') final double? discountPrice,
          final String? description,
          final List<String> images,
          final String type,
          final String unit,
          final int stock,
          @JsonKey(name: 'is_available') final bool isAvailable,
          @JsonKey(name: 'sort_order') final int sortOrder,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$ServiceAddOnImpl;

  factory _ServiceAddOn.fromJson(Map<String, dynamic> json) =
      _$ServiceAddOnImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'service_listing_id')
  String get serviceListingId;
  @override
  String get name;
  @override
  @JsonKey(name: 'original_price')
  double get originalPrice;
  @override
  @JsonKey(name: 'discount_price')
  double? get discountPrice;
  @override
  String? get description;
  @override
  List<String> get images;
  @override
  String get type;
  @override // add_on, upgrade, accessory
  String get unit;
  @override // piece, hour, set, kg, meter, liter
  int get stock;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ServiceAddOnImplCopyWith<_$ServiceAddOnImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
