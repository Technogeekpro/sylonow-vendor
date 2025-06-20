import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../core/theme/app_theme.dart';
import '../../../core/config/supabase_config.dart';
import '../../onboarding/providers/vendor_provider.dart';
import '../../onboarding/service/vendor_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isUploadingImage = false;
  File? _selectedProfileImage;
  String? _currentProfileImageUrl;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  void _initializeFields() {
    if (_isInitialized) return;
    
    final vendor = ref.read(vendorProvider).value;
    if (vendor != null) {
      _fullNameController.text = vendor.fullName ?? '';
      _phoneController.text = vendor.phone ?? '';
      _emailController.text = vendor.email ?? '';
      _currentProfileImageUrl = vendor.profilePicture;
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    
    // Clean up temporary profile image file if it exists
    if (_selectedProfileImage != null && _selectedProfileImage!.existsSync()) {
      try {
        _selectedProfileImage!.deleteSync();
        print('🧹 Cleaned up selected profile image on dispose');
      } catch (e) {
        print('⚠️ Failed to cleanup selected profile image on dispose: $e');
      }
    }
    
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final vendor = ref.read(vendorProvider).value;
      if (vendor == null) {
        throw Exception('Vendor data not available');
      }

      // Create updated vendor object
      final updatedVendor = vendor.copyWith(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );

      // Use vendor service to update the profile
      final vendorService = VendorService();
      await vendorService.updateOrCreateVendor(updatedVendor);
      
      // Refresh the vendor data
      ref.invalidate(vendorProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickAndUploadProfileImage() async {
    try {
      setState(() {
        _isUploadingImage = true;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) {
        setState(() {
          _isUploadingImage = false;
        });
        return;
      }

      // Copy file to a permanent location to prevent cleanup
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'profile_edit_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
      final String permanentPath = path.join(appDir.path, 'temp_images', fileName);
      
      // Create directory if it doesn't exist
      await Directory(path.dirname(permanentPath)).create(recursive: true);
      
      // Copy the file to permanent location
      final File permanentFile = await File(image.path).copy(permanentPath);
      
      print('📸 Profile image copied to permanent location: $permanentPath');

      // Get current vendor data
      final vendor = ref.read(vendorProvider).value;
      if (vendor == null) {
        throw Exception('Vendor data not available');
      }

      // Upload image to Supabase storage
      final vendorService = VendorService();
      final imageUrl = await vendorService.uploadImage(permanentFile, 'profile', vendor.id);
      
      print('🟢 Profile image uploaded successfully: $imageUrl');

      // Update vendor record with new profile image URL
      await SupabaseConfig.client.from('vendors').update({
        'profile_image_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', vendor.id);

      // Update local state
      setState(() {
        _selectedProfileImage = permanentFile;
        _currentProfileImageUrl = imageUrl;
        _isUploadingImage = false;
      });

      // Refresh vendor data to get updated profile
      ref.invalidate(vendorProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Profile picture updated successfully!'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Clean up temporary file after successful upload
      try {
        await permanentFile.delete();
        print('🧹 Cleaned up temp file: $permanentPath');
      } catch (e) {
        print('⚠️ Failed to cleanup temp file: $e');
      }

    } catch (e) {
      print('🔴 Profile image upload failed: $e');
      
      setState(() {
        _isUploadingImage = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Failed to update profile picture: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorAsync = ref.watch(vendorProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      body: vendorAsync.when(
        data: (vendor) {
          _initializeFields();
          return Column(
            children: [
              // Header
              _buildHeader(context),
              
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        
                        // Profile Picture Section
                        _buildProfilePictureSection(vendor),
                        
                        const SizedBox(height: 32),
                        
                        // Form Fields
                        _buildFormFields(),
                        
                        const SizedBox(height: 32),
                        
                        // Update Button
                        _buildUpdateButton(),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load profile data',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref.invalidate(vendorProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const Expanded(
            child: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection(vendor) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [AppTheme.cardShadow],
          ),
          child: ClipOval(
            child: _isUploadingImage
                ? _buildUploadingState()
                : _buildProfileImage(vendor),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: _isUploadingImage ? null : _pickAndUploadProfileImage,
          icon: _isUploadingImage 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryColor,
                  ),
                )
              : const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
          label: Text(
            _isUploadingImage ? 'Uploading...' : 'Change Photo',
            style: TextStyle(
              color: _isUploadingImage 
                  ? AppTheme.textSecondaryColor 
                  : AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadingState() {
    return Container(
      width: 120,
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            'Uploading...',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.primaryColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(vendor) {
    // Check if we have a selected image first (for immediate feedback)
    if (_selectedProfileImage != null) {
      return Image.file(
        _selectedProfileImage!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    }

    // Show current profile image from vendor data
    final imageUrl = _currentProfileImageUrl ?? vendor?.profilePicture;
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 120,
            height: 120,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppTheme.primaryColor,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('🔴 Edit profile image loading error: $error');
          print('🔴 Image URL: $imageUrl');
          return Container(
            width: 120,
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_rounded,
                  color: AppTheme.primaryColor,
                  size: 50,
                ),
                const SizedBox(height: 4),
                Text(
                  'Load Error',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.primaryColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // Default placeholder
    return Container(
      width: 120,
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_rounded,
            color: AppTheme.primaryColor,
            size: 50,
          ),
          const SizedBox(height: 4),
          Text(
            'No Photo',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.primaryColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Full Name
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        
        // Phone Number
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone_outlined),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.trim().length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        
        // Email
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email address';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Update Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
} 