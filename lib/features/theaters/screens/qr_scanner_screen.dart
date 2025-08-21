import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';

class QRScannerScreen extends ConsumerStatefulWidget {
  final String bookingId;
  
  const QRScannerScreen({
    super.key,
    required this.bookingId,
  });

  @override
  ConsumerState<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends ConsumerState<QRScannerScreen> {
  MobileScannerController? controller;
  bool _isProcessing = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Scan QR Code',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: HeroIcon(
              _flashOn ? HeroIcons.lightBulb : HeroIcons.lightBulb,
              color: _flashOn ? Colors.yellow : Colors.white,
              size: 24,
            ),
            onPressed: () async {
              await controller?.toggleTorch();
              setState(() {
                _flashOn = !_flashOn;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller!,
                  onDetect: _onDetect,
                ),
                // Custom overlay for scanning area
                _buildScannerOverlay(),
                if (_isProcessing)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Verifying booking...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HeroIcon(
                    HeroIcons.qrCode,
                    color: Colors.white70,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Scan QR Code to Verify Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Position the QR code within the frame to verify the booking and mark it as completed.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.textSecondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const HeroIcon(HeroIcons.xMark, size: 18),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    
    final String? code = barcodes.first.rawValue;
    if (code == null) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      await _processQRData(code);
    } catch (e) {
      print('🔴 QR Scanner: Error processing QR data: $e');
      _showErrorDialog('Failed to process QR code: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Widget _buildScannerOverlay() {
    const cutOutSize = 300.0;
    const borderLength = 30.0;
    const borderWidth = 4.0;
    
    return Stack(
      children: [
          // Dark overlay with transparent center
          Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(color: Colors.black54),
                ),
                Container(
                  height: cutOutSize,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(child: Container(color: Colors.black54)),
                      Container(
                        width: cutOutSize,
                        color: Colors.transparent,
                      ),
                      Expanded(child: Container(color: Colors.black54)),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(color: Colors.black54),
                ),
              ],
            ),
          ),
          // Corner borders
          Center(
            child: SizedBox(
              width: cutOutSize,
              height: cutOutSize,
              child: Stack(
                children: [
                  // Top-left corner
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: borderLength,
                      height: borderWidth,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: borderWidth,
                      height: borderLength,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  // Top-right corner
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: borderLength,
                      height: borderWidth,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: borderWidth,
                      height: borderLength,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  // Bottom-left corner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: borderLength,
                      height: borderWidth,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: borderWidth,
                      height: borderLength,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  // Bottom-right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: borderLength,
                      height: borderWidth,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: borderWidth,
                      height: borderLength,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }

  Future<void> _processQRData(String? qrData) async {
    if (qrData == null || qrData.isEmpty) {
      _showErrorDialog('Invalid QR code');
      return;
    }

    print('🔍 QR Scanner: Scanned data: $qrData');

    // Stop camera to prevent multiple scans
    await controller?.stop();

    try {
      // Parse QR data - expect booking ID or booking verification data
      final isValidBooking = await _verifyBookingQR(qrData);
      
      if (isValidBooking) {
        _showSuccessDialog();
      } else {
        _showErrorDialog('Invalid booking QR code');
        await controller?.start();
      }
    } catch (e) {
      print('🔴 QR Scanner: Verification error: $e');
      _showErrorDialog('Verification failed: ${e.toString()}');
      await controller?.start();
    }
  }

  Future<bool> _verifyBookingQR(String qrData) async {
    // Simple verification - check if QR data contains the booking ID
    // In a real implementation, this could be more sophisticated with encrypted tokens
    
    // For this implementation, we'll accept:
    // 1. Just the booking ID
    // 2. A JSON string containing the booking ID
    // 3. A URL with booking ID parameter
    
    if (qrData == widget.bookingId) {
      return true;
    }
    
    if (qrData.contains(widget.bookingId)) {
      return true;
    }
    
    // Try to parse as JSON
    try {
      final data = qrData.toLowerCase();
      if (data.contains('booking') && data.contains(widget.bookingId.toLowerCase())) {
        return true;
      }
    } catch (e) {
      print('🔍 QR Scanner: Not JSON format: $e');
    }
    
    return false;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppTheme.surfaceColor,
        title: const Row(
          children: [
            HeroIcon(
              HeroIcons.checkCircle,
              color: AppTheme.successColor,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Booking Verified!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        content: const Text(
          'The booking has been successfully verified and will be marked as completed.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(true); // Return true to indicate successful verification
            },
            child: const Text(
              'Complete Booking',
              style: TextStyle(
                color: AppTheme.successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppTheme.surfaceColor,
        title: const Row(
          children: [
            HeroIcon(
              HeroIcons.exclamationTriangle,
              color: AppTheme.errorColor,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Verification Failed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}