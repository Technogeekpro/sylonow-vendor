import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_listing.dart';
import '../models/add_on.dart';
import '../providers/service_listing_provider.dart';
import '../service/service_listing_service.dart';
import '../../onboarding/providers/vendor_provider.dart';

final addServiceControllerProvider = Provider<AddServiceController>((ref) {
  return AddServiceController(ref);
});

class AddServiceController {
  final Ref _ref;
  
  AddServiceController(this._ref);

  ServiceListingService get _service => _ref.read(serviceListingServiceProvider);

  // Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final originalPriceController = TextEditingController();
  final offerPriceController = TextEditingController();
  final promotionalTagController = TextEditingController();
  final customizationNoteController = TextEditingController();
  final pincodeController = TextEditingController();
  final addOnNameController = TextEditingController();
  final addOnPriceController = TextEditingController();
  final inclusionController = TextEditingController();

  // Form Keys
  final formKey = GlobalKey<FormState>();

  // Selection Controllers
  String? selectedCategory;
  String? selectedSetupTime;
  String? selectedBookingNotice;
  List<String> selectedThemeTags = [];
  List<String> selectedServiceEnvironments = [];
  List<String> selectedVenueTypes = [];
  List<String> pincodes = [];
  List<String> inclusions = [];
  List<AddOn> addOns = [];
  bool customizationAvailable = false;

  // Media Controllers
  List<String> photos = [];
  String? coverPhoto;
  String? videoUrl;
  bool isUploadingMedia = false;

  // Get options from service
  List<String> get categories => _service.getCategories();
  List<String> get themeTags => _service.getThemeTags();
  List<String> get serviceEnvironments => _service.getServiceEnvironments();
  List<String> get setupTimeOptions => _service.getSetupTimeOptions();
  List<String> get bookingNoticeOptions => _service.getBookingNoticeOptions();
  List<String> get venueTypes => _service.getVenueTypes();

  // Validation
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    if (value.length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Enter a valid price';
    }
    return null;
  }

  String? validateOfferPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Offer price is required';
    }
    final offerPrice = double.tryParse(value);
    final originalPrice = double.tryParse(originalPriceController.text);
    
    if (offerPrice == null || offerPrice <= 0) {
      return 'Enter a valid offer price';
    }
    if (originalPrice != null && offerPrice > originalPrice) {
      return 'Offer price cannot be greater than original price';
    }
    return null;
  }

  String? validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }
    if (value.length != 6) {
      return 'Pincode must be 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Pincode must contain only digits';
    }
    return null;
  }

  // Theme tag management
  void toggleThemeTag(String tag) {
    if (selectedThemeTags.contains(tag)) {
      selectedThemeTags.remove(tag);
    } else {
      selectedThemeTags.add(tag);
    }
  }

  // Service environment management
  void toggleServiceEnvironment(String environment) {
    if (selectedServiceEnvironments.contains(environment)) {
      selectedServiceEnvironments.remove(environment);
    } else {
      selectedServiceEnvironments.add(environment);
    }
  }

  // Venue type management
  void toggleVenueType(String venueType) {
    if (selectedVenueTypes.contains(venueType)) {
      selectedVenueTypes.remove(venueType);
    } else {
      selectedVenueTypes.add(venueType);
    }
  }

  // Pincode management
  void addPincode() {
    final pincode = pincodeController.text.trim();
    if (pincode.isNotEmpty && !pincodes.contains(pincode)) {
      if (pincodes.length < 20) {
        pincodes.add(pincode);
        pincodeController.clear();
      }
    }
  }

  void removePincode(String pincode) {
    pincodes.remove(pincode);
  }

  // Inclusion management
  void addInclusion() {
    final inclusion = inclusionController.text.trim();
    if (inclusion.isNotEmpty && !inclusions.contains(inclusion)) {
      inclusions.add(inclusion);
      inclusionController.clear();
    }
  }

  void removeInclusion(String inclusion) {
    inclusions.remove(inclusion);
  }

  // Add-on management
  void addAddOn() {
    final name = addOnNameController.text.trim();
    final priceText = addOnPriceController.text.trim();
    
    if (name.isNotEmpty && priceText.isNotEmpty) {
      final price = double.tryParse(priceText);
      if (price != null && price >= 0) {
        addOns.add(AddOn(
          name: name,
          price: price,
          isFree: price == 0,
        ));
        addOnNameController.clear();
        addOnPriceController.clear();
      }
    }
  }

  void removeAddOn(int index) {
    if (index >= 0 && index < addOns.length) {
      addOns.removeAt(index);
    }
  }

  // Media management
  Future<void> uploadImages() async {
    try {
      isUploadingMedia = true;
      final newPhotos = await _service.pickAndUploadImages(
        maxImages: 6,
        existingImages: photos,
      );
      photos = newPhotos;
      if (coverPhoto == null && photos.isNotEmpty) {
        coverPhoto = photos.first;
      }
    } catch (e) {
      print('🔴 AddServiceController: Error uploading images: $e');
      rethrow;
    } finally {
      isUploadingMedia = false;
    }
  }

  Future<void> uploadVideo() async {
    try {
      isUploadingMedia = true;
      final newVideoUrl = await _service.pickAndUploadVideo();
      if (newVideoUrl != null) {
        videoUrl = newVideoUrl;
      }
    } catch (e) {
      print('🔴 AddServiceController: Error uploading video: $e');
      rethrow;
    } finally {
      isUploadingMedia = false;
    }
  }

  void setCoverPhoto(String photoUrl) {
    coverPhoto = photoUrl;
    if (!photos.contains(photoUrl)) {
      photos.insert(0, photoUrl);
    } else {
      // Move to first position
      photos.remove(photoUrl);
      photos.insert(0, photoUrl);
    }
  }

  Future<void> removePhoto(String photoUrl) async {
    try {
      await _service.deleteMediaFile(photoUrl);
      photos.remove(photoUrl);
      if (coverPhoto == photoUrl) {
        coverPhoto = photos.isNotEmpty ? photos.first : null;
      }
    } catch (e) {
      print('🔴 AddServiceController: Error removing photo: $e');
      rethrow;
    }
  }

  Future<void> removeVideo() async {
    try {
      if (videoUrl != null) {
        await _service.deleteMediaFile(videoUrl!);
        videoUrl = null;
      }
    } catch (e) {
      print('🔴 AddServiceController: Error removing video: $e');
      rethrow;
    }
  }

  // Advanced validation debugging
  Map<String, dynamic> validateAllFields() {
    final validationReport = <String, dynamic>{};
    
    // Check each TextFormField individually
    try {
      // Title validation
      final titleError = validateTitle(titleController.text);
      validationReport['title'] = {
        'value': titleController.text,
        'error': titleError,
        'isValid': titleError == null,
        'controller': titleController.runtimeType.toString(),
      };
      
      // Price validations
      final originalPriceError = validatePrice(originalPriceController.text);
      validationReport['originalPrice'] = {
        'value': originalPriceController.text,
        'error': originalPriceError,
        'isValid': originalPriceError == null,
        'controller': originalPriceController.runtimeType.toString(),
      };
      
      final offerPriceError = validateOfferPrice(offerPriceController.text);
      validationReport['offerPrice'] = {
        'value': offerPriceController.text,
        'error': offerPriceError,
        'isValid': offerPriceError == null,
        'controller': offerPriceController.runtimeType.toString(),
      };
      
      // Category validation (dropdown)
      validationReport['category'] = {
        'value': selectedCategory,
        'isValid': selectedCategory != null && selectedCategory!.isNotEmpty,
        'availableOptions': categories.length,
      };
      
      // Service environment validation
      validationReport['serviceEnvironment'] = {
        'value': selectedServiceEnvironments,
        'count': selectedServiceEnvironments.length,
        'isValid': selectedServiceEnvironments.isNotEmpty,
      };
      
      // Setup time validation
      validationReport['setupTime'] = {
        'value': selectedSetupTime,
        'isValid': selectedSetupTime != null && selectedSetupTime!.isNotEmpty,
        'availableOptions': setupTimeOptions.length,
      };
      
      // Booking notice validation
      validationReport['bookingNotice'] = {
        'value': selectedBookingNotice,
        'isValid': selectedBookingNotice != null && selectedBookingNotice!.isNotEmpty,
        'availableOptions': bookingNoticeOptions.length,
      };
      
      // Pincodes validation
      validationReport['pincodes'] = {
        'value': pincodes,
        'count': pincodes.length,
        'isValid': pincodes.isNotEmpty,
      };
      
      // Inclusions validation
      validationReport['inclusions'] = {
        'value': inclusions,
        'count': inclusions.length,
        'isValid': inclusions.isNotEmpty,
      };
      
      // Form state validation
      validationReport['formState'] = {
        'formKeyExists': formKey.currentState != null,
        'formValidation': formKey.currentState?.validate(),
      };
      
    } catch (e, stackTrace) {
      validationReport['error'] = {
        'message': e.toString(),
        'stackTrace': stackTrace.toString(),
      };
    }
    
    return validationReport;
  }
  
  void printValidationReport() {
    final report = validateAllFields();
    
    print('\n🔍 ===== ADVANCED VALIDATION REPORT =====');
    
    // Print each field's validation status
    report.forEach((fieldName, fieldData) {
      if (fieldName == 'error') {
        print('❌ VALIDATION ERROR: ${fieldData['message']}');
        return;
      }
      
      final isValid = fieldData['isValid'] ?? false;
      final status = isValid ? '✅' : '❌';
      
      print('$status $fieldName:');
      if (fieldData['value'] != null) {
        print('   Value: ${fieldData['value']}');
      }
      if (fieldData['error'] != null) {
        print('   Error: ${fieldData['error']}');
      }
      if (fieldData['count'] != null) {
        print('   Count: ${fieldData['count']}');
      }
      if (fieldData['availableOptions'] != null) {
        print('   Available Options: ${fieldData['availableOptions']}');
      }
      print('   Valid: $isValid');
      print('');
    });
    
    // Calculate overall validity
    final failedFields = <String>[];
    report.forEach((fieldName, fieldData) {
      if (fieldName != 'error' && fieldName != 'formState') {
        final isValid = fieldData['isValid'] ?? false;
        if (!isValid) {
          failedFields.add(fieldName);
        }
      }
    });
    
    print('📊 SUMMARY:');
    print('   Total fields checked: ${report.length - 1}'); // -1 for formState
    print('   Failed fields: ${failedFields.length}');
    if (failedFields.isNotEmpty) {
      print('   Failed field names: ${failedFields.join(', ')}');
    }
    print('   Form state valid: ${report['formState']?['formValidation'] ?? false}');
    print('   Overall valid: ${failedFields.isEmpty && (report['formState']?['formValidation'] ?? false)}');
    print('========================================\n');
  }

  // Form validation with fallback
  bool get isFormValid {
    // Generate detailed validation report
    printValidationReport();
    
    // Inspect form fields in detail
    inspectFormFields();
    
    // Check each field validation individually
    final titleValidation = validateTitle(titleController.text);
    final originalPriceValidation = validatePrice(originalPriceController.text);
    final offerPriceValidation = validateOfferPrice(offerPriceController.text);
    
    // Try form validation, but use fallback if form state is not available
    bool mainFormValidation = false;
    try {
      final formState = formKey.currentState;
      if (formState != null && formState.mounted) {
        mainFormValidation = formState.validate();
        print('🟢 Form state validation successful: $mainFormValidation');
      } else {
        print('⚠️ Form state not available, using manual validation');
        // Manual validation fallback for form fields
        mainFormValidation = titleValidation == null && selectedCategory != null;
        print('🔧 Manual form validation result: $mainFormValidation');
      }
    } catch (e) {
      print('❌ Form validation error: $e');
      // Fallback to manual validation
      mainFormValidation = titleValidation == null && selectedCategory != null;
      print('🔧 Fallback validation result: $mainFormValidation');
    }
    
    // Check all required conditions through logic instead of form validation
    final hasCategory = selectedCategory != null;
    final hasServiceEnvironment = selectedServiceEnvironments.isNotEmpty;
    final hasSetupTime = selectedSetupTime != null;
    final hasBookingNotice = selectedBookingNotice != null;
    final hasPincodes = pincodes.isNotEmpty;
    final hasInclusions = inclusions.isNotEmpty;
    final hasValidPricing = originalPriceValidation == null && offerPriceValidation == null;
    
    final isValid = mainFormValidation &&
           hasValidPricing &&
           hasCategory &&
           hasServiceEnvironment &&
           hasSetupTime &&
           hasBookingNotice &&
           hasPincodes &&
           hasInclusions;
           
    print('🎯 Final validation result: $isValid');
    return isValid;
  }

  // Create listing
  Future<bool> createListing() async {
    try {
      if (!isFormValid) {
        return false;
      }

      // Get vendor ID
      final vendor = await _ref.read(vendorProvider.future);
      if (vendor?.vendorId == null) {
        throw Exception('Vendor not found');
      }

      // Create listing object
      final listing = ServiceListing(
        id: '', // Will be generated by database
        listingId: '', // Will be generated by database
        vendorId: vendor!.vendorId!,
        title: titleController.text.trim(),
        category: selectedCategory!,
        themeTags: selectedThemeTags,
        serviceEnvironment: selectedServiceEnvironments,
        coverPhoto: coverPhoto,
        photos: photos,
        videoUrl: videoUrl?.isNotEmpty == true ? videoUrl : null,
        originalPrice: double.parse(originalPriceController.text),
        offerPrice: double.parse(offerPriceController.text),
        addOns: addOns,
        promotionalTag: promotionalTagController.text.isNotEmpty 
            ? promotionalTagController.text.trim() 
            : null,
        description: descriptionController.text.isNotEmpty 
            ? descriptionController.text.trim() 
            : null,
        inclusions: inclusions,
        customizationAvailable: customizationAvailable,
        customizationNote: customizationAvailable && customizationNoteController.text.isNotEmpty
            ? customizationNoteController.text.trim()
            : null,
        setupTime: selectedSetupTime!,
        bookingNotice: selectedBookingNotice!,
        pincodes: pincodes,
        venueTypes: selectedVenueTypes,
      );

      // Create listing through provider
      await _ref.read(serviceListingsProvider.notifier).createListing(listing);
      
      return true;
    } catch (e) {
      print('🔴 AddServiceController: Error creating listing: $e');
      return false;
    }
  }

  // Reset form
  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    originalPriceController.clear();
    offerPriceController.clear();
    promotionalTagController.clear();
    customizationNoteController.clear();
    pincodeController.clear();
    addOnNameController.clear();
    addOnPriceController.clear();
    inclusionController.clear();
    
    selectedCategory = null;
    selectedSetupTime = null;
    selectedBookingNotice = null;
    selectedThemeTags.clear();
    selectedServiceEnvironments.clear();
    selectedVenueTypes.clear();
    pincodes.clear();
    inclusions.clear();
    addOns.clear();
    photos.clear();
    coverPhoto = null;
    videoUrl = null;
    customizationAvailable = false;
    isUploadingMedia = false;
  }

  // Dispose controllers
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    originalPriceController.dispose();
    offerPriceController.dispose();
    promotionalTagController.dispose();
    customizationNoteController.dispose();
    pincodeController.dispose();
    addOnNameController.dispose();
    addOnPriceController.dispose();
    inclusionController.dispose();
  }

  // Form field inspector for debugging
  void inspectFormFields() {
    print('\n🔬 ===== FORM FIELD INSPECTOR =====');
    
    // Check if form key is properly attached
    final formState = formKey.currentState;
    print('📋 Form State Analysis:');
    print('   Form key exists: ${formKey != null}');
    print('   Form state exists: ${formState != null}');
    
    if (formState != null) {
      try {
        print('   Form is mounted: ${formState.mounted}');
        print('   Form context exists: ${formState.context != null}');
        
        // Try to validate and see what happens
        print('\n🧪 Validation Test:');
        final validationResult = formState.validate();
        print('   Validation result: $validationResult');
        
        // Check individual form fields if validation fails
        if (!validationResult) {
          print('\n🕵️ Investigating Failed Validation...');
          print('   Looking for TextFormField and DropdownButtonFormField widgets...');
          
          // This will show any validation errors that occur
          try {
            formState.save();
            print('   Form save successful');
          } catch (e) {
            print('   Form save error: $e');
          }
        }
        
      } catch (e, stackTrace) {
        print('   ❌ Form inspection error: $e');
        print('   Stack trace: $stackTrace');
      }
    }
    
    // Check controller states
    print('\n📱 Controller States:');
    print('   Title controller text: "${titleController.text}"');
    print('   Title controller selection: ${titleController.selection}');
    print('   Original price controller text: "${originalPriceController.text}"');
    print('   Offer price controller text: "${offerPriceController.text}"');
    
    // Check dropdown values
    print('\n📋 Dropdown Values:');
    print('   Selected category: $selectedCategory');
    print('   Available categories: $categories');
    print('   Selected setup time: $selectedSetupTime');
    print('   Available setup times: $setupTimeOptions');
    print('   Selected booking notice: $selectedBookingNotice');
    print('   Available booking notices: $bookingNoticeOptions');
    
    print('==================================\n');
  }
} 