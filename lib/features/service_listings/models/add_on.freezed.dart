// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_on.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddOn _$AddOnFromJson(Map<String, dynamic> json) {
  return _AddOn.fromJson(json);
}

/// @nodoc
mixin _$AddOn {
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_free')
  bool get isFree => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddOnCopyWith<AddOn> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddOnCopyWith<$Res> {
  factory $AddOnCopyWith(AddOn value, $Res Function(AddOn) then) =
      _$AddOnCopyWithImpl<$Res, AddOn>;
  @useResult
  $Res call(
      {String name,
      double price,
      @JsonKey(name: 'is_free') bool isFree,
      String? description});
}

/// @nodoc
class _$AddOnCopyWithImpl<$Res, $Val extends AddOn>
    implements $AddOnCopyWith<$Res> {
  _$AddOnCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? price = null,
    Object? isFree = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddOnImplCopyWith<$Res> implements $AddOnCopyWith<$Res> {
  factory _$$AddOnImplCopyWith(
          _$AddOnImpl value, $Res Function(_$AddOnImpl) then) =
      __$$AddOnImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      double price,
      @JsonKey(name: 'is_free') bool isFree,
      String? description});
}

/// @nodoc
class __$$AddOnImplCopyWithImpl<$Res>
    extends _$AddOnCopyWithImpl<$Res, _$AddOnImpl>
    implements _$$AddOnImplCopyWith<$Res> {
  __$$AddOnImplCopyWithImpl(
      _$AddOnImpl _value, $Res Function(_$AddOnImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? price = null,
    Object? isFree = null,
    Object? description = freezed,
  }) {
    return _then(_$AddOnImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddOnImpl implements _AddOn {
  const _$AddOnImpl(
      {required this.name,
      required this.price,
      @JsonKey(name: 'is_free') this.isFree = false,
      this.description});

  factory _$AddOnImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddOnImplFromJson(json);

  @override
  final String name;
  @override
  final double price;
  @override
  @JsonKey(name: 'is_free')
  final bool isFree;
  @override
  final String? description;

  @override
  String toString() {
    return 'AddOn(name: $name, price: $price, isFree: $isFree, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddOnImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, price, isFree, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddOnImplCopyWith<_$AddOnImpl> get copyWith =>
      __$$AddOnImplCopyWithImpl<_$AddOnImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddOnImplToJson(
      this,
    );
  }
}

abstract class _AddOn implements AddOn {
  const factory _AddOn(
      {required final String name,
      required final double price,
      @JsonKey(name: 'is_free') final bool isFree,
      final String? description}) = _$AddOnImpl;

  factory _AddOn.fromJson(Map<String, dynamic> json) = _$AddOnImpl.fromJson;

  @override
  String get name;
  @override
  double get price;
  @override
  @JsonKey(name: 'is_free')
  bool get isFree;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$AddOnImplCopyWith<_$AddOnImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
