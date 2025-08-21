// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_add_on.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceAddOnImpl _$$ServiceAddOnImplFromJson(Map<String, dynamic> json) =>
    _$ServiceAddOnImpl(
      id: json['id'] as String?,
      serviceListingId: json['service_listing_id'] as String,
      name: json['name'] as String,
      originalPrice: (json['original_price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      type: json['type'] as String? ?? 'add_on',
      unit: json['unit'] as String? ?? 'piece',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceAddOnImplToJson(_$ServiceAddOnImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_listing_id': instance.serviceListingId,
      'name': instance.name,
      'original_price': instance.originalPrice,
      'discount_price': instance.discountPrice,
      'description': instance.description,
      'images': instance.images,
      'type': instance.type,
      'unit': instance.unit,
      'stock': instance.stock,
      'is_available': instance.isAvailable,
      'sort_order': instance.sortOrder,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
