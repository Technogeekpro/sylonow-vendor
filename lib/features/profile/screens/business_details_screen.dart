import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../onboarding/providers/vendor_provider.dart';

class BusinessDetailsScreen extends ConsumerStatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  ConsumerState<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends ConsumerState<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _serviceAreaController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _serviceTypeController = TextEditingController();
  
  bool _isLoading = false;
  bool _isInitialized = false;

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
      _businessNameController.text = vendor.businessName ?? '';
      _serviceAreaController.text = vendor.serviceArea ?? '';
      _pincodeController.text = vendor.pincode ?? '';
      _serviceTypeController.text = vendor.serviceType ?? '';
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _serviceAreaController.dispose();
    _pincodeController.dispose();
    _serviceTypeController.dispose();
    super.dispose();
  }

  Future<void> _updateBusinessDetails() async {
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
        businessName: _businessNameController.text.trim(),
        serviceArea: _serviceAreaController.text.trim(),
        pincode: _pincodeController.text.trim(),
        serviceType: _serviceTypeController.text.trim(),
      );

      // Use vendor service to update the business details
      final vendorService = ref.read(vendorServiceProvider);
      await vendorService.updateOrCreateVendor(updatedVendor);
      
      // Refresh the vendor data
      ref.invalidate(vendorProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business details updated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update business details: ${e.toString()}'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Business Information Section
                        _buildSectionHeader('Business Information'),
                        const SizedBox(height: 16),
                        _buildBusinessInformation(),
                        
                        const SizedBox(height: 32),
                        
                        // Service Details Section
                        _buildSectionHeader('Service Details'),
                        const SizedBox(height: 16),
                        _buildServiceDetails(),
                        
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
                'Failed to load business data',
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
              'Business Details',
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildBusinessInformation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          // Business Name
          TextFormField(
            controller: _businessNameController,
            decoration: const InputDecoration(
              labelText: 'Business Name',
              prefixIcon: Icon(Icons.business_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your business name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          
          // Service Area
          TextFormField(
            controller: _serviceAreaController,
            decoration: const InputDecoration(
              labelText: 'Service Area',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
              hintText: 'e.g., Mumbai, Delhi',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your service area';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          
          // Pincode
          TextFormField(
            controller: _pincodeController,
            decoration: const InputDecoration(
              labelText: 'Pincode',
              prefixIcon: Icon(Icons.pin_drop_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your pincode';
              }
              if (value.trim().length != 6) {
                return 'Please enter a valid 6-digit pincode';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          // Service Type
          TextFormField(
            controller: _serviceTypeController,
            decoration: const InputDecoration(
              labelText: 'Service Type',
              prefixIcon: Icon(Icons.work_outline),
              border: OutlineInputBorder(),
              hintText: 'e.g., Event Planning, Photography',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your service type';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateBusinessDetails,
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
                'Update Business Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
} 