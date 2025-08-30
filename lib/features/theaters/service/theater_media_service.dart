import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';

final theaterMediaServiceProvider = Provider((ref) => TheaterMediaService());

class TheaterMediaService {
  final _client = SupabaseConfig.client;
  final ImagePicker _picker = ImagePicker();

  // Pick and upload images for theater screens
  Future<List<String>> pickAndUploadImages({
    required int maxImages,
    List<String> existingImages = const [],
  }) async {
    try {
      print('🔵 TheaterMediaService: Picking images (max: $maxImages)');
      
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
        imageQuality: 85,
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
          print('🔴 TheaterMediaService: Image ${i + 1} too large: $fileSize bytes');
          continue;
        }

        // Generate unique filename
        final extension = path.extension(image.path).toLowerCase();
        final fileName = 'theater_image_${DateTime.now().millisecondsSinceEpoch}_$i$extension';
        final filePath = '${user.id}/theater-media/$fileName';
        
        print('🔵 TheaterMediaService: Uploading image ${i + 1}: $filePath');

        try {
          // Use the same bucket as service listings for consistency
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
          print('🟢 TheaterMediaService: Image uploaded successfully: $imageUrl');
        } catch (e) {
          print('🔴 TheaterMediaService: Error uploading image ${i + 1}: $e');
        }
      }

      return [...existingImages, ...uploadedUrls];
    } catch (e) {
      print('🔴 TheaterMediaService: Error picking/uploading images: $e');
      rethrow;
    }
  }

  // Pick and upload video for theater screens
  Future<String?> pickAndUploadVideo() async {
    try {
      print('🔵 TheaterMediaService: Picking video');
      
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 2), // Allow 2 minutes for theater videos
      );

      if (video == null) return null;

      final videoFile = File(video.path);
      
      // Validate file size (max 100MB for theater videos)
      final fileSize = await videoFile.length();
      if (fileSize > 100 * 1024 * 1024) {
        throw Exception('Video file too large. Maximum size is 100MB.');
      }

      // Generate unique filename
      final extension = path.extension(video.path).toLowerCase();
      final fileName = 'theater_video_${DateTime.now().millisecondsSinceEpoch}$extension';
      final filePath = '${user.id}/theater-media/$fileName';
      
      print('🔵 TheaterMediaService: Uploading video: $filePath');

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

      print('🟢 TheaterMediaService: Video uploaded successfully: $videoUrl');
      return videoUrl;
    } catch (e) {
      print('🔴 TheaterMediaService: Error picking/uploading video: $e');
      rethrow;
    }
  }

  // Pick single image from camera or gallery
  Future<String?> pickAndUploadSingleImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      print('🔵 TheaterMediaService: Picking single image from $source');
      
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      final imageFile = File(image.path);
      
      // Validate file size (max 10MB)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception('Image file too large. Maximum size is 10MB.');
      }

      // Generate unique filename
      final extension = path.extension(image.path).toLowerCase();
      final fileName = 'theater_image_${DateTime.now().millisecondsSinceEpoch}$extension';
      final filePath = '${user.id}/theater-media/$fileName';
      
      print('🔵 TheaterMediaService: Uploading single image: $filePath');

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

      print('🟢 TheaterMediaService: Single image uploaded successfully: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('🔴 TheaterMediaService: Error picking/uploading single image: $e');
      rethrow;
    }
  }

  // Delete media file from storage
  Future<void> deleteMediaFile(String fileUrl) async {
    try {
      print('🔵 TheaterMediaService: Deleting media file: $fileUrl');
      
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
      
      print('🟢 TheaterMediaService: Media file deleted successfully');
    } catch (e) {
      print('🔴 TheaterMediaService: Error deleting media file: $e');
      rethrow;
    }
  }

  // Validate media file before upload
  bool validateImageFile(File file) {
    final extension = path.extension(file.path).toLowerCase();
    const allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    return allowedExtensions.contains(extension);
  }

  bool validateVideoFile(File file) {
    final extension = path.extension(file.path).toLowerCase();
    const allowedExtensions = ['.mp4', '.mov', '.avi', '.mkv'];
    return allowedExtensions.contains(extension);
  }

  // Get file size in human readable format
  String getFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}