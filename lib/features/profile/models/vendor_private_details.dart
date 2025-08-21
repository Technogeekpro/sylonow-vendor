import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_private_details.freezed.dart';
part 'vendor_private_details.g.dart';

@freezed
class VendorPrivateDetails with _$VendorPrivateDetails {
  const factory VendorPrivateDetails({
    String? id,
    @JsonKey(name: 'vendor_id') String? vendorId,
    @JsonKey(name: 'bank_account_number') String? bankAccountNumber,
    @JsonKey(name: 'bank_ifsc_code') String? bankIfscCode,
    @JsonKey(name: 'gst_number') String? gstNumber,
    @JsonKey(name: 'aadhaar_number') String? aadhaarNumber, // Fixed spelling to match DB
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _VendorPrivateDetails;

  factory VendorPrivateDetails.fromJson(Map<String, dynamic> json) => _$VendorPrivateDetailsFromJson(json);

  // Helper methods
  const VendorPrivateDetails._();

  bool get hasBankDetails => 
      bankAccountNumber != null && 
      bankIfscCode != null && 
      bankAccountNumber!.isNotEmpty && 
      bankIfscCode!.isNotEmpty;

  bool get hasGstDetails => gstNumber != null && gstNumber!.isNotEmpty;

  bool get hasAadhaarDetails => aadhaarNumber != null && aadhaarNumber!.isNotEmpty;

  // Formatted bank account for display (shows only last 4 digits)
  String get formattedBankAccount {
    if (bankAccountNumber == null || bankAccountNumber!.length < 4) {
      return bankAccountNumber ?? '';
    }
    final length = bankAccountNumber!.length;
    final hiddenPart = '*' * (length - 4);
    final visiblePart = bankAccountNumber!.substring(length - 4);
    return '$hiddenPart$visiblePart';
  }

  // Validation methods
  bool isValidBankDetails() {
    return bankAccountNumber != null && 
           bankAccountNumber!.length >= 8 &&
           bankIfscCode != null && 
           bankIfscCode!.length == 11;
  }

  bool isValidGst() {
    if (gstNumber == null) return false;
    // Basic GST validation - 15 characters
    final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    return gstRegex.hasMatch(gstNumber!);
  }

  bool isValidAadhaar() {
    if (aadhaarNumber == null) return false;
    // Aadhaar validation - 12 digits
    final aadhaarRegex = RegExp(r'^[0-9]{12}$');
    return aadhaarRegex.hasMatch(aadhaarNumber!);
  }
}