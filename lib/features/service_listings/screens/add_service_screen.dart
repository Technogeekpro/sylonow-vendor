import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../controllers/add_service_controller.dart';
import '../widgets/basic_info_section.dart';
import '../widgets/media_upload_section.dart';
import '../widgets/pricing_section_new.dart';
import '../widgets/details_section.dart';
import '../widgets/area_section.dart';

class AddServiceScreen extends ConsumerStatefulWidget {
  const AddServiceScreen({super.key});

  @override
  ConsumerState<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends ConsumerState<AddServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 0;
  bool _isLoading = false;

  final List<String> _stepTitles = [
    'Basic Info',
    'Media Upload',
    'Pricing',
    'Details',
    'Area',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _setStatusBarColor();
  }

  void _setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addServiceControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Step Indicator
                _buildStepIndicator(),
                
                // Content
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      BasicInfoSection(controller: controller),
                      MediaUploadSection(controller: controller),
                      PricingSectionNew(controller: controller),
                      DetailsSection(controller: controller),
                      AreaSection(controller: controller),
                    ],
                  ),
                ),
                
                // Navigation Buttons
                _buildNavigationButtons(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      floating: true,
      pinned: false,
      snap: true,
      centerTitle: true,
      leading: IconButton(
        icon: HeroIcon(HeroIcons.arrowLeft, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
        onPressed: () => _showExitDialog(),
      ),
      title:  Text(
        'Add Service',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      actions: [
        IconButton(
          icon: HeroIcon(HeroIcons.questionMarkCircle, size: 20, color: Theme.of(context).primaryColor),
          onPressed: () => _showHelpDialog(),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step Progress Bar
          Row(
            children: List.generate(_stepTitles.length, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: isCompleted || isActive 
                              ? Theme.of(context).primaryColor 
                              : Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < _stepTitles.length - 1)
                      Container(
                        width: 6,
                        height: 3,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                  ],
                ),
              );
            }),
          ),
          
          const SizedBox(height: 12),
          
          // Step Title
          Text(
            _stepTitles[_currentStep],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'Step ${_currentStep + 1} of ${_stepTitles.length}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(AddServiceController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous Button
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 12),
          
          // Next/Submit Button
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _nextStep(controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
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
                  : Text(
                      _currentStep == _stepTitles.length - 1 ? 'Create Service' : 'Next',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _tabController.animateTo(_currentStep);
    }
  }

  void _nextStep(AddServiceController controller) async {
    if (_currentStep < _stepTitles.length - 1) {
      // Validate current step before proceeding
      if (_validateCurrentStep(controller)) {
        setState(() {
          _currentStep++;
        });
        _tabController.animateTo(_currentStep);
      }
    } else {
      // Submit form
      await _submitForm(controller);
    }
  }

  bool _validateCurrentStep(AddServiceController controller) {
    print('🔍 Validating step $_currentStep');
    
    switch (_currentStep) {
      case 0: // Basic Info
        final hasTitle = controller.titleController.text.isNotEmpty;
        final hasCategory = controller.selectedCategory != null;
        final hasServiceEnvironment = controller.selectedServiceEnvironments.isNotEmpty;
        
        print('📝 Title filled: $hasTitle ("${controller.titleController.text}")');
        print('📂 Category selected: $hasCategory (${controller.selectedCategory})');
        print('🏠 Service environment: $hasServiceEnvironment (${controller.selectedServiceEnvironments})');
        
        final isValid = hasTitle && hasCategory && hasServiceEnvironment;
        print('✅ Step 0 valid: $isValid');
        return isValid;
        
      case 1: // Media Upload
        print('✅ Step 1 (Media) valid: true (optional)');
        return true; // Optional
        
      case 2: // Pricing
        final hasOriginalPrice = controller.originalPriceController.text.isNotEmpty;
        final hasOfferPrice = controller.offerPriceController.text.isNotEmpty;
        final validPricing = _validatePricing(controller);
        
        print('💰 Original price filled: $hasOriginalPrice ("${controller.originalPriceController.text}")');
        print('💸 Offer price filled: $hasOfferPrice ("${controller.offerPriceController.text}")');
        print('💵 Pricing valid: $validPricing');
        
        final isValid = hasOriginalPrice && hasOfferPrice && validPricing;
        print('✅ Step 2 valid: $isValid');
        return isValid;
        
      case 3: // Details
        final hasSetupTime = controller.selectedSetupTime != null;
        final hasBookingNotice = controller.selectedBookingNotice != null;
        final hasInclusions = controller.inclusions.isNotEmpty;
        
        print('⏰ Setup time selected: $hasSetupTime (${controller.selectedSetupTime})');
        print('📅 Booking notice selected: $hasBookingNotice (${controller.selectedBookingNotice})');
        print('📋 Inclusions added: $hasInclusions (${controller.inclusions.length} inclusions: ${controller.inclusions})');
        
        final isValid = hasSetupTime && hasBookingNotice && hasInclusions;
        print('✅ Step 3 valid: $isValid');
        return isValid;
        
      case 4: // Area
        final hasPincodes = controller.pincodes.isNotEmpty;
        
        print('📍 Pincodes added: $hasPincodes (${controller.pincodes.length} pincodes: ${controller.pincodes})');
        
        final isValid = hasPincodes;
        print('✅ Step 4 valid: $isValid');
        return isValid;
        
      default:
        print('✅ Default step valid: true');
        return true;
    }
  }

  bool _validatePricing(AddServiceController controller) {
    final originalPrice = double.tryParse(controller.originalPriceController.text);
    final offerPrice = double.tryParse(controller.offerPriceController.text);
    
    if (originalPrice == null || offerPrice == null) return false;
    return offerPrice <= originalPrice;
  }

  Future<void> _submitForm(AddServiceController controller) async {
    print('🚀 Starting form submission...');
    print('🔍 ===== ADVANCED DEBUGGING MODE =====');
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Step 1: Check form validity with detailed debugging
      print('📋 Step 1: Checking form validity...');
      final isFormValid = controller.isFormValid;
      
      if (!isFormValid) {
        print('❌ Step 1 FAILED: Form validation failed');
        print('🔍 Running additional diagnostic...');
        
        // Additional diagnostic: Check each requirement individually
        final diagnostics = {
          'title_filled': controller.titleController.text.isNotEmpty,
          'title_valid': controller.validateTitle(controller.titleController.text) == null,
          'category_selected': controller.selectedCategory != null,
          'service_env_selected': controller.selectedServiceEnvironments.isNotEmpty,
          'original_price_filled': controller.originalPriceController.text.isNotEmpty,
          'original_price_valid': controller.validatePrice(controller.originalPriceController.text) == null,
          'offer_price_filled': controller.offerPriceController.text.isNotEmpty,
          'offer_price_valid': controller.validateOfferPrice(controller.offerPriceController.text) == null,
          'setup_time_selected': controller.selectedSetupTime != null,
          'booking_notice_selected': controller.selectedBookingNotice != null,
          'pincodes_added': controller.pincodes.isNotEmpty,
          'inclusions_added': controller.inclusions.isNotEmpty,
          'form_state_valid': controller.formKey.currentState?.validate() == true,
        };
        
        print('\n🔬 DETAILED DIAGNOSTICS:');
        diagnostics.forEach((key, value) {
          final status = value ? '✅' : '❌';
          print('$status $key: $value');
        });
        
        final failedChecks = diagnostics.entries.where((e) => !e.value).map((e) => e.key).toList();
        print('\n❌ FAILED CHECKS: ${failedChecks.join(', ')}');
        
        _showErrorDialog('Form validation failed. Issues found: ${failedChecks.join(', ')}');
        return;
      }
      
      print('✅ Step 1 PASSED: Form validation successful');
      
      // Step 2: Create listing
      print('📋 Step 2: Creating listing...');
      final success = await controller.createListing();
      
      if (success) {
        print('✅ Step 2 PASSED: Listing created successfully');
        _showSuccessDialog();
      } else {
        print('❌ Step 2 FAILED: Listing creation failed');
        _showErrorDialog('Failed to create service listing.');
      }
      
    } catch (e, stackTrace) {
      print('🔴 EXCEPTION in form submission:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      _showErrorDialog('An error occurred: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
      print('🏁 Form submission process completed');
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Exit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          'Are you sure you want to exit? All unsaved changes will be lost.',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: Text(
              'Exit',
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Help',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Follow these steps to create your service listing:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '1. Basic Info: Add title, category, and theme tags',
                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              SizedBox(height: 4),
              Text(
                '2. Media Upload: Add photos and videos (optional)',
                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              SizedBox(height: 4),
              Text(
                '3. Pricing: Set original and offer prices',
                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              SizedBox(height: 4),
              Text(
                '4. Details: Add inclusions, setup time, etc.',
                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              SizedBox(height: 4),
              Text(
                '5. Area: Specify service pincodes and venues',
                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const HeroIcon(
                HeroIcons.check,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Service Created!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your service listing has been created successfully and is now live.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushReplacement('/service-listings');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View Listings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Error',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 