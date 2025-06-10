# Image Upload System - Implementation Guide

## Overview
The image upload system has been completely revamped to use proper Supabase storage buckets with appropriate security policies, signed URLs for private content, and better error handling.

## Storage Architecture

### Buckets Configuration

#### 1. Profile Pictures Bucket (`profile-pictures`)
- **Bucket Name**: `profile-pictures`
- **Public Access**: `true` (images are publicly readable)
- **File Size Limit**: 10MB
- **Allowed MIME Types**: `image/jpeg`, `image/png`, `image/jpg`, `image/webp`
- **Use Case**: Vendor profile pictures that need to be publicly accessible
- **URL Type**: **Public URLs** (never expire)

#### 2. Vendor Documents Bucket (`vendor-documents`)
- **Bucket Name**: `vendor-documents`
- **Public Access**: `false` (private with RLS policies)
- **File Size Limit**: 50MB
- **Allowed MIME Types**: `image/jpeg`, `image/png`, `image/jpg`, `application/pdf`
- **Use Case**: Legal documents (Aadhaar, PAN, etc.) that need privacy protection
- **URL Type**: **Signed URLs** (expire after set time for security)

## URL Generation Strategy

### Public URLs vs Signed URLs

**Profile Pictures (Public Bucket)**
- Uses `getPublicUrl()` method
- URLs never expire
- Directly accessible by anyone
- Example: `https://project.supabase.co/storage/v1/object/public/profile-pictures/user_id/file.jpg`

**Vendor Documents (Private Bucket)**
- Uses `createSignedUrl()` method
- URLs have expiration time (1 year for storage, 1 hour for viewing)
- Only accessible by authenticated users who own the files
- Example: `https://project.supabase.co/storage/v1/object/sign/vendor-documents/user_id/file.jpg?token=xyz`

## Storage Policies

### Profile Pictures Bucket Policies
1. **Upload**: Authenticated users can upload to their own folder (`/user_id/`)
2. **Read**: Public read access (anyone can view via public URL)
3. **Update**: Users can update their own profile pictures
4. **Delete**: Users can delete their own profile pictures

### Vendor Documents Bucket Policies
1. **Upload**: Authenticated users can upload to their own folder (`/user_id/`)
2. **Read**: Users can only read their own documents
3. **Update**: Users can update their own documents
4. **Delete**: Users can delete their own documents

## File Organization Structure

```
profile-pictures/
├── user_id_1/
│   └── profile_timestamp_filename.jpg
├── user_id_2/
│   └── profile_timestamp_filename.png
└── ...

vendor-documents/
├── user_id_1/
│   ├── aadhaar_timestamp_front.jpg
│   ├── aadhaar_timestamp_back.jpg
│   └── pan_timestamp_card.jpg
├── user_id_2/
│   └── ...
└── ...
```

## Implementation Details

### VendorService.uploadImage()
The `uploadImage` method automatically determines the correct bucket, URL type, and security settings based on the image type:

```dart
Future<String> uploadImage(File imageFile, String imageType) async {
  // Auto-routing logic:
  // 'profile' -> profile-pictures bucket (public URLs)
  // 'aadhaar', 'pan', 'documents' -> vendor-documents bucket (signed URLs)
}
```

**Supported Image Types:**
- `'profile'` → Profile Pictures Bucket (Public URLs)
- `'aadhaar'` → Vendor Documents Bucket (Signed URLs - 1 year expiry)
- `'pan'` → Vendor Documents Bucket (Signed URLs - 1 year expiry)
- `'documents'` → Vendor Documents Bucket (Signed URLs - 1 year expiry)

### URL Refresh for Private Documents

#### VendorService.getSignedUrlForDocument()
Generates fresh signed URLs for viewing private documents:
```dart
Future<String> getSignedUrlForDocument(String documentUrl) async {
  // Generates 1-hour signed URL for document viewing
}
```

#### VendorService.getVendorDocumentUrls()
Batch refresh all vendor document URLs:
```dart
Future<Map<String, String>> getVendorDocumentUrls({
  String? profilePictureUrl,
  String? aadhaarFrontUrl,
  String? aadhaarBackUrl,
  String? panCardUrl,
}) async {
  // Returns fresh viewable URLs for all documents
}
```

### Enhanced ImageUploadWidget
The image upload widget now includes:
- **Loading States**: Shows spinner during image processing
- **Error Handling**: Displays specific error messages
- **File Validation**: Checks file size (10MB limit) and type (JPG/PNG only)
- **Visual Feedback**: Different UI states for success, error, and loading
- **Better UX**: Higher quality image compression for documents

## Security Features

1. **Authentication Required**: All uploads require authenticated users
2. **User Isolation**: Users can only access their own files
3. **Type Validation**: File types are restricted at bucket level
4. **Size Limits**: Prevents abuse with file size restrictions
5. **Path Security**: User ID is automatically included in file paths
6. **URL Expiration**: Private document URLs expire for additional security
7. **RLS Policies**: Row-level security prevents unauthorized access

## URL Expiration Handling

### Storage URLs (Long-term)
- **Profile Pictures**: Never expire (public URLs)
- **Vendor Documents**: 1 year expiry (for database storage)

### Viewing URLs (Short-term)
- **Profile Pictures**: Never expire (public URLs)
- **Vendor Documents**: 1 hour expiry (for app display)

### Refresh Strategy
```dart
// When displaying documents in UI, always refresh signed URLs
final vendorService = ref.read(vendorServiceProvider);
final viewableUrls = await vendorService.getVendorDocumentUrls(
  profilePictureUrl: vendor.profilePicture,
  aadhaarFrontUrl: vendor.aadhaarFrontImage,
  aadhaarBackUrl: vendor.aadhaarBackImage,
  panCardUrl: vendor.panCardImage,
);
```

## Error Handling

### Common Errors and Solutions

1. **RLS Policy Violation**
   ```
   Error: row-level security policy
   ```
   **Solution**: Ensure user is authenticated and `auth.uid()` matches the folder structure.

2. **File Size Too Large**
   ```
   Error: payload too large
   ```
   **Solution**: Check file size limits (10MB for profile pictures, 50MB for documents).

3. **Invalid File Type**
   ```
   Error: Invalid file type
   ```
   **Solution**: Only JPG, PNG, and WEBP files are allowed.

4. **Signed URL Expired**
   ```
   Error: 403 Forbidden or URL not accessible
   ```
   **Solution**: Use `getSignedUrlForDocument()` to generate fresh URLs.

5. **Duplicate File**
   ```
   Error: Duplicate
   ```
   **Solution**: Upload uses `upsert: true` to automatically handle overwrites.

## Usage Examples

### Uploading Profile Picture
```dart
final vendorService = ref.read(vendorServiceProvider);
final profileUrl = await vendorService.uploadImage(
  profileImageFile, 
  'profile' // Routes to profile-pictures bucket (public URL)
);
```

### Uploading Document
```dart
final vendorService = ref.read(vendorServiceProvider);
final documentUrl = await vendorService.uploadImage(
  aadhaarImageFile, 
  'aadhaar' // Routes to vendor-documents bucket (signed URL)
);
```

### Displaying Documents in UI
```dart
// Always refresh document URLs before displaying
final vendorService = ref.read(vendorServiceProvider);
final viewableUrls = await vendorService.getVendorDocumentUrls(
  aadhaarFrontUrl: vendor.aadhaarFrontImage,
);

// Use the fresh URL for display
Image.network(viewableUrls['aadhaarFront']!)
```

## Testing Checklist

- [ ] Profile picture upload works correctly (public URLs)
- [ ] Document uploads (Aadhaar front/back, PAN) work correctly (signed URLs)
- [ ] File size validation triggers for files > 10MB
- [ ] Invalid file types are rejected
- [ ] Error messages are user-friendly
- [ ] Loading states display properly
- [ ] Uploaded images display correctly in UI
- [ ] Public URLs work for profile pictures (never expire)
- [ ] Signed URLs work for documents (with expiration)
- [ ] Document privacy is maintained (only user can access)
- [ ] URL refresh works for expired signed URLs

## Troubleshooting

### Enable Debug Logging
The system includes comprehensive logging. Look for these log patterns:
- `🔵` - Information/Process logs
- `🟢` - Success logs
- `🔴` - Error logs
- `📸` - Image widget specific logs

### Common Issues

1. **Images not showing in UI**: 
   - For profiles: Check if public URL is correct
   - For documents: Use `getSignedUrlForDocument()` to refresh expired URLs
2. **Upload fails silently**: Check console logs for detailed error messages
3. **RLS errors**: Verify user authentication and bucket policies
4. **File too large**: Increase bucket file size limits if needed
5. **Document URLs show 403 error**: Signed URLs have expired, refresh them

## Future Enhancements

- [ ] Add image compression before upload
- [ ] Implement progress indicators for large files
- [ ] Add support for multiple file selection
- [ ] Implement image cropping functionality
- [ ] Add automatic image orientation correction
- [ ] Add URL caching with expiration awareness
- [ ] Implement background URL refresh for long-lived apps 