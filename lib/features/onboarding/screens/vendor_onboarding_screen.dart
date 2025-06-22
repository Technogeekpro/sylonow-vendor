import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/vendor_onboarding_controller.dart';
import '../providers/vendor_provider.dart';
import '../providers/service_types_provider.dart';
import '../service/service_types_service.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorOnboardingScreen extends ConsumerStatefulWidget {
  const VendorOnboardingScreen({super.key});

  @override
  ConsumerState<VendorOnboardingScreen> createState() => _VendorOnboardingScreenState();
}

class _VendorOnboardingScreenState extends ConsumerState<VendorOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  
  // Form Controllers
  final _fullNameController = TextEditingController();
  final _serviceAreaController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _aadhaarNumberController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _gstNumberController = TextEditingController();

  ServiceType? _selectedServiceType;
  int _currentPage = 0;

  @override
  void dispose() {
    _fullNameController.dispose();
    _serviceAreaController.dispose();
    _pincodeController.dispose();
    _businessNameController.dispose();
    _aadhaarNumberController.dispose();
    _bankAccountController.dispose();
    _bankIfscController.dispose();
    _gstNumberController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(vendorOnboardingControllerProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        title: const Text(
          'Vendor Registration',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 3,
              backgroundColor: AppTheme.dividerColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            _buildBasicInfoPage(),
            _buildBusinessInfoPage(),
            _buildDocumentsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_currentPage > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppTheme.primaryColor),
                  ),
                  child: const Text(
                    'Previous',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (_currentPage > 0) const SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onboardingState.isLoading ? null : _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppTheme.textOnPrimary,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: onboardingState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _currentPage == 2 ? 'Submit Application' : 'Next',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Basic Information',
            'Tell us about yourself',
            Icons.person,
          ),
          const SizedBox(height: 24),
          
          // Profile Picture Upload
          _buildProfilePictureSection(),
          const SizedBox(height: 24),
          
          CustomTextField(
            controller: _fullNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Full name is required';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _serviceAreaController,
            label: 'Service Area',
            hint: 'e.g., Bangalore,JP Nagar',
            prefixIcon: Icons.location_on_outlined,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Service area is required';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _pincodeController,
            label: 'Pincode',
            hint: 'Enter your pincode',
            prefixIcon: Icons.pin_drop_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Pincode is required';
              if (value!.length != 6) return 'Enter a valid 6-digit pincode';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          _buildServiceTypeDropdown(),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Business Information',
            'Provide your business details',
            Icons.business,
          ),
          const SizedBox(height: 24),
          
          CustomTextField(
            controller: _businessNameController,
            label: 'Business Name',
            hint: 'Enter your business name',
            prefixIcon: Icons.business_outlined,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Business name is required';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _aadhaarNumberController,
            label: 'Aadhaar Number',
            hint: 'Enter 12-digit Aadhaar number',
            prefixIcon: Icons.credit_card_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Aadhaar number is required';
              if (value!.length != 12) return 'Enter a valid 12-digit Aadhaar number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _bankAccountController,
            label: 'Bank Account Number',
            hint: 'Enter your bank account number',
            prefixIcon: Icons.account_balance_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Bank account number is required';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _bankIfscController,
            label: 'Bank IFSC Code',
            hint: 'Enter IFSC code',
            prefixIcon: Icons.code_outlined,
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'IFSC code is required';
              if (value!.length != 11) return 'Enter a valid 11-character IFSC code';
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _gstNumberController,
            label: 'GST Number (Optional)',
            hint: 'Enter GST number if applicable',
            prefixIcon: Icons.receipt_outlined,
            textCapitalization: TextCapitalization.characters,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsPage() {
    final onboardingState = ref.watch(vendorOnboardingControllerProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Documents Upload',
            'Upload required documents for verification',
            Icons.upload_file,
          ),
          const SizedBox(height: 24),
          
          ImageUploadWidget(
            title: 'Aadhaar Front Image',
            subtitle: 'Upload clear image of Aadhaar front side',
            image: onboardingState.aadhaarFrontImage,
            documentType: 'aadhaar_front',
            onImageSelected: (image) {
              ref.read(vendorOnboardingControllerProvider.notifier)
                  .setAadhaarFrontImage(image);
            },
            onImageUploaded: (url) {
              ref.read(vendorOnboardingControllerProvider.notifier)
                  .setAadhaarFrontImageUrl(url);
            },
          ),
          const SizedBox(height: 20),
          
          ImageUploadWidget(
            title: 'Aadhaar Back Image',
            subtitle: 'Upload clear image of Aadhaar back side',
            image: onboardingState.aadhaarBackImage,
            documentType: 'aadhaar_back',
            onImageSelected: (image) {
              ref.read(vendorOnboardingControllerProvider.notifier)
                  .setAadhaarBackImage(image);
            },
            onImageUploaded: (url) {
              ref.read(vendorOnboardingControllerProvider.notifier)
                  .setAadhaarBackImageUrl(url);
            },
          ),
          const SizedBox(height: 20),
          
          ImageUploadWidget(
            title: 'PAN Card Image',
            subtitle: 'Upload clear image of PAN card',
            image: onboardingState.panCardImage,
            documentType: 'pan_card',
            onImageSelected: (image) {
              ref.read(vendorOnboardingControllerProvider.notifier)
                  .setPanCardImage(image);
            },
            onImageUploaded: (url) {
              ref.read(vendorOnboardingControllerProvider.notifier)
                  .setPanCardImageUrl(url);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primarySurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection() {
    final onboardingState = ref.watch(vendorOnboardingControllerProvider);
    
    return Center(
      child: GestureDetector(
        onTap: _pickProfileImage,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primarySurface,
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: onboardingState.profileImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.file(
                    onboardingState.profileImage!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 32,
                      color: AppTheme.textSecondaryColor,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add Photo',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildServiceTypeDropdown() {
    final serviceTypesAsync = ref.watch(serviceTypesProvider);
    
    return serviceTypesAsync.when(
      data: (serviceTypes) => DropdownButtonFormField<ServiceType>(
        value: _selectedServiceType,
        decoration: InputDecoration(
          labelText: 'Service Type',
          hintText: 'Select your service type',
          prefixIcon: const Icon(Icons.work_outline),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryColor),
          ),
          filled: true,
          fillColor: AppTheme.surfaceColor,
        ),
        items: serviceTypes.map((ServiceType service) {
          return DropdownMenuItem<ServiceType>(
            value: service,
            child: Text(service.name),
          );
        }).toList(),
        onChanged: (ServiceType? newValue) {
          setState(() {
            _selectedServiceType = newValue;
          });
        },
        validator: (value) {
          if (value == null) return 'Please select a service type';
          return null;
        },
      ),
      loading: () => Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Center(
          child: Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.work_outline, color: AppTheme.textSecondaryColor),
              SizedBox(width: 12),
              Text(
                'Loading service types...',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
      error: (error, stack) => Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
        ),
        child: Center(
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.error_outline, color: AppTheme.errorColor),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Failed to load service types',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 14,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.invalidate(serviceTypesProvider);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        final File imageFile = File(image.path);
        
        // Try to upload immediately to Supabase
        try {
          final user = SupabaseConfig.client.auth.currentUser;
          if (user != null) {
            final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final filePath = '${user.id}/$fileName';
            
            print('🔵 Uploading profile image to Supabase...');
            
            await SupabaseConfig.client.storage
                .from('profile-pictures')
                .upload(filePath, imageFile, fileOptions: const FileOptions(upsert: true));
                
            final String publicUrl = SupabaseConfig.client.storage
                .from('profile-pictures')
                .getPublicUrl(filePath);
                
            print('🟢 Profile image uploaded successfully: $publicUrl');
            
            ref.read(vendorOnboardingControllerProvider.notifier)
                .setProfileImageUrl(publicUrl);
                
            // Also clear the local file since we have the URL
            ref.read(vendorOnboardingControllerProvider.notifier)
                .setProfileImage(null);
                
            return;
          }
        } catch (uploadError) {
          print('🔴 Profile image upload failed, using local storage: $uploadError');
        }
        
        // Fallback to local storage if upload fails
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = 'vendor_profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
        final String permanentPath = path.join(appDir.path, 'vendor_uploads', fileName);
        
        // Create directory if it doesn't exist
        await Directory(path.dirname(permanentPath)).create(recursive: true);
        
        // Copy the file to permanent location
        final File permanentFile = await File(image.path).copy(permanentPath);
        
        // Verify the copy was successful
        if (!await permanentFile.exists()) {
          throw Exception('Failed to save profile image to persistent storage');
        }
        
        final persistentSize = await permanentFile.length();
        if (persistentSize == 0) {
          throw Exception('Profile image file became corrupted during save');
        }
        
        print('📸 Profile image copied to permanent location: $permanentPath ($persistentSize bytes)');
        
        ref.read(vendorOnboardingControllerProvider.notifier)
            .setProfileImage(permanentFile);
      }
    } catch (e) {
      print('📸 Error picking profile image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select image: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _handleNext() {
    if (_currentPage < 2) {
      if (_validateCurrentPage()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitApplication();
    }
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        return _formKey.currentState?.validate() ?? false;
      case 1:
        return _formKey.currentState?.validate() ?? false;
      case 2:
        final state = ref.read(vendorOnboardingControllerProvider);
        if ((state.aadhaarFrontImage == null && state.aadhaarFrontImageUrl == null) ||
            (state.aadhaarBackImage == null && state.aadhaarBackImageUrl == null) ||
            (state.panCardImage == null && state.panCardImageUrl == null)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please upload all required documents'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Future<void> _submitApplication() async {
    if (!_validateCurrentPage()) return;

    final controller = ref.read(vendorOnboardingControllerProvider.notifier);
    
    final success = await controller.submitVendorApplication(
      fullName: _fullNameController.text.trim(),
      serviceArea: _serviceAreaController.text.trim(),
      pincode: _pincodeController.text.trim(),
      serviceType: _selectedServiceType!.id,
      businessName: _businessNameController.text.trim(),
      aadhaarNumber: _aadhaarNumberController.text.trim(),
      bankAccountNumber: _bankAccountController.text.trim(),
      bankIfscCode: _bankIfscController.text.trim(),
      gstNumber: _gstNumberController.text.trim().isEmpty 
          ? null 
          : _gstNumberController.text.trim(),
    );

    // Check if widget is still mounted before proceeding
    if (!mounted) {
      print('⚠️ Widget unmounted after submission, skipping UI updates');
      return;
    }

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Application submitted successfully!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // Wait for success message to be visible
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Check mounted again before continuing
      if (!mounted) {
        print('⚠️ Widget unmounted during success message delay, skipping navigation');
        return;
      }
      
      try {
        // Force refresh the vendor provider and wait for it to complete
        print('🔄 Refreshing vendor state after successful submission...');
        await ref.read(vendorProvider.notifier).refreshVendor();
        
        // Check mounted again after async operation
        if (!mounted) {
          print('⚠️ Widget unmounted after vendor refresh, skipping navigation');
          return;
        }
        
        // Wait a bit more to ensure state propagation
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Final mounted check before navigation
        if (!mounted) {
          print('⚠️ Widget unmounted before navigation, skipping');
          return;
        }
        
        // Navigate to pending verification directly instead of letting router decide
        print('🚀 Navigating to pending verification...');
        context.go('/pending-verification');
      } catch (e) {
        print('🔴 Error during post-submission processing: $e');
        // If there's an error, still try to navigate if mounted
        if (mounted) {
          context.go('/pending-verification');
        }
      }
    } else {
      // Show error message if submission failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Failed to submit application. Please try again.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
} 