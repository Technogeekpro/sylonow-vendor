// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VendorStatusModel _$VendorStatusModelFromJson(Map<String, dynamic> json) {
  return _VendorStatusModel.fromJson(json);
}

/// @nodoc
mixin _$VendorStatusModel {
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_onboarding_complete')
  bool get isOnboardingComplete => throw _privateConstructorUsedError;
  @JsonKey(name: 'verification_status')
  String get verificationStatus =>
      throw _privateConstructorUsedError; // pending, approved, rejected
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VendorStatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorStatusModelCopyWith<VendorStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorStatusModelCopyWith<$Res> {
  factory $VendorStatusModelCopyWith(
          VendorStatusModel value, $Res Function(VendorStatusModel) then) =
      _$VendorStatusModelCopyWithImpl<$Res, VendorStatusModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'is_onboarding_complete') bool isOnboardingComplete,
      @JsonKey(name: 'verification_status') String verificationStatus,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'last_login') DateTime? lastLogin,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$VendorStatusModelCopyWithImpl<$Res, $Val extends VendorStatusModel>
    implements $VendorStatusModelCopyWith<$Res> {
  _$VendorStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = null,
    Object? isVerified = null,
    Object? isOnboardingComplete = null,
    Object? verificationStatus = null,
    Object? rejectionReason = freezed,
    Object? lastLogin = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnboardingComplete: null == isOnboardingComplete
          ? _value.isOnboardingComplete
          : isOnboardingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$VendorStatusModelImplCopyWith<$Res>
    implements $VendorStatusModelCopyWith<$Res> {
  factory _$$VendorStatusModelImplCopyWith(_$VendorStatusModelImpl value,
          $Res Function(_$VendorStatusModelImpl) then) =
      __$$VendorStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'is_onboarding_complete') bool isOnboardingComplete,
      @JsonKey(name: 'verification_status') String verificationStatus,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'last_login') DateTime? lastLogin,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$VendorStatusModelImplCopyWithImpl<$Res>
    extends _$VendorStatusModelCopyWithImpl<$Res, _$VendorStatusModelImpl>
    implements _$$VendorStatusModelImplCopyWith<$Res> {
  __$$VendorStatusModelImplCopyWithImpl(_$VendorStatusModelImpl _value,
      $Res Function(_$VendorStatusModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VendorStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = null,
    Object? isVerified = null,
    Object? isOnboardingComplete = null,
    Object? verificationStatus = null,
    Object? rejectionReason = freezed,
    Object? lastLogin = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VendorStatusModelImpl(
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnboardingComplete: null == isOnboardingComplete
          ? _value.isOnboardingComplete
          : isOnboardingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$VendorStatusModelImpl implements _VendorStatusModel {
  const _$VendorStatusModelImpl(
      {@JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'is_onboarding_complete')
      this.isOnboardingComplete = false,
      @JsonKey(name: 'verification_status') this.verificationStatus = 'pending',
      @JsonKey(name: 'rejection_reason') this.rejectionReason,
      @JsonKey(name: 'last_login') this.lastLogin,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$VendorStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorStatusModelImplFromJson(json);

  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  @JsonKey(name: 'is_onboarding_complete')
  final bool isOnboardingComplete;
  @override
  @JsonKey(name: 'verification_status')
  final String verificationStatus;
// pending, approved, rejected
  @override
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @override
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VendorStatusModel(vendorId: $vendorId, isVerified: $isVerified, isOnboardingComplete: $isOnboardingComplete, verificationStatus: $verificationStatus, rejectionReason: $rejectionReason, lastLogin: $lastLogin, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorStatusModelImpl &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isOnboardingComplete, isOnboardingComplete) ||
                other.isOnboardingComplete == isOnboardingComplete) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      vendorId,
      isVerified,
      isOnboardingComplete,
      verificationStatus,
      rejectionReason,
      lastLogin,
      createdAt,
      updatedAt);

  /// Create a copy of VendorStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorStatusModelImplCopyWith<_$VendorStatusModelImpl> get copyWith =>
      __$$VendorStatusModelImplCopyWithImpl<_$VendorStatusModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorStatusModelImplToJson(
      this,
    );
  }
}

abstract class _VendorStatusModel implements VendorStatusModel {
  const factory _VendorStatusModel(
      {@JsonKey(name: 'vendor_id') required final String vendorId,
      @JsonKey(name: 'is_verified') final bool isVerified,
      @JsonKey(name: 'is_onboarding_complete') final bool isOnboardingComplete,
      @JsonKey(name: 'verification_status') final String verificationStatus,
      @JsonKey(name: 'rejection_reason') final String? rejectionReason,
      @JsonKey(name: 'last_login') final DateTime? lastLogin,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$VendorStatusModelImpl;

  factory _VendorStatusModel.fromJson(Map<String, dynamic> json) =
      _$VendorStatusModelImpl.fromJson;

  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'is_onboarding_complete')
  bool get isOnboardingComplete;
  @override
  @JsonKey(name: 'verification_status')
  String get verificationStatus; // pending, approved, rejected
  @override
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;
  @override
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of VendorStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorStatusModelImplCopyWith<_$VendorStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
