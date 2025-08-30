// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminSettingsServiceHash() =>
    r'116e20d43715018820e75d5499af2864bf1c7226';

/// See also [adminSettingsService].
@ProviderFor(adminSettingsService)
final adminSettingsServiceProvider =
    AutoDisposeProvider<AdminSettingsService>.internal(
  adminSettingsService,
  name: r'adminSettingsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminSettingsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminSettingsServiceRef = AutoDisposeProviderRef<AdminSettingsService>;
String _$supportEmailHash() => r'f11ab31970c705671723bbbc0e587ece5d7222ad';

/// See also [supportEmail].
@ProviderFor(supportEmail)
final supportEmailProvider = AutoDisposeFutureProvider<String>.internal(
  supportEmail,
  name: r'supportEmailProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$supportEmailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupportEmailRef = AutoDisposeFutureProviderRef<String>;
String _$supportPhoneHash() => r'346f6658e21456a71a368bfb9fbb4a2e07d741aa';

/// See also [supportPhone].
@ProviderFor(supportPhone)
final supportPhoneProvider = AutoDisposeFutureProvider<String>.internal(
  supportPhone,
  name: r'supportPhoneProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$supportPhoneHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupportPhoneRef = AutoDisposeFutureProviderRef<String>;
String _$adminSettingsDataHash() => r'dfe0e8b40b60fa3cfce9f262112936f57d4f8d37';

/// See also [AdminSettingsData].
@ProviderFor(AdminSettingsData)
final adminSettingsDataProvider =
    AutoDisposeAsyncNotifierProvider<AdminSettingsData, AdminSettings>.internal(
  AdminSettingsData.new,
  name: r'adminSettingsDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminSettingsDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminSettingsData = AutoDisposeAsyncNotifier<AdminSettings>;
String _$supportContactHash() => r'7bfbee24b0c5433275f18c271a2fd1f2096ff340';

/// See also [SupportContact].
@ProviderFor(SupportContact)
final supportContactProvider = AutoDisposeAsyncNotifierProvider<SupportContact,
    Map<String, String>>.internal(
  SupportContact.new,
  name: r'supportContactProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supportContactHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SupportContact = AutoDisposeAsyncNotifier<Map<String, String>>;
String _$maintenanceModeHash() => r'4ff9a9b077ca3d5c14525ff091e39ab81215c099';

/// See also [MaintenanceMode].
@ProviderFor(MaintenanceMode)
final maintenanceModeProvider =
    AutoDisposeAsyncNotifierProvider<MaintenanceMode, bool>.internal(
  MaintenanceMode.new,
  name: r'maintenanceModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$maintenanceModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MaintenanceMode = AutoDisposeAsyncNotifier<bool>;
String _$forceUpdateHash() => r'6fce3ff3a324c4920c1ed521ad1a1d7de52b253f';

/// See also [ForceUpdate].
@ProviderFor(ForceUpdate)
final forceUpdateProvider =
    AutoDisposeAsyncNotifierProvider<ForceUpdate, bool>.internal(
  ForceUpdate.new,
  name: r'forceUpdateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$forceUpdateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ForceUpdate = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
