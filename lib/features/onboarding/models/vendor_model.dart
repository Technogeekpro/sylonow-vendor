class VendorModel {
  final String id;
  final String mobileNumber;
  final String fullName;
  final String? authUserId;
  final String? serviceArea;
  final String? pincode;
  final String? serviceType;
  final String? businessName;
  final String? aadhaarNumber;
  final String? bankAccountNumber;
  final String? bankIfscCode;
  final String? gstNumber;
  final String? profilePicture;
  final String? aadhaarFrontImage;
  final String? aadhaarBackImage;
  final String? panCardImage;
  final bool isVerified;
  final bool isOnboardingComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VendorModel({
    required this.id,
    required this.mobileNumber,
    required this.fullName,
    this.authUserId,
    this.serviceArea,
    this.pincode,
    this.serviceType,
    this.businessName,
    this.aadhaarNumber,
    this.bankAccountNumber,
    this.bankIfscCode,
    this.gstNumber,
    this.profilePicture,
    this.aadhaarFrontImage,
    this.aadhaarBackImage,
    this.panCardImage,
    this.isVerified = false,
    this.isOnboardingComplete = false,
    this.createdAt,
    this.updatedAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as String,
      mobileNumber: json['mobile_number'] as String,
      fullName: json['full_name'] as String,
      authUserId: json['auth_user_id'] as String?,
      serviceArea: json['service_area'] as String?,
      pincode: json['pincode'] as String?,
      serviceType: json['service_type'] as String?,
      businessName: json['business_name'] as String?,
      aadhaarNumber: json['aadhaar_number'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,
      bankIfscCode: json['bank_ifsc_code'] as String?,
      gstNumber: json['gst_number'] as String?,
      profilePicture: json['profile_picture'] as String?,
      aadhaarFrontImage: json['aadhaar_front_image'] as String?,
      aadhaarBackImage: json['aadhaar_back_image'] as String?,
      panCardImage: json['pan_card_image'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isOnboardingComplete: json['is_onboarding_complete'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile_number': mobileNumber,
      'full_name': fullName,
      'auth_user_id': authUserId,
      'service_area': serviceArea,
      'pincode': pincode,
      'service_type': serviceType,
      'business_name': businessName,
      'aadhaar_number': aadhaarNumber,
      'bank_account_number': bankAccountNumber,
      'bank_ifsc_code': bankIfscCode,
      'gst_number': gstNumber,
      'profile_picture': profilePicture,
      'aadhaar_front_image': aadhaarFrontImage,
      'aadhaar_back_image': aadhaarBackImage,
      'pan_card_image': panCardImage,
      'is_verified': isVerified,
      'is_onboarding_complete': isOnboardingComplete,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  VendorModel copyWith({
    String? id,
    String? mobileNumber,
    String? fullName,
    String? authUserId,
    String? serviceArea,
    String? pincode,
    String? serviceType,
    String? businessName,
    String? aadhaarNumber,
    String? bankAccountNumber,
    String? bankIfscCode,
    String? gstNumber,
    String? profilePicture,
    String? aadhaarFrontImage,
    String? aadhaarBackImage,
    String? panCardImage,
    bool? isVerified,
    bool? isOnboardingComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      fullName: fullName ?? this.fullName,
      authUserId: authUserId ?? this.authUserId,
      serviceArea: serviceArea ?? this.serviceArea,
      pincode: pincode ?? this.pincode,
      serviceType: serviceType ?? this.serviceType,
      businessName: businessName ?? this.businessName,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankIfscCode: bankIfscCode ?? this.bankIfscCode,
      gstNumber: gstNumber ?? this.gstNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      aadhaarFrontImage: aadhaarFrontImage ?? this.aadhaarFrontImage,
      aadhaarBackImage: aadhaarBackImage ?? this.aadhaarBackImage,
      panCardImage: panCardImage ?? this.panCardImage,
      isVerified: isVerified ?? this.isVerified,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String formatMobileNumber(String mobileNumber) {
    // Remove any existing country code
    String cleanNumber = mobileNumber.replaceAll('+91', '').trim();
    // Add country code if not present
    return cleanNumber.startsWith('+91') ? cleanNumber : '+91$cleanNumber';
  }
} 