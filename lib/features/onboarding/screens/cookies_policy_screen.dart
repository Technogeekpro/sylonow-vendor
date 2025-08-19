import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_theme.dart';

class CookiesPolicyScreen extends StatefulWidget {
  const CookiesPolicyScreen({super.key});

  @override
  State<CookiesPolicyScreen> createState() => _CookiesPolicyScreenState();
}

class _CookiesPolicyScreenState extends State<CookiesPolicyScreen> 
    with TickerProviderStateMixin {
  bool _isAccepted = false;
  bool _isLoading = false;
  bool _webViewLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  
  late final WebViewController _webViewController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _setStatusBarColor();
    _checkPreviousAcceptance();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _webViewLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _webViewLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _webViewLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _webViewLoading = false;
              _hasError = true;
              _errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('sylonow.com')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.sylonow.com/vendor/cookies-policy'));
  }

  Future<void> _checkPreviousAcceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasAccepted = prefs.getBool('cookies_policy_accepted') ?? false;
      if (mounted) {
        setState(() {
          _isAccepted = hasAccepted;
        });
      }
    } catch (e) {
      // Handle silently
    }
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    _slideController.forward();
  }

  void _setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // WebView Content
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [AppTheme.cardShadow],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              if (_hasError)
                                _buildErrorWidget()
                              else
                                WebViewWidget(controller: _webViewController),
                              
                              if (_webViewLoading)
                                _buildWebViewLoadingWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Acceptance Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildAcceptanceSection(),
                          const SizedBox(height: 20),
                          _buildContinueButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              const Expanded(
                child: Text(
                  'Cookies Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 48), // To balance the back button
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Please read and accept our Cookies Policy to continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewLoadingWidget() {
    return Container(
      color: AppTheme.surfaceColor,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Loading Cookies Policy...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.surfaceColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to Load Content',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection and try again.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _webViewLoading = true;
                });
                _webViewController.reload();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptanceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isAccepted ? AppTheme.primaryColor : AppTheme.borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isAccepted = !_isAccepted;
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _isAccepted ? AppTheme.primaryColor : Colors.transparent,
                border: Border.all(
                  color: _isAccepted ? AppTheme.primaryColor : AppTheme.borderColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: _isAccepted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'I have read and agree to the Cookies Policy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_isAccepted && !_isLoading) ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isAccepted ? AppTheme.primaryColor : AppTheme.borderColor,
          foregroundColor: Colors.white,
          elevation: _isAccepted ? 4 : 0,
          shadowColor: _isAccepted ? AppTheme.primaryColor.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Accept & Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isAccepted ? Colors.white : AppTheme.textSecondaryColor,
                ),
              ),
      ),
    );
  }

  void _handleContinue() async {
    if (_isAccepted && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Save acceptance to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('cookies_policy_accepted', true);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Cookies Policy accepted successfully!'),
                ],
              ),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          
          // Navigate back to welcome screen after short delay
          await Future.delayed(const Duration(milliseconds: 1500));
          if (mounted) {
            context.pop();
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving preferences: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }
}