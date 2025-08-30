// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletImpl _$$WalletImplFromJson(Map<String, dynamic> json) => _$WalletImpl(
      vendorId: json['vendor_id'] as String,
      availableBalance: (json['available_balance'] as num).toDouble(),
      pendingBalance: (json['pending_balance'] as num).toDouble(),
      totalBalance: (json['total_balance'] as num).toDouble(),
      totalEarned: (json['total_earned'] as num).toDouble(),
      totalWithdrawn: (json['total_withdrawn'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WalletImplToJson(_$WalletImpl instance) =>
    <String, dynamic>{
      'vendor_id': instance.vendorId,
      'available_balance': instance.availableBalance,
      'pending_balance': instance.pendingBalance,
      'total_balance': instance.totalBalance,
      'total_earned': instance.totalEarned,
      'total_withdrawn': instance.totalWithdrawn,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
