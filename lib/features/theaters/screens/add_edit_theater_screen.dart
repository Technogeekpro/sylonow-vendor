import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

import '../../../core/theme/app_theme.dart';
import '../models/theater_screen.dart';
import '../providers/theater_screens_provider.dart';
import '../service/theater_management_service.dart';
import '../service/theater_media_service.dart';

class AddEditTheaterScreen extends ConsumerStatefulWidget {
  final String theaterId;
  final TheaterScreen? existingScreen;

  const AddEditTheaterScreen({
    super.key,
    required this.theaterId,
    this.existingScreen,
  });

  @override
  ConsumerState<AddEditTheaterScreen> createState() => _AddEditTheaterScreenState();
}

class _AddEditTheaterScreenState extends ConsumerState<AddEditTheaterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  
  // Text Controllers
  late TextEditingController _nameController;
  late TextEditingController _screenNumberController;
  late TextEditingController _capacityController;
  late TextEditingController _totalCapacityController;
  late TextEditingController _allowedCapacityController;
  late TextEditingController _chargesExtraController;
  late TextEditingController _videoUrlController;
  late TextEditingController _originalPriceController;
  late TextEditingController _discountedPriceController;

  // State variables
  List<String> _selectedAmenities = [];
  List<String> _imageUrls = [];
  String? _uploadedVideoUrl;
  bool _isLoading = false;
  bool _isUploadingMedia = false;
  int _currentPage = 0;
  
  // Custom amenity controller
  late TextEditingController _customAmenityController;

  final List<String> _availableAmenities = [
    'Air Conditioning',
    'Comfortable Seating',
    'Projector',
    'Sound System',
    'Emergency Exit',
    'Wheelchair Access',
    'Premium Seats',
    'Snack Counter',
    'WiFi',
    'Parking',
    'Gaming Setup',
    'Karaoke System'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.existingScreen == null) {
      _loadNextAvailableScreenNumber();
    }
  }

  void _initializeControllers() {
    final screen = widget.existingScreen;
    _nameController = TextEditingController(text: screen?.screenName ?? '');
    _screenNumberController = TextEditingController(
      text: screen?.screenNumber.toString() ?? '',
    );
    _capacityController = TextEditingController(
      text: screen?.allowedCapacity.toString() ?? '',
    );
    _totalCapacityController = TextEditingController(
      text: screen?.totalCapacity.toString() ?? '',
    );
    _allowedCapacityController = TextEditingController(
      text: screen?.allowedCapacity.toString() ?? '',
    );
    _chargesExtraController = TextEditingController(
      text: screen?.chargesExtraPerPerson.toString() ?? '',
    );
    _videoUrlController = TextEditingController(text: screen?.videoUrl ?? '');
    _originalPriceController = TextEditingController(
      text: screen?.originalHourlyPrice.toString() ?? '',
    );
    _discountedPriceController = TextEditingController(
      text: screen?.discountedHourlyPrice.toString() ?? '',
    );
    _customAmenityController = TextEditingController();

    _selectedAmenities = List<String>.from(screen?.amenities ?? []);
    _imageUrls = List<String>.from(screen?.images ?? []);
    _uploadedVideoUrl = screen?.videoUrl;
  }

  Future<void> _loadNextAvailableScreenNumber() async {
    try {
      print('🔍 DEBUG: Loading next available screen number for theater ${widget.theaterId}');
      final service = ref.read(theaterManagementServiceProvider);
      final nextNumber = await service.getNextAvailableScreenNumber(widget.theaterId);
      print('🔍 DEBUG: Next available screen number: $nextNumber');
      
      if (mounted) {
        setState(() {
          _screenNumberController.text = nextNumber.toString();
        });
      }
    } catch (e) {
      print('🔴 ERROR: Failed to load next available screen number: $e');
      // Fallback to 1 if there's an error
      if (mounted) {
        setState(() {
          _screenNumberController.text = '1';
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _screenNumberController.dispose();
    _capacityController.dispose();
    _totalCapacityController.dispose();
    _allowedCapacityController.dispose();
    _chargesExtraController.dispose();
    _videoUrlController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    _customAmenityController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.existingScreen == null ? 'Add Screen' : 'Edit Screen',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveScreen,
            child: Text(
              widget.existingScreen == null ? 'Add' : 'Update',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Page indicator
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildPageIndicator(0, 'Basic Info'),
                  _buildPageIndicator(1, 'Capacity & Pricing'),
                  _buildPageIndicator(2, 'Media & Amenities'),
                ],
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildBasicInfoPage(),
                  _buildCapacityPricingPage(),
                  _buildMediaAmenitiesPage(),
                ],
              ),
            ),
            
            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton.icon(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const HeroIcon(HeroIcons.arrowLeft, size: 16),
                      label: const Text('Previous'),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  if (_currentPage < 2)
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_validateCurrentPage()) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: const HeroIcon(HeroIcons.arrowRight, size: 16),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _saveScreen,
                      icon: _isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const HeroIcon(HeroIcons.check, size: 16),
                      label: Text(widget.existingScreen == null ? 'Add Screen' : 'Update Screen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int page, String title) {
    final isActive = _currentPage == page;
    final isCompleted = _currentPage > page;
    
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted 
                  ? AppTheme.successColor 
                  : isActive 
                      ? AppTheme.primaryColor 
                      : AppTheme.borderColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const HeroIcon(HeroIcons.check, size: 16, color: Colors.white)
                  : Text(
                      '${page + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (page < 2)
            Container(
              height: 2,
              width: 20,
              color: isCompleted ? AppTheme.primaryColor : AppTheme.borderColor,
              margin: const EdgeInsets.only(left: 8),
            ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),
          
          // Screen Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Screen Name *',
              hintText: 'e.g., Screen 1, Premium Hall',
              prefixIcon: HeroIcon(HeroIcons.tv),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a screen name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Screen Number
          TextFormField(
            controller: _screenNumberController,
            decoration: InputDecoration(
              labelText: 'Screen Number *',
              hintText: '1, 2, 3...',
              prefixIcon: const HeroIcon(HeroIcons.hashtag),
              helperText: widget.existingScreen == null 
                ? 'Auto-suggested next available number'
                : null,
              suffixIcon: widget.existingScreen == null 
                ? IconButton(
                    icon: const HeroIcon(HeroIcons.arrowPath, size: 16),
                    onPressed: _loadNextAvailableScreenNumber,
                    tooltip: 'Refresh suggested number',
                  )
                : null,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a screen number';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            onChanged: (value) {
              // Clear any previous validation errors when user types
              setState(() {});
            },
          ),
          const SizedBox(height: 16),

          // Basic Capacity
          TextFormField(
            controller: _capacityController,
            decoration: const InputDecoration(
              labelText: 'Basic Capacity *',
              hintText: 'Number of seats',
              prefixIcon: HeroIcon(HeroIcons.users),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter capacity';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityPricingPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Capacity & Pricing',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),

          // Total Capacity
          TextFormField(
            controller: _totalCapacityController,
            decoration: const InputDecoration(
              labelText: 'Total Capacity',
              hintText: 'Maximum people allowed',
              prefixIcon: HeroIcon(HeroIcons.userGroup),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Allowed Capacity
          TextFormField(
            controller: _allowedCapacityController,
            decoration: const InputDecoration(
              labelText: 'Currently Allowed Capacity',
              hintText: 'Current allowed capacity',
              prefixIcon: HeroIcon(HeroIcons.checkCircle),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Extra Charges Per Person
          TextFormField(
            controller: _chargesExtraController,
            decoration: const InputDecoration(
              labelText: 'Extra Charges Per Person',
              hintText: 'Additional charges beyond base capacity',
              prefixIcon: HeroIcon(HeroIcons.currencyRupee),
              prefixText: '₹',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),

          const Text(
            'Pricing Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Original Hourly Price
          TextFormField(
            controller: _originalPriceController,
            decoration: const InputDecoration(
              labelText: 'Original Hourly Price',
              hintText: 'Original price per hour',
              prefixIcon: HeroIcon(HeroIcons.banknotes),
              prefixText: '₹',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Discounted Hourly Price
          TextFormField(
            controller: _discountedPriceController,
            decoration: const InputDecoration(
              labelText: 'Discounted Hourly Price',
              hintText: 'Discounted price (if applicable)',
              prefixIcon: HeroIcon(HeroIcons.tag),
              prefixText: '₹',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

        ],
      ),
    );
  }

  Widget _buildMediaAmenitiesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Media & Amenities',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),

          // Video Upload
          _buildVideoUploadSection(),
          const SizedBox(height: 24),

          // Images Section
          _buildImagesUploadSection(),
          
          const SizedBox(height: 24),

          // Amenities
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select available amenities for your theater screen',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          
          // Predefined Amenities
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableAmenities.map((amenity) {
              final isSelected = _selectedAmenities.contains(amenity);
              return FilterChip(
                label: Text(amenity),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedAmenities.add(amenity);
                    } else {
                      _selectedAmenities.remove(amenity);
                    }
                  });
                },
                selectedColor: AppTheme.primaryColor.withAlpha((255 * 0.1).round()),
                checkmarkColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
          
          // Custom Amenities Section
          if (_selectedAmenities.any((amenity) => !_availableAmenities.contains(amenity))) ...[
            const SizedBox(height: 16),
            const Text(
              'Custom Amenities',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedAmenities
                  .where((amenity) => !_availableAmenities.contains(amenity))
                  .map((amenity) => FilterChip(
                        label: Text(amenity),
                        selected: true,
                        onSelected: (selected) {
                          setState(() {
                            _selectedAmenities.remove(amenity);
                          });
                        },
                        selectedColor: AppTheme.successColor.withAlpha((255 * 0.1).round()),
                        checkmarkColor: AppTheme.successColor,
                        deleteIcon: const HeroIcon(HeroIcons.xMark, size: 16),
                        onDeleted: () {
                          setState(() {
                            _selectedAmenities.remove(amenity);
                          });
                        },
                      ))
                  .toList(),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Add Custom Amenity
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Custom Amenity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _customAmenityController,
                        decoration: const InputDecoration(
                          hintText: 'Enter custom amenity name',
                          prefixIcon: HeroIcon(HeroIcons.plus),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        textCapitalization: TextCapitalization.words,
                        onFieldSubmitted: (_) => _addCustomAmenity(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _addCustomAmenity,
                      icon: const HeroIcon(HeroIcons.plus, size: 16),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add specific amenities unique to your theater that aren\'t listed above',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _validateCurrentPage() {
    if (_currentPage == 0) {
      // Only validate fields on the first page
      return _nameController.text.trim().isNotEmpty &&
             _screenNumberController.text.trim().isNotEmpty;
    } else if (_currentPage == 1) {
      // All pricing fields are optional now, but you could add validation here if needed.
      return true;
    }
    return true;
  }

  void _addCustomAmenity() {
    final customAmenity = _customAmenityController.text.trim();
    
    if (customAmenity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amenity name'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    // Check if amenity already exists (case insensitive)
    final lowercaseAmenity = customAmenity.toLowerCase();
    final existsInPredefined = _availableAmenities
        .any((amenity) => amenity.toLowerCase() == lowercaseAmenity);
    final existsInSelected = _selectedAmenities
        .any((amenity) => amenity.toLowerCase() == lowercaseAmenity);
    
    if (existsInPredefined || existsInSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This amenity already exists'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }
    
    setState(() {
      _selectedAmenities.add(customAmenity);
      _customAmenityController.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$customAmenity" to amenities'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  Future<void> _saveScreen() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(theaterManagementServiceProvider);
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      // Check for duplicate screen numbers
      final screenNumberText = _screenNumberController.text.trim();
      if (screenNumberText.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Please enter a screen number.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final screenNumber = int.tryParse(screenNumberText);
      if (screenNumber == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid screen number.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      print('🔍 DEBUG: Checking screen number $screenNumber for theater ${widget.theaterId}');
      print('🔍 DEBUG: Existing screen ID: ${widget.existingScreen?.id}');
      
      final isExists = await service.isScreenNumberExists(
        widget.theaterId, 
        screenNumber,
        excludeScreenId: widget.existingScreen?.id,
      );
      
      print('🔍 DEBUG: Screen number exists: $isExists');
      
      if (isExists) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Screen number $screenNumber already exists for this theater. Please choose a different number.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (widget.existingScreen == null) {
        // Add new screen
        final newScreen = TheaterScreen(
          id: '', // Handled by backend
          theaterId: widget.theaterId,
          screenName: _nameController.text.trim(),
          screenNumber: int.parse(_screenNumberController.text),

          totalCapacity: int.tryParse(_totalCapacityController.text) ?? 0,
          allowedCapacity: int.tryParse(_allowedCapacityController.text) ?? 0,
          chargesExtraPerPerson: double.tryParse(_chargesExtraController.text) ?? 0.0,
          videoUrl: _uploadedVideoUrl,
          images: _imageUrls,
          originalHourlyPrice: double.tryParse(_originalPriceController.text) ?? 0.0,
          discountedHourlyPrice: double.tryParse(_discountedPriceController.text) ?? 0.0,
          amenities: _selectedAmenities,
          isActive: true,
        );
        await service.addTheaterScreen(newScreen);
      } else {
        // Update existing screen
        final updates = {
          'screen_name': _nameController.text.trim(),
          'screen_number': int.parse(_screenNumberController.text),

          'total_capacity': int.tryParse(_totalCapacityController.text) ?? 0,
          'allowed_capacity': int.tryParse(_allowedCapacityController.text) ?? 0,
          'charges_extra_per_person': double.tryParse(_chargesExtraController.text) ?? 0.0,
          'video_url': _uploadedVideoUrl,
          'images': _imageUrls,
          'original_hourly_price': double.tryParse(_originalPriceController.text) ?? 0.0,
          'discounted_hourly_price': double.tryParse(_discountedPriceController.text) ?? 0.0,
          'amenities': _selectedAmenities,
        };
        await service.updateTheaterScreen(widget.existingScreen!.id, updates);
      }

      // Refresh the screens list
      ref.invalidate(theaterScreensProvider(widget.theaterId));

      if (!mounted) return;

      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.existingScreen == null
                ? 'Screen added successfully'
                : 'Screen updated successfully',
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save screen: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildVideoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload a video to showcase your theater screen (max 2 minutes, 100MB)',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: _uploadedVideoUrl != null
              ? _buildVideoPreview()
              : _buildVideoUploadButton(),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: AppTheme.borderColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroIcon(
                  HeroIcons.playCircle,
                  size: 48,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(height: 8),
                Text(
                  'Video Uploaded',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Video successfully uploaded',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.successColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: _removeVideo,
              child: const Text(
                'Remove',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.errorColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoUploadButton() {
    return GestureDetector(
      onTap: _isUploadingMedia ? null : _uploadVideo,
      child: Column(
        children: [
          HeroIcon(
            HeroIcons.videoCamera,
            size: 48,
            color: _isUploadingMedia 
                ? AppTheme.textSecondaryColor
                : AppTheme.primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            _isUploadingMedia ? 'Uploading...' : 'Upload Video',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _isUploadingMedia 
                  ? AppTheme.textSecondaryColor
                  : AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap to select and upload a video file',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          if (_isUploadingMedia) ...[
            const SizedBox(height: 12),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagesUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload images to showcase your theater screen (max 6 images, 10MB each)',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildImagesGrid(),
      ],
    );
  }

  Widget _buildImagesGrid() {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: (_imageUrls.length < 6) ? _imageUrls.length + 1 : 6,
          itemBuilder: (context, index) {
            if (index < _imageUrls.length) {
              return _buildImageItem(_imageUrls[index], index);
            } else {
              return _buildAddImageButton();
            }
          },
        ),
        if (_isUploadingMedia)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Uploading images...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImageItem(String imageUrl, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppTheme.borderColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.borderColor,
                  child: const HeroIcon(
                    HeroIcons.photo,
                    color: AppTheme.textSecondaryColor,
                    size: 32,
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.errorColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const HeroIcon(
                HeroIcons.xMark,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _isUploadingMedia ? null : _uploadImages,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isUploadingMedia 
                ? AppTheme.borderColor.withOpacity(0.5)
                : AppTheme.borderColor,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              HeroIcons.plus,
              size: 32,
              color: _isUploadingMedia 
                  ? AppTheme.textSecondaryColor
                  : AppTheme.primaryColor,
            ),
            const SizedBox(height: 4),
            Text(
              'Add Image',
              style: TextStyle(
                fontSize: 10,
                color: _isUploadingMedia 
                    ? AppTheme.textSecondaryColor
                    : AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadVideo() async {
    if (_isUploadingMedia) return;

    setState(() {
      _isUploadingMedia = true;
    });

    try {
      final mediaService = ref.read(theaterMediaServiceProvider);
      final videoUrl = await mediaService.pickAndUploadVideo();
      
      if (videoUrl != null) {
        setState(() {
          _uploadedVideoUrl = videoUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload video: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingMedia = false;
        });
      }
    }
  }

  Future<void> _removeVideo() async {
    if (_uploadedVideoUrl != null) {
      try {
        final mediaService = ref.read(theaterMediaServiceProvider);
        await mediaService.deleteMediaFile(_uploadedVideoUrl!);
        setState(() {
          _uploadedVideoUrl = null;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove video: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _uploadImages() async {
    if (_isUploadingMedia) return;

    setState(() {
      _isUploadingMedia = true;
    });

    try {
      final mediaService = ref.read(theaterMediaServiceProvider);
      final newImages = await mediaService.pickAndUploadImages(
        maxImages: 6,
        existingImages: _imageUrls,
      );
      
      setState(() {
        _imageUrls = newImages;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload images: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingMedia = false;
        });
      }
    }
  }

  Future<void> _removeImage(int index) async {
    if (index >= 0 && index < _imageUrls.length) {
      try {
        final mediaService = ref.read(theaterMediaServiceProvider);
        final imageUrl = _imageUrls[index];
        await mediaService.deleteMediaFile(imageUrl);
        setState(() {
          _imageUrls.removeAt(index);
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove image: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }
}