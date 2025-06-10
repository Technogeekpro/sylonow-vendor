import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_service_controller.dart';

class MediaUploadSection extends StatefulWidget {
  final AddServiceController controller;

  const MediaUploadSection({
    super.key,
    required this.controller,
  });

  @override
  State<MediaUploadSection> createState() => _MediaUploadSectionState();
}

class _MediaUploadSectionState extends State<MediaUploadSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photos Section
          _buildSectionTitle('Photos'),
          const SizedBox(height: 8),
          const Text(
            'Add up to 6 photos. First photo will be the cover photo.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildPhotosGrid(),
          
          const SizedBox(height: 24),
          
          // Video Section
          _buildSectionTitle('Video (Optional)'),
          const SizedBox(height: 8),
          const Text(
            'Add a video to showcase your service (max 30 seconds).',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildVideoUpload(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildPhotosGrid() {
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
          itemCount: 6,
          itemBuilder: (context, index) {
            if (index < widget.controller.photos.length) {
              return _buildPhotoItem(widget.controller.photos[index], index);
            } else {
              return _buildAddPhotoButton();
            }
          },
        ),
        if (widget.controller.isUploadingMedia)
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

  Widget _buildPhotoItem(String photoUrl, int index) {
    final isCover = widget.controller.coverPhoto == photoUrl;
    
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCover ? AppTheme.primaryColor : AppTheme.borderColor,
              width: isCover ? 2 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              photoUrl,
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
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppTheme.textSecondaryColor,
                  ),
                );
              },
            ),
          ),
        ),
        if (isCover)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Cover',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCover)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.controller.setCoverPhoto(photoUrl);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.star,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (!isCover) const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _removePhoto(photoUrl),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: widget.controller.isUploadingMedia ? null : _uploadImages,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.controller.isUploadingMedia 
                ? AppTheme.borderColor.withOpacity(0.5)
                : AppTheme.borderColor,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: widget.controller.isUploadingMedia 
                  ? AppTheme.textSecondaryColor
                  : AppTheme.primaryColor,
            ),
            const SizedBox(height: 4),
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 10,
                color: widget.controller.isUploadingMedia 
                    ? AppTheme.textSecondaryColor
                    : AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoUpload() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: widget.controller.videoUrl?.isNotEmpty == true
          ? _buildVideoPreview()
          : _buildVideoUploadButton(),
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
                Icon(
                  Icons.play_circle_outline,
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
      onTap: widget.controller.isUploadingMedia ? null : _uploadVideo,
      child: Column(
        children: [
          Icon(
            Icons.videocam_outlined,
            size: 48,
            color: widget.controller.isUploadingMedia 
                ? AppTheme.textSecondaryColor
                : AppTheme.primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            widget.controller.isUploadingMedia ? 'Uploading...' : 'Add Video',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: widget.controller.isUploadingMedia 
                  ? AppTheme.textSecondaryColor
                  : AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Upload a video to showcase your service',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          if (widget.controller.isUploadingMedia) ...[
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

  Future<void> _uploadImages() async {
    try {
      await widget.controller.uploadImages();
      setState(() {}); // Refresh UI
    } catch (e) {
      _showErrorSnackBar('Failed to upload images: ${e.toString()}');
    }
  }

  Future<void> _uploadVideo() async {
    try {
      await widget.controller.uploadVideo();
      setState(() {}); // Refresh UI
    } catch (e) {
      _showErrorSnackBar('Failed to upload video: ${e.toString()}');
    }
  }

  Future<void> _removePhoto(String photoUrl) async {
    try {
      await widget.controller.removePhoto(photoUrl);
      setState(() {}); // Refresh UI
    } catch (e) {
      _showErrorSnackBar('Failed to remove photo: ${e.toString()}');
    }
  }

  Future<void> _removeVideo() async {
    try {
      await widget.controller.removeVideo();
      setState(() {}); // Refresh UI
    } catch (e) {
      _showErrorSnackBar('Failed to remove video: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 