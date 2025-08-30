import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import '../models/service_add_on.dart';

class ServiceAddOnService {
  final _supabase = SupabaseConfig.client;

  /// Create a new service add-on
  Future<ServiceAddOn?> createAddOn(ServiceAddOn addOn) async {
    try {
      log('Creating service add-on: ${addOn.name} for service ${addOn.serviceListingId}');
      
      final response = await _supabase
          .from('service_add_ons')
          .insert(addOn.toJson())
          .select()
          .single();
      
      log('Service add-on created successfully: ${response['id']}');
      return ServiceAddOn.fromJson(response);
    } catch (e) {
      log('Error creating service add-on: $e');
      return null;
    }
  }

  /// Create multiple service add-ons in a batch
  Future<List<ServiceAddOn>> createAddOns(List<ServiceAddOn> addOns) async {
    try {
      log('Creating ${addOns.length} service add-ons');
      
      final response = await _supabase
          .from('service_add_ons')
          .insert(addOns.map((addOn) => addOn.toJson()).toList())
          .select();
      
      log('${response.length} service add-ons created successfully');
      return response.map((json) => ServiceAddOn.fromJson(json)).toList();
    } catch (e) {
      log('Error creating service add-ons: $e');
      return [];
    }
  }

  /// Get all add-ons for a specific service listing
  Future<List<ServiceAddOn>> getAddOnsForService(String serviceListingId) async {
    try {
      log('Fetching add-ons for service listing: $serviceListingId');
      
      final response = await _supabase
          .from('service_add_ons')
          .select()
          .eq('service_listing_id', serviceListingId)
          .order('sort_order', ascending: true)
          .order('created_at', ascending: true);
      
      log('Found ${response.length} add-ons for service listing');
      return response.map((json) => ServiceAddOn.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching service add-ons: $e');
      return [];
    }
  }

  /// Update an existing service add-on
  Future<ServiceAddOn?> updateAddOn(ServiceAddOn addOn) async {
    try {
      log('Updating service add-on: ${addOn.id}');
      
      final response = await _supabase
          .from('service_add_ons')
          .update(addOn.toJson())
          .eq('id', addOn.id!)
          .select()
          .single();
      
      log('Service add-on updated successfully');
      return ServiceAddOn.fromJson(response);
    } catch (e) {
      log('Error updating service add-on: $e');
      return null;
    }
  }

  /// Delete a service add-on
  Future<bool> deleteAddOn(String addOnId) async {
    try {
      log('Deleting service add-on: $addOnId');
      
      await _supabase
          .from('service_add_ons')
          .delete()
          .eq('id', addOnId);
      
      log('Service add-on deleted successfully');
      return true;
    } catch (e) {
      log('Error deleting service add-on: $e');
      return false;
    }
  }

  /// Delete all add-ons for a service listing
  Future<bool> deleteAddOnsForService(String serviceListingId) async {
    try {
      log('Deleting all add-ons for service listing: $serviceListingId');
      
      await _supabase
          .from('service_add_ons')
          .delete()
          .eq('service_listing_id', serviceListingId);
      
      log('All add-ons deleted successfully');
      return true;
    } catch (e) {
      log('Error deleting service add-ons: $e');
      return false;
    }
  }

  /// Update add-on availability
  Future<bool> updateAddOnAvailability(String addOnId, bool isAvailable) async {
    try {
      log('Updating add-on availability: $addOnId -> $isAvailable');
      
      await _supabase
          .from('service_add_ons')
          .update({
            'is_available': isAvailable,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', addOnId);
      
      log('Add-on availability updated successfully');
      return true;
    } catch (e) {
      log('Error updating add-on availability: $e');
      return false;
    }
  }

  /// Update add-on stock
  Future<bool> updateAddOnStock(String addOnId, int stock) async {
    try {
      log('Updating add-on stock: $addOnId -> $stock');
      
      await _supabase
          .from('service_add_ons')
          .update({
            'stock': stock,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', addOnId);
      
      log('Add-on stock updated successfully');
      return true;
    } catch (e) {
      log('Error updating add-on stock: $e');
      return false;
    }
  }

  /// Reorder add-ons for a service
  Future<bool> reorderAddOns(Map<String, int> addOnOrders) async {
    try {
      log('Reordering ${addOnOrders.length} add-ons');
      
      final futures = addOnOrders.entries.map((entry) async {
        await _supabase
            .from('service_add_ons')
            .update({
              'sort_order': entry.value,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', entry.key);
      });
      
      await Future.wait(futures);
      
      log('Add-ons reordered successfully');
      return true;
    } catch (e) {
      log('Error reordering add-ons: $e');
      return false;
    }
  }

  /// Upload add-on image to Supabase storage
  Future<String?> uploadAddOnImage(File imageFile, String addOnId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        log('Error: User not authenticated');
        return null;
      }

      // Validate file size (max 10MB)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        log('Error: Image file too large: $fileSize bytes');
        throw Exception('Image file too large. Maximum size is 10MB.');
      }

      // Generate unique filename
      final extension = path.extension(imageFile.path).toLowerCase();
      final fileName = 'addon_${addOnId}_${DateTime.now().millisecondsSinceEpoch}$extension';
      final filePath = '${user.id}/addon-images/$fileName';
      
      log('Uploading add-on image: $filePath');

      await _supabase.storage.from('service-addon-images').upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(
          cacheControl: '3600',
          upsert: false,
        ),
      );

      final imageUrl = _supabase.storage
          .from('service-addon-images')
          .getPublicUrl(filePath);

      log('Add-on image uploaded successfully: $imageUrl');
      return imageUrl;
    } catch (e) {
      log('Error uploading add-on image: $e');
      return null;
    }
  }

  /// Upload multiple add-on images
  Future<List<String>> uploadAddOnImages(List<File> imageFiles, String addOnId) async {
    final uploadedUrls = <String>[];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final imageUrl = await uploadAddOnImage(imageFiles[i], '${addOnId}_$i');
      if (imageUrl != null) {
        uploadedUrls.add(imageUrl);
      }
    }
    
    log('Uploaded ${uploadedUrls.length}/${imageFiles.length} add-on images');
    return uploadedUrls;
  }

  /// Delete add-on image from storage
  Future<bool> deleteAddOnImage(String imageUrl) async {
    try {
      log('Deleting add-on image: $imageUrl');
      
      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;
      final bucketIndex = segments.indexOf('service-addon-images');
      
      if (bucketIndex == -1 || bucketIndex + 1 >= segments.length) {
        throw Exception('Invalid image URL format');
      }
      
      final filePath = segments.sublist(bucketIndex + 1).join('/');
      
      await _supabase.storage
          .from('service-addon-images')
          .remove([filePath]);
      
      log('Add-on image deleted successfully');
      return true;
    } catch (e) {
      log('Error deleting add-on image: $e');
      return false;
    }
  }

  /// Create service add-on with image upload
  Future<ServiceAddOn?> createAddOnWithImage(ServiceAddOn addOn, File? imageFile) async {
    try {
      log('Creating service add-on with image: ${addOn.name}');
      
      String? imageUrl;
      if (imageFile != null) {
        // Upload image first
        imageUrl = await uploadAddOnImage(imageFile, 'temp_${DateTime.now().millisecondsSinceEpoch}');
        if (imageUrl == null) {
          log('Warning: Failed to upload image, creating add-on without image');
        }
      }
      
      // Create add-on with image URL
      final addOnWithImage = ServiceAddOn(
        id: addOn.id,
        serviceListingId: addOn.serviceListingId,
        name: addOn.name,
        originalPrice: addOn.originalPrice,
        discountPrice: addOn.discountPrice,
        description: addOn.description,
        images: imageUrl != null ? [imageUrl] : addOn.images,
        type: addOn.type,
        unit: addOn.unit,
        stock: addOn.stock,
        isAvailable: addOn.isAvailable,
        sortOrder: addOn.sortOrder,
      );
      
      return await createAddOn(addOnWithImage);
    } catch (e) {
      log('Error creating service add-on with image: $e');
      return null;
    }
  }
}