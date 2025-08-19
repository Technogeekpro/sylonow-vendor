import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_theme.dart';

class LegalWebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  
  const LegalWebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<LegalWebViewScreen> createState() => _LegalWebViewScreenState();
}

class _LegalWebViewScreenState extends State<LegalWebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              hasError = true;
              errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow navigation to the original URL and sylonow.com domain
            if (request.url.contains('sylonow.com')) {
              return NavigationDecision.navigate;
            }
            // Block navigation to external sites
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isLoading && !hasError)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                controller.reload();
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          if (hasError)
            _buildErrorWidget()
          else
            WebViewWidget(controller: controller),
          
          if (isLoading)
            _buildLoadingWidget(),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: AppTheme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [AppTheme.cardShadow],
              ),
              child: const CircularProgressIndicator(
                color: AppTheme.primaryColor,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading ${widget.title}...',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please wait while we fetch the latest information',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Unable to Load Content',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'We couldn\'t load the ${widget.title.toLowerCase()}. Please check your internet connection and try again.',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.borderColor,
                  ),
                ),
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondaryColor,
                      side: const BorderSide(color: AppTheme.borderColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        hasError = false;
                        isLoading = true;
                      });
                      controller.reload();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}