import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/themed_add_theater_controller.dart';

class TheaterMediaUploadSection extends ConsumerWidget {
  const TheaterMediaUploadSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themedAddTheaterControllerProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Images Section
        _buildImagesSection(context, ref, controller),
        
        const SizedBox(height: 32),
        
        // Video Section
        _buildVideoSection(context, ref, controller),
      ],
    );
  }

  Widget _buildImagesSection(BuildContext context, WidgetRef ref, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.photo_library,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Theater Photos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Add up to 10 high-quality photos of your theater',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Image Grid
        if (controller.theaterImages.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: controller.theaterImages.length + (controller.theaterImages.length < 10 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.theaterImages.length) {
                return _buildAddImageButton(ref);
              }
              
              final imageUrl = controller.theaterImages[index];
              return _buildImageTile(imageUrl, () {
                ref.read(themedAddTheaterControllerProvider.notifier).removeImage(imageUrl);
              });
            },
          ),
        ] else ...[
          _buildAddImageButton(ref, isLarge: true),
        ],
      ],
    );
  }

  Widget _buildVideoSection(BuildContext context, WidgetRef ref, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.videocam,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Theater Video',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Add a short video (max 30 seconds) showcasing your theater',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Video Upload Area
        if (controller.theaterVideoUrl != null) ...[
          _buildVideoPreview(controller.theaterVideoUrl!, () {
            ref.read(themedAddTheaterControllerProvider.notifier).removeVideo();
          }),
        ] else ...[
          _buildAddVideoButton(ref, controller.isVideoLoading),
        ],
      ],
    );
  }

  Widget _buildAddImageButton(WidgetRef ref, {bool isLarge = false}) {
    return InkWell(
      onTap: () async {
        try {
          await ref.read(themedAddTheaterControllerProvider.notifier).pickAndUploadImages();
        } catch (e) {
          // Handle error - could show snackbar here
          print('Error uploading images: $e');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: isLarge ? 120 : null,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              color: AppTheme.primaryColor,
              size: isLarge ? 32 : 24,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photos',
              style: TextStyle(
                fontSize: isLarge ? 14 : 12,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(String imageUrl, VoidCallback onRemove) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppTheme.borderColor,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.borderColor,
              child: const Icon(
                Icons.broken_image,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ),
        
        // Remove Button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppTheme.errorColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddVideoButton(WidgetRef ref, bool isLoading) {
    return InkWell(
      onTap: isLoading ? null : () async {
        try {
          await ref.read(themedAddTheaterControllerProvider.notifier).pickAndUploadVideo();
        } catch (e) {
          // Handle error - could show snackbar here
          print('Error uploading video: $e');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: AppTheme.accentBlue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.accentBlue.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              const CircularProgressIndicator(
                color: AppTheme.accentBlue,
                strokeWidth: 2,
              ),
              const SizedBox(height: 12),
              const Text(
                'Uploading Video...',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.accentBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              const Icon(
                Icons.video_call,
                color: AppTheme.accentBlue,
                size: 32,
              ),
              const SizedBox(height: 12),
              const Text(
                'Add Theater Video',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.accentBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Max 30 seconds',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPreview(String videoUrl, VoidCallback onRemove) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Video Thumbnail (placeholder)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black87,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Video Added',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Remove Button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppTheme.errorColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}