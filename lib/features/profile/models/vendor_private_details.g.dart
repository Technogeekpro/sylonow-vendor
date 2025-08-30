// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_private_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorPrivateDetailsImpl _$$VendorPrivateDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$VendorPrivateDetailsImpl(
      id: json['id'] as String?,
      vendorId: json['vendor_id'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,
      bankIfscCode: json['bank_ifsc_code'] as String?,
      gstNumber: json['gst_number'] as String?,
      aadhaarNumber: json['aadhaar_number'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$VendorPrivateDetailsImplToJson(
        _$VendorPrivateDetailsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'bank_account_number': instance.bankAccountNumber,
      'bank_ifsc_code': instance.bankIfscCode,
      'gst_number': instance.gstNumber,
      'aadhaar_number': instance.aadhaarNumber,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
