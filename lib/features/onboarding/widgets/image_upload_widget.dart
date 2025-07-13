import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final File? image;
  final String? imageUrl;
  final Function(File?) onImageSelected;
  final Function(String)? onImageUploaded;
  final String documentType;

  const ImageUploadWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.imageUrl,
    required this.onImageSelected,
    this.onImageUploaded,
    required this.documentType,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _uploadedUrl;

  @override
  void initState() {
    super.initState();
    _uploadedUrl = widget.imageUrl;
  }

  bool get hasImage => widget.image != null || _uploadedUrl != null;

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
                if (hasImage && _errorMessage == null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _uploadedUrl != null ? 'Uploaded' : 'Ready',
                      style: const TextStyle(
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
              child: hasImage
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _uploadedUrl != null
                              ? Image.network(
                                  _uploadedUrl!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: double.infinity,
                                      height: 200,
                                      color: Colors.grey.shade100,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 200,
                                      color: Colors.grey.shade100,
                                      child: const Center(
                                        child: Icon(Icons.error, color: Colors.red),
                                      ),
                                    );
                                  },
                                )
                              : Image.file(
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
        
        // Upload immediately to Supabase Storage
        try {
          print('📸 Starting immediate upload to Supabase for ${widget.documentType}...');
          final String uploadedUrl = await _uploadToSupabase(imageFile);
          
          setState(() {
            _uploadedUrl = uploadedUrl;
            _isLoading = false;
            _errorMessage = null;
          });
          
          // Notify parent about the upload
          print('📸 Calling onImageUploaded callback for ${widget.documentType} with URL: $uploadedUrl');
          if (widget.onImageUploaded != null) {
            widget.onImageUploaded!(uploadedUrl);
            print('📸 onImageUploaded callback completed for ${widget.documentType}');
          } else {
            print('⚠️ onImageUploaded callback is null for ${widget.documentType}');
          }
          
          // Also call the original callback with null file to indicate we're using URL
          print('📸 Calling onImageSelected with null for ${widget.documentType} (using URL instead)');
          widget.onImageSelected(null);
          
          print('📸 Image successfully uploaded to Supabase: $uploadedUrl');
        } catch (uploadError) {
          print('📸 Upload failed: $uploadError');
          
          // If upload fails, fall back to local storage as before
          try {
            final Directory appDir = await getApplicationDocumentsDirectory();
            final String fileName = 'vendor_doc_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
            final String permanentPath = path.join(appDir.path, 'vendor_uploads', fileName);
            
            await Directory(path.dirname(permanentPath)).create(recursive: true);
            final File permanentFile = await imageFile.copy(permanentPath);
            
            if (!await permanentFile.exists()) {
              throw Exception('Failed to save image to persistent storage');
            }
            
            final persistentSize = await permanentFile.length();
            if (persistentSize == 0) {
              throw Exception('Image file became corrupted during save');
            }
            
            print('📸 Upload failed, saved locally: $permanentPath ($persistentSize bytes)');
            
            setState(() {
              _isLoading = false;
              _errorMessage = null;
            });
            
            widget.onImageSelected(permanentFile);
            print('📸 Image fallback to local storage successful');
          } catch (localError) {
            setState(() {
              _errorMessage = 'Failed to save image. Please try again.';
              _isLoading = false;
            });
          }
        }
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

  Future<String> _uploadToSupabase(File imageFile) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Determine bucket and create file path
    final bucketName = (widget.documentType == 'profile') ? 'profile-pictures' : 'vendor-documents';
    final fileName = '${widget.documentType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${user.id}/$fileName';

    print('🔵 Uploading to bucket: $bucketName, path: $filePath');

    // Upload to Supabase Storage
    await Supabase.instance.client.storage
        .from(bucketName)
        .upload(filePath, imageFile, fileOptions: const FileOptions(upsert: true));

    // Get public URL
    final String publicUrl = Supabase.instance.client.storage
        .from(bucketName)
        .getPublicUrl(filePath);

    print('🟢 Upload successful. URL: $publicUrl');
    return publicUrl;
  }
} 