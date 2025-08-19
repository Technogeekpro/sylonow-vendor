import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  
  static SupabaseClient get client => _client;
  
  // Get current user ID
  static String? get currentUserId => _client.auth.currentUser?.id;
  
  // Get vendor's service listings (theaters)
  static Future<List<Map<String, dynamic>>> getServiceListings() async {
    try {
      final response = await _client
          .from('service_listings')
          .select('id, title')
          .eq('vendor_id', currentUserId!)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch service listings: $e');
    }
  }
  
  // Upload image to Supabase Storage
  static Future<String> uploadImage(File imageFile, String bucket, String fileName) async {
    try {
      final String path = '$currentUserId/$fileName';
      await _client.storage.from(bucket).upload(path, imageFile);
      final String publicUrl = _client.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  
  // Add-ons operations
  static Future<List<Map<String, dynamic>>> getAddOns() async {
    try {
      final response = await _client
          .from('add_ons')
          .select('*, service_listings!inner(title)')
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch add-ons: $e');
    }
  }
  
  static Future<void> addAddOn(Map<String, dynamic> addOnData) async {
    try {
      await _client.from('add_ons').insert(addOnData);
    } catch (e) {
      throw Exception('Failed to add add-on: $e');
    }
  }
  
  static Future<void> updateAddOn(String id, Map<String, dynamic> addOnData) async {
    try {
      await _client.from('add_ons').update(addOnData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update add-on: $e');
    }
  }
  
  static Future<void> deleteAddOn(String id) async {
    try {
      await _client.from('add_ons').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete add-on: $e');
    }
  }
  
  // Gifts operations
  static Future<List<Map<String, dynamic>>> getGifts() async {
    try {
      final response = await _client
          .from('gifts')
          .select('*')
          .eq('vendor_id', currentUserId!)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch gifts: $e');
    }
  }
  
  static Future<void> addGift(Map<String, dynamic> giftData) async {
    try {
      giftData['vendor_id'] = currentUserId;
      await _client.from('gifts').insert(giftData);
    } catch (e) {
      throw Exception('Failed to add gift: $e');
    }
  }
  
  static Future<void> updateGift(String id, Map<String, dynamic> giftData) async {
    try {
      await _client.from('gifts').update(giftData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update gift: $e');
    }
  }
  
  static Future<void> deleteGift(String id) async {
    try {
      await _client.from('gifts').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete gift: $e');
    }
  }
  
  // Cakes operations
  static Future<List<Map<String, dynamic>>> getCakes() async {
    try {
      final response = await _client
          .from('cakes')
          .select('*')
          .eq('vendor_id', currentUserId!)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch cakes: $e');
    }
  }
  
  static Future<void> addCake(Map<String, dynamic> cakeData) async {
    try {
      cakeData['vendor_id'] = currentUserId;
      await _client.from('cakes').insert(cakeData);
    } catch (e) {
      throw Exception('Failed to add cake: $e');
    }
  }
  
  static Future<void> updateCake(String id, Map<String, dynamic> cakeData) async {
    try {
      await _client.from('cakes').update(cakeData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update cake: $e');
    }
  }
  
  static Future<void> deleteCake(String id) async {
    try {
      await _client.from('cakes').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete cake: $e');
    }
  }
  
  // Special Services operations
  static Future<List<Map<String, dynamic>>> getSpecialServices() async {
    try {
      final response = await _client
          .from('special_services')
          .select('*')
          .eq('vendor_id', currentUserId!)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch special services: $e');
    }
  }
  
  static Future<void> addSpecialService(Map<String, dynamic> serviceData) async {
    try {
      serviceData['vendor_id'] = currentUserId;
      await _client.from('special_services').insert(serviceData);
    } catch (e) {
      throw Exception('Failed to add special service: $e');
    }
  }
  
  static Future<void> updateSpecialService(String id, Map<String, dynamic> serviceData) async {
    try {
      await _client.from('special_services').update(serviceData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update special service: $e');
    }
  }
  
  static Future<void> deleteSpecialService(String id) async {
    try {
      await _client.from('special_services').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete special service: $e');
    }
  }
  
  // Extra Special Services operations
  static Future<List<Map<String, dynamic>>> getExtraSpecialServices() async {
    try {
      final response = await _client
          .from('extra_special_services')
          .select('*')
          .eq('vendor_id', currentUserId!)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch extra special services: $e');
    }
  }
  
  static Future<void> addExtraSpecialService(Map<String, dynamic> serviceData) async {
    try {
      serviceData['vendor_id'] = currentUserId;
      await _client.from('extra_special_services').insert(serviceData);
    } catch (e) {
      throw Exception('Failed to add extra special service: $e');
    }
  }
  
  static Future<void> updateExtraSpecialService(String id, Map<String, dynamic> serviceData) async {
    try {
      await _client.from('extra_special_services').update(serviceData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update extra special service: $e');
    }
  }
  
  static Future<void> deleteExtraSpecialService(String id) async {
    try {
      await _client.from('extra_special_services').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete extra special service: $e');
    }
  }
}