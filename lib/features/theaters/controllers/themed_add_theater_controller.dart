import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/private_theater.dart';
import '../models/theater_theme.dart';
import '../providers/theater_provider.dart';
import '../service/theater_service.dart';
import '../../onboarding/providers/vendor_provider.dart';

final themedAddTheaterControllerProvider = ChangeNotifierProvider((ref) {
  return ThemedAddTheaterController(ref);
});

class ThemedAddTheaterController extends ChangeNotifier {
  final Ref _ref;
  final TheaterService _theaterService;

  ThemedAddTheaterController(this._ref) : _theaterService = _ref.read(theaterServiceProvider);

  // Form Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final capacityController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final extraChargesController = TextEditingController();

  // Form Keys
  final basicInfoFormKey = GlobalKey<FormState>();
  final pricingFormKey = GlobalKey<FormState>();

  // State Variables
  bool _isLoading = false;
  TheaterTheme? _selectedTheme;
  List<String> _theaterImages = [];
  String? _theaterVideoUrl;
  bool _isVideoLoading = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isVideoLoading => _isVideoLoading;
  TheaterTheme? get selectedTheme => _selectedTheme;
  List<String> get theaterImages => _theaterImages;
  String? get theaterVideoUrl => _theaterVideoUrl;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    capacityController.dispose();
    hourlyRateController.dispose();
    extraChargesController.dispose();
    super.dispose();
  }

  // Theme Management
  void selectTheme(TheaterTheme theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  // Image Management
  void updateImages(List<String> images) {
    _theaterImages = images;
    notifyListeners();
  }

  void addImage(String imageUrl) {
    _theaterImages.add(imageUrl);
    notifyListeners();
  }

  void removeImage(String imageUrl) {
    _theaterImages.remove(imageUrl);
    notifyListeners();
  }

  // Video Management
  void setVideoUrl(String? videoUrl) {
    _theaterVideoUrl = videoUrl;
    notifyListeners();
  }

  void removeVideo() {
    _theaterVideoUrl = null;
    notifyListeners();
  }

  // Pick and upload images
  Future<void> pickAndUploadImages() async {
    try {
      _isLoading = true;
      notifyListeners();

      final newImages = await _theaterService.pickAndUploadTheaterImages(
        maxImages: 10,
        existingImages: _theaterImages,
      );

      _theaterImages = newImages;
      notifyListeners();
    } catch (e) {
      print('Error picking images: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pick and upload video
  Future<void> pickAndUploadVideo() async {
    try {
      _isVideoLoading = true;
      notifyListeners();

      final videoUrl = await _theaterService.pickAndUploadTheaterVideo();
      
      if (videoUrl != null) {
        _theaterVideoUrl = videoUrl;
        notifyListeners();
      }
    } catch (e) {
      print('Error picking video: $e');
      rethrow;
    } finally {
      _isVideoLoading = false;
      notifyListeners();
    }
  }

  // Validation methods
  bool validateBasicInfo() {
    if (basicInfoFormKey.currentState?.validate() != true) {
      return false;
    }
    
    if (nameController.text.trim().isEmpty) {
      return false;
    }
    
    if (capacityController.text.trim().isEmpty || 
        int.tryParse(capacityController.text) == null ||
        int.parse(capacityController.text) <= 0) {
      return false;
    }
    
    return true;
  }

  bool validatePricing() {
    if (pricingFormKey.currentState?.validate() != true) {
      return false;
    }
    
    if (hourlyRateController.text.trim().isEmpty || 
        double.tryParse(hourlyRateController.text) == null ||
        double.parse(hourlyRateController.text) <= 0) {
      return false;
    }
    
    // Validate extra charges if provided
    if (extraChargesController.text.trim().isNotEmpty) {
      final extraCharges = double.tryParse(extraChargesController.text);
      if (extraCharges == null || extraCharges < 0) {
        return false;
      }
    }
    
    return true;
  }

  bool validateTheme() {
    return _selectedTheme != null;
  }

  bool validateAll() {
    return validateBasicInfo() && validatePricing() && validateTheme();
  }

  // Create theater
  Future<void> createTheater() async {
    if (!validateAll()) {
      throw Exception('Validation failed');
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Auto-retrieve location data from vendor profile
      final vendorAsync = _ref.read(vendorProvider);
      Map<String, dynamic>? vendorLocation;
      
      if (vendorAsync.hasValue && vendorAsync.value?.location != null) {
        vendorLocation = vendorAsync.value!.location;
      }

      // Extract location data from vendor profile
      final String address = vendorLocation?['address']?.toString() ?? 'Theater Address';
      final String city = vendorLocation?['city']?.toString() ?? 'City';
      final String state = vendorLocation?['state']?.toString() ?? 'State';
      final String pinCode = vendorLocation?['pinCode']?.toString() ?? '000000';
      final double? latitude = vendorLocation?['latitude']?.toDouble();
      final double? longitude = vendorLocation?['longitude']?.toDouble();

      // Parse extra charges (default to 0 if empty)
      final double extraCharges = extraChargesController.text.trim().isNotEmpty 
        ? double.parse(extraChargesController.text.trim()) 
        : 0.0;

      final theater = PrivateTheater(
        id: '', // Will be generated by database
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty 
            ? null 
            : descriptionController.text.trim(),
        address: address,
        city: city,
        state: state,
        pinCode: pinCode,
        latitude: latitude,
        longitude: longitude,
        capacity: int.parse(capacityController.text.trim()),
        amenities: [], // Will be added later if needed
        images: _theaterImages,
        videoUrl: _theaterVideoUrl,
        hourlyRate: double.parse(hourlyRateController.text.trim()),
        bookingDurationHours: 2, // Default
        advanceBookingDays: 30, // Default
        cancellationPolicy: 'Free cancellation up to 24 hours before the booking',
        // New themed fields
        themeName: _selectedTheme?.name,
        themePrimaryColor: _selectedTheme?.primaryColor,
        themeSecondaryColor: _selectedTheme?.secondaryColor,
        themeBackgroundImage: _selectedTheme?.backgroundImageUrl,
        extraChargesPerPerson: extraCharges,
      );

      await _ref.read(theatersProvider.notifier).createTheater(theater);
      
      // Reset form after successful creation
      _resetForm();
    } catch (e) {
      print('Error creating theater: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset form
  void _resetForm() {
    nameController.clear();
    descriptionController.clear();
    capacityController.clear();
    hourlyRateController.clear();
    extraChargesController.clear();

    _selectedTheme = null;
    _theaterImages.clear();
    _theaterVideoUrl = null;
    
    notifyListeners();
  }

  // Initialize with default values
  void initializeDefaults() {
    capacityController.text = '50';
    notifyListeners();
  }
}