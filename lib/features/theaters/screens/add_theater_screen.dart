import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_theater_controller.dart';
import '../widgets/theater_basic_info_section.dart';
import '../widgets/theater_amenities_section.dart';
import '../widgets/theater_images_section.dart';
import '../widgets/theater_settings_section.dart';
import '../widgets/theater_screens_section.dart';

class AddTheaterScreen extends ConsumerStatefulWidget {
  const AddTheaterScreen({super.key});

  @override
  ConsumerState<AddTheaterScreen> createState() => _AddTheaterScreenState();
}

class _AddTheaterScreenState extends ConsumerState<AddTheaterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Basic Info',
      'subtitle': 'Theater name & details',
      'icon': HeroIcons.buildingOffice2,
    },
    {
      'title': 'Amenities',
      'subtitle': 'Available facilities',
      'icon': HeroIcons.sparkles,
    },
    {
      'title': 'Images',
      'subtitle': 'Theater photos',
      'icon': HeroIcons.camera,
    },
    {
      'title': 'Settings',
      'subtitle': 'Pricing & policies',
      'icon': HeroIcons.cog6Tooth,
    },
    {
      'title': 'Screens',
      'subtitle': 'Manage screens',
      'icon': HeroIcons.tv,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _steps.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addTheaterControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Header
          _buildModernHeader(),
          
          // Step Progress
          _buildModernStepProgress(),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TheaterBasicInfoSection(controller: controller),
                TheaterAmenitiesSection(controller: controller),
                TheaterImagesSection(controller: controller),
                TheaterSettingsSection(controller: controller),
                const TheaterScreensSection(),
              ],
            ),
          ),
          
          // Navigation
          _buildModernNavigation(controller),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20, 
        MediaQuery.of(context).padding.top + 16, 
        20, 
        20
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderColor,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(12),
                child: const HeroIcon(
                  HeroIcons.arrowLeft,
                  size: 20,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Theater',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimaryColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Create your theater listing',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                    height: 1.2,
                  ),
                ),
              ], 
            ),
          ),
          
          // Step Counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_currentStep + 1}/${_steps.length}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStepProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          // Current Step Info
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: HeroIcon(
                  _steps[_currentStep]['icon'],
                  size: 24,
                  color: AppTheme.primaryColor,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _steps[_currentStep]['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _steps[_currentStep]['subtitle'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Progress Bar
          Row(
            children: List.generate(_steps.length, (index) {
              final isActive = index <= _currentStep;
              
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < _steps.length - 1 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? AppTheme.primaryColor 
                        : AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildModernNavigation(AddTheaterController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20, 
        16, 
        20, 
        MediaQuery.of(context).padding.bottom + 16
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous Button
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _previousStep,
                icon: const HeroIcon(
                  HeroIcons.chevronLeft,
                  size: 18,
                ),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textSecondaryColor,
                  side: const BorderSide(
                    color: AppTheme.borderColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          // Next/Submit Button
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : () async {
                if (_currentStep == _steps.length - 1) {
                  await _submitTheater(controller);
                } else {
                  _nextStep(controller);
                }
              },
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : HeroIcon(
                      _currentStep == _steps.length - 1 
                          ? HeroIcons.check
                          : HeroIcons.chevronRight,
                      size: 18,
                      color: Colors.white,
                    ),
              label: Text(
                _currentStep == _steps.length - 1 
                    ? 'Create Theater' 
                    : 'Next',
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep(AddTheaterController controller) {
    if (_validateCurrentStep(controller)) {
      setState(() {
        _currentStep++;
        _tabController.animateTo(_currentStep);
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
      _tabController.animateTo(_currentStep);
    });
  }

  bool _validateCurrentStep(AddTheaterController controller) {
    switch (_currentStep) {
      case 0: // Basic Info
        return controller.validateBasicInfo();
      case 1: // Amenities
        return true; // Amenities are optional
      case 2: // Images
        return true; // Images are optional
      case 3: // Settings
        return controller.validateSettings();
      case 4: // Screens & Time Slots
        return controller.validateScreensAndTimeSlots();
      default:
        return false;
    }
  }

  Future<void> _submitTheater(AddTheaterController controller) async {
    print('🔍 DEBUG: _submitTheater() called - Create Theater button pressed');
    
    final isValid = controller.validateAll();
    print('🔍 DEBUG: Validation result in _submitTheater: $isValid');
    
    if (!isValid) {
      print('🔴 DEBUG: Validation failed, showing error');
      _showErrorSnackBar('Please fill in all required fields');
      return;
    }

    print('🔍 DEBUG: Validation passed, proceeding to create theater');
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔍 DEBUG: Calling controller.createTheater()');
      await controller.createTheater();
      
      if (mounted) {
        print('🟢 DEBUG: Theater created successfully!');
        _showSuccessSnackBar('Theater created successfully!');
        context.pop(); // Go back to home screen
      }
    } catch (e) {
      print('🔴 DEBUG: Error creating theater: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to create theater: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const HeroIcon(
              HeroIcons.exclamationTriangle,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const HeroIcon(
              HeroIcons.checkCircle,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}