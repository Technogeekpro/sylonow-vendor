import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_theater_controller.dart';

class TheaterImagesSection extends StatefulWidget {
  final AddTheaterController controller;

  const TheaterImagesSection({
    super.key,
    required this.controller,
  });

  @override
  State<TheaterImagesSection> createState() => _TheaterImagesSectionState();
}

class _TheaterImagesSectionState extends State<TheaterImagesSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Theater Media',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload high-quality images and optional promotional video',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),

          // Upload Section
          _buildUploadSection(),

          const SizedBox(height: 32),

          // Video Section
          _buildVideoSection(),

          const SizedBox(height: 32),

          // Images Grid
          if (widget.controller.theaterImages.isNotEmpty) ...[
            const Text(
              'Uploaded Images',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildImagesGrid(),
            const SizedBox(height: 32),
          ],

          // Video Guidelines Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.videocam,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Video Guidelines',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '• Maximum video duration: 30 seconds\n'
                  '• Maximum file size: 100MB (before compression)\n'
                  '• Video is automatically compressed for optimal streaming\n'
                  '• Supported formats: MP4, MOV, AVI\n'
                  '• Show your theater interior, ambiance, and facilities\n'
                  '• Videos help customers get a better feel for your theater',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Photo Guidelines Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentTeal.withOpacity(0.2),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.photo_camera,
                      color: AppTheme.accentTeal,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Photo Guidelines',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '• Upload at least 3-5 high-quality images\n'
                  '• Include exterior, interior, seating, and stage views\n'
                  '• Use good lighting and clear shots\n'
                  '• Maximum file size: 10MB per image\n'
                  '• Supported formats: JPG, PNG (auto-converted to WebP)\n'
                  '• Images are automatically optimized for faster loading',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              color: AppTheme.primaryColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Upload Theater Images',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.controller.theaterImages.isEmpty
                ? 'Add photos to showcase your theater'
                : '${widget.controller.theaterImages.length}/10 images uploaded',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: widget.controller.isLoading ? null : _pickImages,
            icon: widget.controller.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.add_photo_alternate, size: 20),
            label: Text(
              widget.controller.isLoading
                  ? 'Uploading...'
                  : widget.controller.theaterImages.isEmpty
                      ? 'Choose Images'
                      : 'Add More Images',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Theater Video (Optional)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        
        if (widget.controller.theaterVideoUrl != null) ...[
          // Video Preview Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.videocam,
                        color: AppTheme.successColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Video Uploaded Successfully',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your theater video has been compressed and uploaded',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _removeVideo,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppTheme.errorColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          // Video Upload Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.borderColor,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam,
                    color: AppTheme.accentTeal,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Upload Theater Video',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Show customers the ambiance and facilities of your theater',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: widget.controller.isVideoLoading ? null : _pickVideo,
                  icon: widget.controller.isVideoLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.video_library, size: 20),
                  label: Text(
                    widget.controller.isVideoLoading 
                        ? 'Processing...' 
                        : 'Choose Video',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: widget.controller.theaterImages.length,
      itemBuilder: (context, index) {
        final imageUrl = widget.controller.theaterImages[index];
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppTheme.surfaceColor,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.surfaceColor,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: AppTheme.textSecondaryColor,
                            size: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Failed to load',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                // Delete Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _removeImage(imageUrl),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
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
                
                // Main Image Indicator
                if (index == 0)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Main',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImages() async {
    if (widget.controller.theaterImages.length >= 10) {
      _showErrorSnackBar('Maximum 10 images allowed');
      return;
    }

    try {
      await widget.controller.pickAndUploadImages();
      setState(() {}); // Refresh UI after images are uploaded
    } catch (e) {
      _showErrorSnackBar('Failed to upload images: ${e.toString()}');
    }
  }

  void _removeImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Image'),
        content: const Text('Are you sure you want to remove this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.controller.removeImage(imageUrl);
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickVideo() async {
    try {
      await widget.controller.pickAndUploadVideo();
      setState(() {}); // Refresh UI after video is uploaded
    } catch (e) {
      _showErrorSnackBar('Failed to upload video: ${e.toString()}');
    }
  }

  void _removeVideo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Video'),
        content: const Text('Are you sure you want to remove this video?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.controller.removeVideo();
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}