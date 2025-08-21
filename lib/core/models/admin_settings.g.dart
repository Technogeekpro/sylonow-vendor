// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminSettingsImpl _$$AdminSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AdminSettingsImpl(
      id: json['id'] as String?,
      supportEmail: json['support_email'] as String?,
      supportPhone: json['support_phone'] as String?,
      appVersion: json['app_version'] as String?,
      maintenanceMode: json['maintenance_mode'] as bool? ?? false,
      maintenanceMessage: json['maintenance_message'] as String?,
      forceUpdate: json['force_update'] as bool? ?? false,
      minAppVersion: json['min_app_version'] as String?,
      privacyPolicyUrl: json['privacy_policy_url'] as String?,
      termsOfServiceUrl: json['terms_of_service_url'] as String?,
      helpCenterUrl: json['help_center_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AdminSettingsImplToJson(_$AdminSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'support_email': instance.supportEmail,
      'support_phone': instance.supportPhone,
      'app_version': instance.appVersion,
      'maintenance_mode': instance.maintenanceMode,
      'maintenance_message': instance.maintenanceMessage,
      'force_update': instance.forceUpdate,
      'min_app_version': instance.minAppVersion,
      'privacy_policy_url': instance.privacyPolicyUrl,
      'terms_of_service_url': instance.termsOfServiceUrl,
      'help_center_url': instance.helpCenterUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
