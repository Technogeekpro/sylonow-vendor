// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Wallet _$WalletFromJson(Map<String, dynamic> json) {
  return _Wallet.fromJson(json);
}

/// @nodoc
mixin _$Wallet {
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_balance')
  double get availableBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_balance')
  double get pendingBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_balance')
  double get totalBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_earned')
  double get totalEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_withdrawn')
  double get totalWithdrawn => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Wallet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletCopyWith<Wallet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletCopyWith<$Res> {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) then) =
      _$WalletCopyWithImpl<$Res, Wallet>;
  @useResult
  $Res call(
      {@JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'available_balance') double availableBalance,
      @JsonKey(name: 'pending_balance') double pendingBalance,
      @JsonKey(name: 'total_balance') double totalBalance,
      @JsonKey(name: 'total_earned') double totalEarned,
      @JsonKey(name: 'total_withdrawn') double totalWithdrawn,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$WalletCopyWithImpl<$Res, $Val extends Wallet>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = null,
    Object? availableBalance = null,
    Object? pendingBalance = null,
    Object? totalBalance = null,
    Object? totalEarned = null,
    Object? totalWithdrawn = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      availableBalance: null == availableBalance
          ? _value.availableBalance
          : availableBalance // ignore: cast_nullable_to_non_nullable
              as double,
      pendingBalance: null == pendingBalance
          ? _value.pendingBalance
          : pendingBalance // ignore: cast_nullable_to_non_nullable
              as double,
      totalBalance: null == totalBalance
          ? _value.totalBalance
          : totalBalance // ignore: cast_nullable_to_non_nullable
              as double,
      totalEarned: null == totalEarned
          ? _value.totalEarned
          : totalEarned // ignore: cast_nullable_to_non_nullable
              as double,
      totalWithdrawn: null == totalWithdrawn
          ? _value.totalWithdrawn
          : totalWithdrawn // ignore: cast_nullable_to_non_nullable
              as double,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletImplCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$$WalletImplCopyWith(
          _$WalletImpl value, $Res Function(_$WalletImpl) then) =
      __$$WalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'vendor_id') String vendorId,
      @JsonKey(name: 'available_balance') double availableBalance,
      @JsonKey(name: 'pending_balance') double pendingBalance,
      @JsonKey(name: 'total_balance') double totalBalance,
      @JsonKey(name: 'total_earned') double totalEarned,
      @JsonKey(name: 'total_withdrawn') double totalWithdrawn,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$WalletImplCopyWithImpl<$Res>
    extends _$WalletCopyWithImpl<$Res, _$WalletImpl>
    implements _$$WalletImplCopyWith<$Res> {
  __$$WalletImplCopyWithImpl(
      _$WalletImpl _value, $Res Function(_$WalletImpl) _then)
      : super(_value, _then);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = null,
    Object? availableBalance = null,
    Object? pendingBalance = null,
    Object? totalBalance = null,
    Object? totalEarned = null,
    Object? totalWithdrawn = null,
    Object? updatedAt = null,
  }) {
    return _then(_$WalletImpl(
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      availableBalance: null == availableBalance
          ? _value.availableBalance
          : availableBalance // ignore: cast_nullable_to_non_nullable
              as double,
      pendingBalance: null == pendingBalance
          ? _value.pendingBalance
          : pendingBalance // ignore: cast_nullable_to_non_nullable
              as double,
      totalBalance: null == totalBalance
          ? _value.totalBalance
          : totalBalance // ignore: cast_nullable_to_non_nullable
              as double,
      totalEarned: null == totalEarned
          ? _value.totalEarned
          : totalEarned // ignore: cast_nullable_to_non_nullable
              as double,
      totalWithdrawn: null == totalWithdrawn
          ? _value.totalWithdrawn
          : totalWithdrawn // ignore: cast_nullable_to_non_nullable
              as double,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletImpl implements _Wallet {
  const _$WalletImpl(
      {@JsonKey(name: 'vendor_id') required this.vendorId,
      @JsonKey(name: 'available_balance') required this.availableBalance,
      @JsonKey(name: 'pending_balance') required this.pendingBalance,
      @JsonKey(name: 'total_balance') required this.totalBalance,
      @JsonKey(name: 'total_earned') required this.totalEarned,
      @JsonKey(name: 'total_withdrawn') required this.totalWithdrawn,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$WalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletImplFromJson(json);

  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  @JsonKey(name: 'available_balance')
  final double availableBalance;
  @override
  @JsonKey(name: 'pending_balance')
  final double pendingBalance;
  @override
  @JsonKey(name: 'total_balance')
  final double totalBalance;
  @override
  @JsonKey(name: 'total_earned')
  final double totalEarned;
  @override
  @JsonKey(name: 'total_withdrawn')
  final double totalWithdrawn;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Wallet(vendorId: $vendorId, availableBalance: $availableBalance, pendingBalance: $pendingBalance, totalBalance: $totalBalance, totalEarned: $totalEarned, totalWithdrawn: $totalWithdrawn, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletImpl &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.availableBalance, availableBalance) ||
                other.availableBalance == availableBalance) &&
            (identical(other.pendingBalance, pendingBalance) ||
                other.pendingBalance == pendingBalance) &&
            (identical(other.totalBalance, totalBalance) ||
                other.totalBalance == totalBalance) &&
            (identical(other.totalEarned, totalEarned) ||
                other.totalEarned == totalEarned) &&
            (identical(other.totalWithdrawn, totalWithdrawn) ||
                other.totalWithdrawn == totalWithdrawn) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vendorId, availableBalance,
      pendingBalance, totalBalance, totalEarned, totalWithdrawn, updatedAt);

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      __$$WalletImplCopyWithImpl<_$WalletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletImplToJson(
      this,
    );
  }
}

abstract class _Wallet implements Wallet {
  const factory _Wallet(
      {@JsonKey(name: 'vendor_id') required final String vendorId,
      @JsonKey(name: 'available_balance')
      required final double availableBalance,
      @JsonKey(name: 'pending_balance') required final double pendingBalance,
      @JsonKey(name: 'total_balance') required final double totalBalance,
      @JsonKey(name: 'total_earned') required final double totalEarned,
      @JsonKey(name: 'total_withdrawn') required final double totalWithdrawn,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$WalletImpl;

  factory _Wallet.fromJson(Map<String, dynamic> json) = _$WalletImpl.fromJson;

  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  @JsonKey(name: 'available_balance')
  double get availableBalance;
  @override
  @JsonKey(name: 'pending_balance')
  double get pendingBalance;
  @override
  @JsonKey(name: 'total_balance')
  double get totalBalance;
  @override
  @JsonKey(name: 'total_earned')
  double get totalEarned;
  @override
  @JsonKey(name: 'total_withdrawn')
  double get totalWithdrawn;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Wallet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
