// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_private_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VendorPrivateDetails _$VendorPrivateDetailsFromJson(Map<String, dynamic> json) {
  return _VendorPrivateDetails.fromJson(json);
}

/// @nodoc
mixin _$VendorPrivateDetails {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_account_number')
  String? get bankAccountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_ifsc_code')
  String? get bankIfscCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'gst_number')
  String? get gstNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'aadhaar_number')
  String? get aadhaarNumber =>
      throw _privateConstructorUsedError; // Fixed spelling to match DB
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VendorPrivateDetailsCopyWith<VendorPrivateDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorPrivateDetailsCopyWith<$Res> {
  factory $VendorPrivateDetailsCopyWith(VendorPrivateDetails value,
          $Res Function(VendorPrivateDetails) then) =
      _$VendorPrivateDetailsCopyWithImpl<$Res, VendorPrivateDetails>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'bank_account_number') String? bankAccountNumber,
      @JsonKey(name: 'bank_ifsc_code') String? bankIfscCode,
      @JsonKey(name: 'gst_number') String? gstNumber,
      @JsonKey(name: 'aadhaar_number') String? aadhaarNumber,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$VendorPrivateDetailsCopyWithImpl<$Res,
        $Val extends VendorPrivateDetails>
    implements $VendorPrivateDetailsCopyWith<$Res> {
  _$VendorPrivateDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? vendorId = freezed,
    Object? bankAccountNumber = freezed,
    Object? bankIfscCode = freezed,
    Object? gstNumber = freezed,
    Object? aadhaarNumber = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccountNumber: freezed == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bankIfscCode: freezed == bankIfscCode
          ? _value.bankIfscCode
          : bankIfscCode // ignore: cast_nullable_to_non_nullable
              as String?,
      gstNumber: freezed == gstNumber
          ? _value.gstNumber
          : gstNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      aadhaarNumber: freezed == aadhaarNumber
          ? _value.aadhaarNumber
          : aadhaarNumber // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$VendorPrivateDetailsImplCopyWith<$Res>
    implements $VendorPrivateDetailsCopyWith<$Res> {
  factory _$$VendorPrivateDetailsImplCopyWith(_$VendorPrivateDetailsImpl value,
          $Res Function(_$VendorPrivateDetailsImpl) then) =
      __$$VendorPrivateDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'vendor_id') String? vendorId,
      @JsonKey(name: 'bank_account_number') String? bankAccountNumber,
      @JsonKey(name: 'bank_ifsc_code') String? bankIfscCode,
      @JsonKey(name: 'gst_number') String? gstNumber,
      @JsonKey(name: 'aadhaar_number') String? aadhaarNumber,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$VendorPrivateDetailsImplCopyWithImpl<$Res>
    extends _$VendorPrivateDetailsCopyWithImpl<$Res, _$VendorPrivateDetailsImpl>
    implements _$$VendorPrivateDetailsImplCopyWith<$Res> {
  __$$VendorPrivateDetailsImplCopyWithImpl(_$VendorPrivateDetailsImpl _value,
      $Res Function(_$VendorPrivateDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? vendorId = freezed,
    Object? bankAccountNumber = freezed,
    Object? bankIfscCode = freezed,
    Object? gstNumber = freezed,
    Object? aadhaarNumber = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VendorPrivateDetailsImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccountNumber: freezed == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bankIfscCode: freezed == bankIfscCode
          ? _value.bankIfscCode
          : bankIfscCode // ignore: cast_nullable_to_non_nullable
              as String?,
      gstNumber: freezed == gstNumber
          ? _value.gstNumber
          : gstNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      aadhaarNumber: freezed == aadhaarNumber
          ? _value.aadhaarNumber
          : aadhaarNumber // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$VendorPrivateDetailsImpl extends _VendorPrivateDetails {
  const _$VendorPrivateDetailsImpl(
      {this.id,
      @JsonKey(name: 'vendor_id') this.vendorId,
      @JsonKey(name: 'bank_account_number') this.bankAccountNumber,
      @JsonKey(name: 'bank_ifsc_code') this.bankIfscCode,
      @JsonKey(name: 'gst_number') this.gstNumber,
      @JsonKey(name: 'aadhaar_number') this.aadhaarNumber,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  factory _$VendorPrivateDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorPrivateDetailsImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'vendor_id')
  final String? vendorId;
  @override
  @JsonKey(name: 'bank_account_number')
  final String? bankAccountNumber;
  @override
  @JsonKey(name: 'bank_ifsc_code')
  final String? bankIfscCode;
  @override
  @JsonKey(name: 'gst_number')
  final String? gstNumber;
  @override
  @JsonKey(name: 'aadhaar_number')
  final String? aadhaarNumber;
// Fixed spelling to match DB
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VendorPrivateDetails(id: $id, vendorId: $vendorId, bankAccountNumber: $bankAccountNumber, bankIfscCode: $bankIfscCode, gstNumber: $gstNumber, aadhaarNumber: $aadhaarNumber, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorPrivateDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.bankAccountNumber, bankAccountNumber) ||
                other.bankAccountNumber == bankAccountNumber) &&
            (identical(other.bankIfscCode, bankIfscCode) ||
                other.bankIfscCode == bankIfscCode) &&
            (identical(other.gstNumber, gstNumber) ||
                other.gstNumber == gstNumber) &&
            (identical(other.aadhaarNumber, aadhaarNumber) ||
                other.aadhaarNumber == aadhaarNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, vendorId, bankAccountNumber,
      bankIfscCode, gstNumber, aadhaarNumber, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorPrivateDetailsImplCopyWith<_$VendorPrivateDetailsImpl>
      get copyWith =>
          __$$VendorPrivateDetailsImplCopyWithImpl<_$VendorPrivateDetailsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorPrivateDetailsImplToJson(
      this,
    );
  }
}

abstract class _VendorPrivateDetails extends VendorPrivateDetails {
  const factory _VendorPrivateDetails(
          {final String? id,
          @JsonKey(name: 'vendor_id') final String? vendorId,
          @JsonKey(name: 'bank_account_number') final String? bankAccountNumber,
          @JsonKey(name: 'bank_ifsc_code') final String? bankIfscCode,
          @JsonKey(name: 'gst_number') final String? gstNumber,
          @JsonKey(name: 'aadhaar_number') final String? aadhaarNumber,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$VendorPrivateDetailsImpl;
  const _VendorPrivateDetails._() : super._();

  factory _VendorPrivateDetails.fromJson(Map<String, dynamic> json) =
      _$VendorPrivateDetailsImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'vendor_id')
  String? get vendorId;
  @override
  @JsonKey(name: 'bank_account_number')
  String? get bankAccountNumber;
  @override
  @JsonKey(name: 'bank_ifsc_code')
  String? get bankIfscCode;
  @override
  @JsonKey(name: 'gst_number')
  String? get gstNumber;
  @override
  @JsonKey(name: 'aadhaar_number')
  String? get aadhaarNumber;
  @override // Fixed spelling to match DB
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$VendorPrivateDetailsImplCopyWith<_$VendorPrivateDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
