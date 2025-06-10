import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUploadWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final File? image;
  final Function(File) onImageSelected;

  const ImageUploadWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onImageSelected,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _errorMessage != null 
            ? Colors.red.withOpacity(0.5)
            : widget.image != null 
              ? const Color(0xFFE91E63).withOpacity(0.3)
              : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _errorMessage != null
                      ? Colors.red.withOpacity(0.1)
                      : const Color(0xFFE91E63).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFE91E63),
                        ),
                      )
                    : Icon(
                        _errorMessage != null 
                          ? Icons.error_outline
                          : widget.image != null 
                            ? Icons.check_circle 
                            : Icons.upload_file,
                        color: _errorMessage != null 
                          ? Colors.red
                          : widget.image != null 
                            ? Colors.green 
                            : const Color(0xFFE91E63),
                        size: 20,
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _errorMessage ?? widget.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: _errorMessage != null 
                            ? Colors.red
                            : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.image != null && _errorMessage == null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Ready',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Image Preview or Upload Area
          GestureDetector(
            onTap: _isLoading ? null : _pickImage,
            child: Container(
              width: double.infinity,
              height: widget.image != null ? 200 : 120,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _errorMessage != null 
                    ? Colors.red.withOpacity(0.3)
                    : Colors.grey.shade200,
                  style: BorderStyle.solid,
                ),
              ),
              child: widget.image != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            widget.image!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _isLoading ? null : _pickImage,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 32,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLoading ? 'Processing...' : 'Tap to upload image',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'JPG, PNG (Max 10MB)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ImagePicker picker = ImagePicker();
      
      // Show bottom sheet to choose source
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920, // Higher quality for documents
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        
        // Check file size (10MB limit - increased for documents)
        final int fileSizeInBytes = await imageFile.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        
        print('📸 Image selected: ${pickedFile.name}');
        print('📸 File size: ${fileSizeInMB.toStringAsFixed(2)}MB');
        
        if (fileSizeInMB > 10) {
          setState(() {
            _errorMessage = 'File too large (${fileSizeInMB.toStringAsFixed(1)}MB). Max 10MB allowed.';
            _isLoading = false;
          });
          return;
        }
        
        // Validate file extension
        final String extension = pickedFile.path.toLowerCase();
        if (!extension.endsWith('.jpg') && 
            !extension.endsWith('.jpeg') && 
            !extension.endsWith('.png')) {
          setState(() {
            _errorMessage = 'Invalid file type. Please select JPG or PNG.';
            _isLoading = false;
          });
          return;
        }
        
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
        
        widget.onImageSelected(imageFile);
        print('📸 Image successfully selected and validated');
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('📸 Error picking image: $e');
      setState(() {
        _errorMessage = 'Failed to select image. Please try again.';
        _isLoading = false;
      });
    }
  }
} 