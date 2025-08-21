import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_settings.freezed.dart';
part 'admin_settings.g.dart';

@freezed
class AdminSettings with _$AdminSettings {
  const factory AdminSettings({
    String? id,
    @JsonKey(name: 'support_email') String? supportEmail,
    @JsonKey(name: 'support_phone') String? supportPhone,
    @JsonKey(name: 'app_version') String? appVersion,
    @JsonKey(name: 'maintenance_mode') @Default(false) bool maintenanceMode,
    @JsonKey(name: 'maintenance_message') String? maintenanceMessage,
    @JsonKey(name: 'force_update') @Default(false) bool forceUpdate,
    @JsonKey(name: 'min_app_version') String? minAppVersion,
    @JsonKey(name: 'privacy_policy_url') String? privacyPolicyUrl,
    @JsonKey(name: 'terms_of_service_url') String? termsOfServiceUrl,
    @JsonKey(name: 'help_center_url') String? helpCenterUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AdminSettings;

  factory AdminSettings.fromJson(Map<String, dynamic> json) => _$AdminSettingsFromJson(json);

  // Default fallback values
  static const AdminSettings defaultSettings = AdminSettings(
    supportEmail: 'support@sylonow.com',
    supportPhone: '+91 98765 43210',
    appVersion: '1.0.0',
    maintenanceMode: false,
    forceUpdate: false,
  );
}