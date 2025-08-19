// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletTransactionImpl _$$WalletTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletTransactionImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      transactionType: json['transaction_type'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String?,
      description: json['description'] as String?,
      referenceId: json['reference_id'] as String?,
      referenceType: json['reference_type'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WalletTransactionImplToJson(
        _$WalletTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'transaction_type': instance.transactionType,
      'amount': instance.amount,
      'status': instance.status,
      'description': instance.description,
      'reference_id': instance.referenceId,
      'reference_type': instance.referenceType,
      'metadata': instance.metadata,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
