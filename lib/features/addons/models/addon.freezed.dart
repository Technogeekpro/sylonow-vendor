// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'addon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Addon _$AddonFromJson(Map<String, dynamic> json) {
  return _Addon.fromJson(json);
}

/// @nodoc
mixin _$Addon {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'theater_id')
  String? get theaterId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddonCopyWith<Addon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddonCopyWith<$Res> {
  factory $AddonCopyWith(Addon value, $Res Function(Addon) then) =
      _$AddonCopyWithImpl<$Res, Addon>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'theater_id') String? theaterId,
      String name,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      double price,
      String category,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$AddonCopyWithImpl<$Res, $Val extends Addon>
    implements $AddonCopyWith<$Res> {
  _$AddonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? theaterId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? price = null,
    Object? category = null,
    Object? isActive = null,
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
      theaterId: freezed == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AddonImplCopyWith<$Res> implements $AddonCopyWith<$Res> {
  factory _$$AddonImplCopyWith(
          _$AddonImpl value, $Res Function(_$AddonImpl) then) =
      __$$AddonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'theater_id') String? theaterId,
      String name,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      double price,
      String category,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$AddonImplCopyWithImpl<$Res>
    extends _$AddonCopyWithImpl<$Res, _$AddonImpl>
    implements _$$AddonImplCopyWith<$Res> {
  __$$AddonImplCopyWithImpl(
      _$AddonImpl _value, $Res Function(_$AddonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? theaterId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? price = null,
    Object? category = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AddonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      theaterId: freezed == theaterId
          ? _value.theaterId
          : theaterId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
class _$AddonImpl implements _Addon {
  const _$AddonImpl(
      {required this.id,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'theater_id') this.theaterId,
      required this.name,
      this.description,
      @JsonKey(name: 'image_url') this.imageUrl,
      this.price = 0.0,
      this.category = 'cake',
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$AddonImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddonImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'theater_id')
  final String? theaterId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Addon(id: $id, vendorId: $vendorId, theaterId: $theaterId, name: $name, description: $description, imageUrl: $imageUrl, price: $price, category: $category, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.theaterId, theaterId) ||
                other.theaterId == theaterId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, vendorId, theaterId, name,
      description, imageUrl, price, category, isActive, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddonImplCopyWith<_$AddonImpl> get copyWith =>
      __$$AddonImplCopyWithImpl<_$AddonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddonImplToJson(
      this,
    );
  }
}

abstract class _Addon implements Addon {
  const factory _Addon(
      {required final String id,
      @JsonKey(name: 'vendor_id') required final String vendorId,
      @JsonKey(name: 'theater_id') final String? theaterId,
      required final String name,
      final String? description,
      @JsonKey(name: 'image_url') final String? imageUrl,
      final double price,
      final String category,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt}) = _$AddonImpl;

  factory _Addon.fromJson(Map<String, dynamic> json) = _$AddonImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'theater_id')
  String? get theaterId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  double get price;
  @override
  String get category;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AddonImplCopyWith<_$AddonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
