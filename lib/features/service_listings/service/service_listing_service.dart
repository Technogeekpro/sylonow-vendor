import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../../../core/config/supabase_config.dart';
import '../models/service_listing.dart';

final serviceListingServiceProvider = Provider((ref) => ServiceListingService());

class ServiceListingService {
  final SupabaseClient _client = SupabaseConfig.client;
  final ImagePicker _picker = ImagePicker();

  // Get vendor's service listings
  Future<List<ServiceListing>> getVendorListings(String vendorId) async {
    try {
      print('🔵 ServiceListingService: Getting listings for vendor: $vendorId');
      
      final response = await _client
          .from('service_listings')
          .select('*')
          .eq('vendor_id', vendorId)
          .order('created_at', ascending: false);
      
      print('🔵 ServiceListingService: Database response received');
      print('🔵 ServiceListingService: Found ${response.length} listings');
      
      return response.map((json) => ServiceListing.fromJson(json)).toList();
    } catch (e) {
      print('🔴 ServiceListingService: Error getting listings: $e');
      if (e is PostgrestException) {
        print('🔴 ServiceListingService: Postgrest error details: ${e.details}');
        print('🔴 ServiceListingService: Postgrest error message: ${e.message}');
      }
      rethrow;
    }
  }

  // Create a new service listing
  Future<ServiceListing> createListing(ServiceListing listing) async {
    try {
      print('🔵 ServiceListingService: Creating new listing');
      print('🔵 ServiceListingService: Title: ${listing.title}');
      print('🔵 ServiceListingService: Vendor ID: ${listing.vendorId}');
      
      final listingData = listing.toJson();
      // Remove auto-generated fields that will be set by the database
      listingData.remove('id');
      listingData.remove('listing_id');
      listingData.remove('created_at');
      listingData.remove('updated_at');
      
      final response = await _client
          .from('service_listings')
          .insert(listingData)
          .select()
          .single();
      
      print('🟢 ServiceListingService: Listing created successfully');
      return ServiceListing.fromJson(response);
    } catch (e) {
      print('🔴 ServiceListingService: Error creating listing: $e');
      if (e is PostgrestException) {
        print('🔴 ServiceListingService: Postgrest error details: ${e.details}');
        print('🔴 ServiceListingService: Postgrest error message: ${e.message}');
      }
      rethrow;
    }
  }

  // Update an existing service listing
  Future<ServiceListing> updateListing(ServiceListing listing) async {
    try {
      print('🔵 ServiceListingService: Updating listing: ${listing.id}');
      
      final listingData = listing.toJson();
      // Remove fields that shouldn't be updated
      listingData.remove('id');
      listingData.remove('listing_id');
      listingData.remove('vendor_id');
      listingData.remove('created_at');
      listingData.remove('updated_at');
      
      final response = await _client
          .from('service_listings')
          .update(listingData)
          .eq('id', listing.id)
          .select()
          .single();
      
      print('🟢 ServiceListingService: Listing updated successfully');
      return ServiceListing.fromJson(response);
    } catch (e) {
      print('🔴 ServiceListingService: Error updating listing: $e');
      rethrow;
    }
  }

  // Delete a service listing
  Future<void> deleteListing(String listingId) async {
    try {
      print('🔵 ServiceListingService: Deleting listing: $listingId');
      
      await _client
          .from('service_listings')
          .delete()
          .eq('id', listingId);
      
      print('🟢 ServiceListingService: Listing deleted successfully');
    } catch (e) {
      print('🔴 ServiceListingService: Error deleting listing: $e');
      rethrow;
    }
  }

  // Toggle listing active status
  Future<ServiceListing> toggleListingStatus(String listingId, bool isActive) async {
    try {
      print('🔵 ServiceListingService: Toggling listing status: $listingId to $isActive');
      
      final response = await _client
          .from('service_listings')
          .update({'is_active': isActive})
          .eq('id', listingId)
          .select()
          .single();
      
      print('🟢 ServiceListingService: Listing status updated successfully');
      return ServiceListing.fromJson(response);
    } catch (e) {
      print('🔴 ServiceListingService: Error toggling listing status: $e');
      rethrow;
    }
  }

  // Pick and upload images for service listing
  Future<List<String>> pickAndUploadImages({
    required int maxImages,
    List<String> existingImages = const [],
  }) async {
    try {
      print('🔵 ServiceListingService: Picking images (max: $maxImages)');
      
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final availableSlots = maxImages - existingImages.length;
      if (availableSlots <= 0) {
        throw Exception('Maximum images already selected');
      }

      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (images.isEmpty) return existingImages;

      final imagesToProcess = images.take(availableSlots).toList();
      final uploadedUrls = <String>[];

      for (int i = 0; i < imagesToProcess.length; i++) {
        final image = imagesToProcess[i];
        final imageFile = File(image.path);
        
        // Validate file size (max 10MB)
        final fileSize = await imageFile.length();
        if (fileSize > 10 * 1024 * 1024) {
          print('🔴 ServiceListingService: Image ${i + 1} too large: $fileSize bytes');
          continue;
        }

        // Generate unique filename
        final extension = path.extension(image.path).toLowerCase();
        final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}_$i$extension';
        final filePath = '${user.id}/service-media/$fileName';
        
        print('🔵 ServiceListingService: Uploading image ${i + 1}: $filePath');

        try {
          await _client.storage.from('service-listing-media').upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

          final imageUrl = _client.storage
              .from('service-listing-media')
              .getPublicUrl(filePath);

          uploadedUrls.add(imageUrl);
          print('🟢 ServiceListingService: Image uploaded successfully: $imageUrl');
        } catch (e) {
          print('🔴 ServiceListingService: Error uploading image ${i + 1}: $e');
        }
      }

      return [...existingImages, ...uploadedUrls];
    } catch (e) {
      print('🔴 ServiceListingService: Error picking/uploading images: $e');
      rethrow;
    }
  }

  // Pick and upload video for service listing
  Future<String?> pickAndUploadVideo() async {
    try {
      print('🔵 ServiceListingService: Picking video');
      
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );

      if (video == null) return null;

      final videoFile = File(video.path);
      
      // Validate file size (max 50MB)
      final fileSize = await videoFile.length();
      if (fileSize > 50 * 1024 * 1024) {
        throw Exception('Video file too large. Maximum size is 50MB.');
      }

      // Generate unique filename
      final extension = path.extension(video.path).toLowerCase();
      final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}$extension';
      final filePath = '${user.id}/service-media/$fileName';
      
      print('🔵 ServiceListingService: Uploading video: $filePath');

      await _client.storage.from('service-listing-media').upload(
        filePath,
        videoFile,
        fileOptions: const FileOptions(
          cacheControl: '3600',
          upsert: false,
        ),
      );

      final videoUrl = _client.storage
          .from('service-listing-media')
          .getPublicUrl(filePath);

      print('🟢 ServiceListingService: Video uploaded successfully: $videoUrl');
      return videoUrl;
    } catch (e) {
      print('🔴 ServiceListingService: Error picking/uploading video: $e');
      rethrow;
    }
  }

  // Delete media file from storage
  Future<void> deleteMediaFile(String fileUrl) async {
    try {
      print('🔵 ServiceListingService: Deleting media file: $fileUrl');
      
      // Extract file path from URL
      final uri = Uri.parse(fileUrl);
      final segments = uri.pathSegments;
      final bucketIndex = segments.indexOf('service-listing-media');
      
      if (bucketIndex == -1 || bucketIndex + 1 >= segments.length) {
        throw Exception('Invalid file URL format');
      }
      
      final filePath = segments.sublist(bucketIndex + 1).join('/');
      
      await _client.storage
          .from('service-listing-media')
          .remove([filePath]);
      
      print('🟢 ServiceListingService: Media file deleted successfully');
    } catch (e) {
      print('🔴 ServiceListingService: Error deleting media file: $e');
      rethrow;
    }
  }

  // Get categories for dropdown
  List<String> getCategories() {
    return [
      'Birthday',
      'Anniversary',
      'Proposal',
      'Wedding',
      'Baby Shower',
      'Housewarming',
      'Corporate Event',
      'Festival',
      'Farewell',
      'Welcome',
      'Other',
    ];
  }

  // Get theme tags for selection
  List<String> getThemeTags() {
    return [
      'Romantic',
      'Silver',
      'Gold',
      'Kids',
      'Vintage',
      'Modern',
      'Traditional',
      'Colorful',
      'Elegant',
      'Fun',
      'Luxury',
      'Simple',
      'Floral',
      'Balloon',
      'LED',
    ];
  }

  // Get service environment options
  List<String> getServiceEnvironments() {
    return [
      'indoor',
      'outdoor',
    ];
  }

  // Get setup time options
  List<String> getSetupTimeOptions() {
    return [
      '30 mins',
      '1 hr',
      '1.5 hrs',
      '2 hrs',
      '3 hrs',
      '4 hrs',
      'Half Day',
      'Full Day',
    ];
  }

  // Get booking notice options
  List<String> getBookingNoticeOptions() {
    return [
      '2 hrs',
      '4 hrs',
      '6 hrs',
      '12 hrs',
      '1 day',
      '2 days',
      '3 days',
      '1 week',
    ];
  }

  // Get venue types
  List<String> getVenueTypes() {
    return [
      'Home',
      'Apartment',
      'Café',
      'Restaurant',
      'Rooftop',
      'Garden',
      'Hall',
      'Hotel',
      'Office',
      'Outdoor',
      'Beach',
      'Farmhouse',
    ];
  }
} 