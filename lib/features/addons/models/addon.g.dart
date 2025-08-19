// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddonImpl _$$AddonImplFromJson(Map<String, dynamic> json) => _$AddonImpl(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String,
      theaterId: json['theater_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? 'cake',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AddonImplToJson(_$AddonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendor_id': instance.vendorId,
      'theater_id': instance.theaterId,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'category': instance.category,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
