// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_private_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vendorPrivateDetailsServiceHash() =>
    r'dcfc05fc0c8f01b52aae123b1afa88e7b055facd';

/// See also [vendorPrivateDetailsService].
@ProviderFor(vendorPrivateDetailsService)
final vendorPrivateDetailsServiceProvider =
    AutoDisposeProvider<VendorPrivateDetailsService>.internal(
  vendorPrivateDetailsService,
  name: r'vendorPrivateDetailsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vendorPrivateDetailsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef VendorPrivateDetailsServiceRef
    = AutoDisposeProviderRef<VendorPrivateDetailsService>;
String _$vendorBankDetailsHash() => r'6b99d25d44004a4e3fcaeda6b5a0d548dbe1357b';

/// See also [vendorBankDetails].
@ProviderFor(vendorBankDetails)
final vendorBankDetailsProvider =
    AutoDisposeFutureProvider<Map<String, String>?>.internal(
  vendorBankDetails,
  name: r'vendorBankDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vendorBankDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef VendorBankDetailsRef
    = AutoDisposeFutureProviderRef<Map<String, String>?>;
String _$hasBankDetailsHash() => r'f668e449095c5413b32fe090a9863726e4a75270';

/// See also [hasBankDetails].
@ProviderFor(hasBankDetails)
final hasBankDetailsProvider = AutoDisposeFutureProvider<bool>.internal(
  hasBankDetails,
  name: r'hasBankDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasBankDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasBankDetailsRef = AutoDisposeFutureProviderRef<bool>;
String _$hasGstDetailsHash() => r'6fdeac91873c1511cf80f702f9541f70b44208ae';

/// See also [hasGstDetails].
@ProviderFor(hasGstDetails)
final hasGstDetailsProvider = AutoDisposeFutureProvider<bool>.internal(
  hasGstDetails,
  name: r'hasGstDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasGstDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasGstDetailsRef = AutoDisposeFutureProviderRef<bool>;
String _$hasAadhaarDetailsHash() => r'435e8651520beb533ead3be1bc2a8f4dd75a61bc';

/// See also [hasAadhaarDetails].
@ProviderFor(hasAadhaarDetails)
final hasAadhaarDetailsProvider = AutoDisposeFutureProvider<bool>.internal(
  hasAadhaarDetails,
  name: r'hasAadhaarDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasAadhaarDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasAadhaarDetailsRef = AutoDisposeFutureProviderRef<bool>;
String _$vendorPrivateDetailsDataHash() =>
    r'52c34a1928b69d248cb98452f98d45c4f43827b4';

/// See also [VendorPrivateDetailsData].
@ProviderFor(VendorPrivateDetailsData)
final vendorPrivateDetailsDataProvider = AutoDisposeAsyncNotifierProvider<
    VendorPrivateDetailsData, VendorPrivateDetails?>.internal(
  VendorPrivateDetailsData.new,
  name: r'vendorPrivateDetailsDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vendorPrivateDetailsDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VendorPrivateDetailsData
    = AutoDisposeAsyncNotifier<VendorPrivateDetails?>;
String _$validationHelperHash() => r'08b01fdac61effb625a3e4967fcb3342f0cdb3bb';

/// See also [ValidationHelper].
@ProviderFor(ValidationHelper)
final validationHelperProvider = AutoDisposeNotifierProvider<ValidationHelper,
    Map<String, bool Function(String)>>.internal(
  ValidationHelper.new,
  name: r'validationHelperProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$validationHelperHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ValidationHelper
    = AutoDisposeNotifier<Map<String, bool Function(String)>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
