// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorNotificationImpl _$$VendorNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$VendorNotificationImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      actionData: json['actionData'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$VendorNotificationImplToJson(
        _$VendorNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'actionData': instance.actionData,
      'imageUrl': instance.imageUrl,
      'is_read': instance.isRead,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
