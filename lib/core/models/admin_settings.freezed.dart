// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminSettings _$AdminSettingsFromJson(Map<String, dynamic> json) {
  return _AdminSettings.fromJson(json);
}

/// @nodoc
mixin _$AdminSettings {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'support_email')
  String? get supportEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'support_phone')
  String? get supportPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_version')
  String? get appVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenance_mode')
  bool get maintenanceMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'maintenance_message')
  String? get maintenanceMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'force_update')
  bool get forceUpdate => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_app_version')
  String? get minAppVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'privacy_policy_url')
  String? get privacyPolicyUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'terms_of_service_url')
  String? get termsOfServiceUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'help_center_url')
  String? get helpCenterUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminSettingsCopyWith<AdminSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminSettingsCopyWith<$Res> {
  factory $AdminSettingsCopyWith(
          AdminSettings value, $Res Function(AdminSettings) then) =
      _$AdminSettingsCopyWithImpl<$Res, AdminSettings>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'support_email') String? supportEmail,
      @JsonKey(name: 'support_phone') String? supportPhone,
      @JsonKey(name: 'app_version') String? appVersion,
      @JsonKey(name: 'maintenance_mode') bool maintenanceMode,
      @JsonKey(name: 'maintenance_message') String? maintenanceMessage,
      @JsonKey(name: 'force_update') bool forceUpdate,
      @JsonKey(name: 'min_app_version') String? minAppVersion,
      @JsonKey(name: 'privacy_policy_url') String? privacyPolicyUrl,
      @JsonKey(name: 'terms_of_service_url') String? termsOfServiceUrl,
      @JsonKey(name: 'help_center_url') String? helpCenterUrl,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$AdminSettingsCopyWithImpl<$Res, $Val extends AdminSettings>
    implements $AdminSettingsCopyWith<$Res> {
  _$AdminSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? supportEmail = freezed,
    Object? supportPhone = freezed,
    Object? appVersion = freezed,
    Object? maintenanceMode = null,
    Object? maintenanceMessage = freezed,
    Object? forceUpdate = null,
    Object? minAppVersion = freezed,
    Object? privacyPolicyUrl = freezed,
    Object? termsOfServiceUrl = freezed,
    Object? helpCenterUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      supportEmail: freezed == supportEmail
          ? _value.supportEmail
          : supportEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      supportPhone: freezed == supportPhone
          ? _value.supportPhone
          : supportPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      maintenanceMode: null == maintenanceMode
          ? _value.maintenanceMode
          : maintenanceMode // ignore: cast_nullable_to_non_nullable
              as bool,
      maintenanceMessage: freezed == maintenanceMessage
          ? _value.maintenanceMessage
          : maintenanceMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      forceUpdate: null == forceUpdate
          ? _value.forceUpdate
          : forceUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      minAppVersion: freezed == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      privacyPolicyUrl: freezed == privacyPolicyUrl
          ? _value.privacyPolicyUrl
          : privacyPolicyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      termsOfServiceUrl: freezed == termsOfServiceUrl
          ? _value.termsOfServiceUrl
          : termsOfServiceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      helpCenterUrl: freezed == helpCenterUrl
          ? _value.helpCenterUrl
          : helpCenterUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$AdminSettingsImplCopyWith<$Res>
    implements $AdminSettingsCopyWith<$Res> {
  factory _$$AdminSettingsImplCopyWith(
          _$AdminSettingsImpl value, $Res Function(_$AdminSettingsImpl) then) =
      __$$AdminSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'support_email') String? supportEmail,
      @JsonKey(name: 'support_phone') String? supportPhone,
      @JsonKey(name: 'app_version') String? appVersion,
      @JsonKey(name: 'maintenance_mode') bool maintenanceMode,
      @JsonKey(name: 'maintenance_message') String? maintenanceMessage,
      @JsonKey(name: 'force_update') bool forceUpdate,
      @JsonKey(name: 'min_app_version') String? minAppVersion,
      @JsonKey(name: 'privacy_policy_url') String? privacyPolicyUrl,
      @JsonKey(name: 'terms_of_service_url') String? termsOfServiceUrl,
      @JsonKey(name: 'help_center_url') String? helpCenterUrl,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$AdminSettingsImplCopyWithImpl<$Res>
    extends _$AdminSettingsCopyWithImpl<$Res, _$AdminSettingsImpl>
    implements _$$AdminSettingsImplCopyWith<$Res> {
  __$$AdminSettingsImplCopyWithImpl(
      _$AdminSettingsImpl _value, $Res Function(_$AdminSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? supportEmail = freezed,
    Object? supportPhone = freezed,
    Object? appVersion = freezed,
    Object? maintenanceMode = null,
    Object? maintenanceMessage = freezed,
    Object? forceUpdate = null,
    Object? minAppVersion = freezed,
    Object? privacyPolicyUrl = freezed,
    Object? termsOfServiceUrl = freezed,
    Object? helpCenterUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AdminSettingsImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      supportEmail: freezed == supportEmail
          ? _value.supportEmail
          : supportEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      supportPhone: freezed == supportPhone
          ? _value.supportPhone
          : supportPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      maintenanceMode: null == maintenanceMode
          ? _value.maintenanceMode
          : maintenanceMode // ignore: cast_nullable_to_non_nullable
              as bool,
      maintenanceMessage: freezed == maintenanceMessage
          ? _value.maintenanceMessage
          : maintenanceMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      forceUpdate: null == forceUpdate
          ? _value.forceUpdate
          : forceUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      minAppVersion: freezed == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      privacyPolicyUrl: freezed == privacyPolicyUrl
          ? _value.privacyPolicyUrl
          : privacyPolicyUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      termsOfServiceUrl: freezed == termsOfServiceUrl
          ? _value.termsOfServiceUrl
          : termsOfServiceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      helpCenterUrl: freezed == helpCenterUrl
          ? _value.helpCenterUrl
          : helpCenterUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$AdminSettingsImpl implements _AdminSettings {
  const _$AdminSettingsImpl(
      {this.id,
      @JsonKey(name: 'support_email') this.supportEmail,
      @JsonKey(name: 'support_phone') this.supportPhone,
      @JsonKey(name: 'app_version') this.appVersion,
      @JsonKey(name: 'maintenance_mode') this.maintenanceMode = false,
      @JsonKey(name: 'maintenance_message') this.maintenanceMessage,
      @JsonKey(name: 'force_update') this.forceUpdate = false,
      @JsonKey(name: 'min_app_version') this.minAppVersion,
      @JsonKey(name: 'privacy_policy_url') this.privacyPolicyUrl,
      @JsonKey(name: 'terms_of_service_url') this.termsOfServiceUrl,
      @JsonKey(name: 'help_center_url') this.helpCenterUrl,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$AdminSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminSettingsImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'support_email')
  final String? supportEmail;
  @override
  @JsonKey(name: 'support_phone')
  final String? supportPhone;
  @override
  @JsonKey(name: 'app_version')
  final String? appVersion;
  @override
  @JsonKey(name: 'maintenance_mode')
  final bool maintenanceMode;
  @override
  @JsonKey(name: 'maintenance_message')
  final String? maintenanceMessage;
  @override
  @JsonKey(name: 'force_update')
  final bool forceUpdate;
  @override
  @JsonKey(name: 'min_app_version')
  final String? minAppVersion;
  @override
  @JsonKey(name: 'privacy_policy_url')
  final String? privacyPolicyUrl;
  @override
  @JsonKey(name: 'terms_of_service_url')
  final String? termsOfServiceUrl;
  @override
  @JsonKey(name: 'help_center_url')
  final String? helpCenterUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AdminSettings(id: $id, supportEmail: $supportEmail, supportPhone: $supportPhone, appVersion: $appVersion, maintenanceMode: $maintenanceMode, maintenanceMessage: $maintenanceMessage, forceUpdate: $forceUpdate, minAppVersion: $minAppVersion, privacyPolicyUrl: $privacyPolicyUrl, termsOfServiceUrl: $termsOfServiceUrl, helpCenterUrl: $helpCenterUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.supportEmail, supportEmail) ||
                other.supportEmail == supportEmail) &&
            (identical(other.supportPhone, supportPhone) ||
                other.supportPhone == supportPhone) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.maintenanceMode, maintenanceMode) ||
                other.maintenanceMode == maintenanceMode) &&
            (identical(other.maintenanceMessage, maintenanceMessage) ||
                other.maintenanceMessage == maintenanceMessage) &&
            (identical(other.forceUpdate, forceUpdate) ||
                other.forceUpdate == forceUpdate) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion) &&
            (identical(other.privacyPolicyUrl, privacyPolicyUrl) ||
                other.privacyPolicyUrl == privacyPolicyUrl) &&
            (identical(other.termsOfServiceUrl, termsOfServiceUrl) ||
                other.termsOfServiceUrl == termsOfServiceUrl) &&
            (identical(other.helpCenterUrl, helpCenterUrl) ||
                other.helpCenterUrl == helpCenterUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      supportEmail,
      supportPhone,
      appVersion,
      maintenanceMode,
      maintenanceMessage,
      forceUpdate,
      minAppVersion,
      privacyPolicyUrl,
      termsOfServiceUrl,
      helpCenterUrl,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminSettingsImplCopyWith<_$AdminSettingsImpl> get copyWith =>
      __$$AdminSettingsImplCopyWithImpl<_$AdminSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminSettingsImplToJson(
      this,
    );
  }
}

abstract class _AdminSettings implements AdminSettings {
  const factory _AdminSettings(
      {final String? id,
      @JsonKey(name: 'support_email') final String? supportEmail,
      @JsonKey(name: 'support_phone') final String? supportPhone,
      @JsonKey(name: 'app_version') final String? appVersion,
      @JsonKey(name: 'maintenance_mode') final bool maintenanceMode,
      @JsonKey(name: 'maintenance_message') final String? maintenanceMessage,
      @JsonKey(name: 'force_update') final bool forceUpdate,
      @JsonKey(name: 'min_app_version') final String? minAppVersion,
      @JsonKey(name: 'privacy_policy_url') final String? privacyPolicyUrl,
      @JsonKey(name: 'terms_of_service_url') final String? termsOfServiceUrl,
      @JsonKey(name: 'help_center_url') final String? helpCenterUrl,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$AdminSettingsImpl;

  factory _AdminSettings.fromJson(Map<String, dynamic> json) =
      _$AdminSettingsImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'support_email')
  String? get supportEmail;
  @override
  @JsonKey(name: 'support_phone')
  String? get supportPhone;
  @override
  @JsonKey(name: 'app_version')
  String? get appVersion;
  @override
  @JsonKey(name: 'maintenance_mode')
  bool get maintenanceMode;
  @override
  @JsonKey(name: 'maintenance_message')
  String? get maintenanceMessage;
  @override
  @JsonKey(name: 'force_update')
  bool get forceUpdate;
  @override
  @JsonKey(name: 'min_app_version')
  String? get minAppVersion;
  @override
  @JsonKey(name: 'privacy_policy_url')
  String? get privacyPolicyUrl;
  @override
  @JsonKey(name: 'terms_of_service_url')
  String? get termsOfServiceUrl;
  @override
  @JsonKey(name: 'help_center_url')
  String? get helpCenterUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AdminSettingsImplCopyWith<_$AdminSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
