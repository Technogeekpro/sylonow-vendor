import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildPolicyContent(),
                      const SizedBox(height: 30),
                      _buildAcceptanceSection(),
                      const SizedBox(height: 30),
                      _buildContinueButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
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

  Widget _buildPolicyContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Cookies Policy – Vendor Application'),
          _buildEffectiveDate(),
          const SizedBox(height: 16),
          _buildIntroduction(),
          const SizedBox(height: 16),
          _buildSection('1. What Are Cookies?', _getCookiesDefinition()),
          _buildSection('2. Why We Use Cookies', _getWhyWeUseCookies()),
          _buildSection('3. Types of Cookies We Use', _getTypesOfCookies()),
          _buildSection('4. Third-Party Cookies', _getThirdPartyCookies()),
          _buildSection('5. Managing Cookies', _getManagingCookies()),
          _buildSection('6. Data Collection and Privacy', _getDataCollection()),
          _buildSection('7. Policy Updates', _getPolicyUpdates()),
          _buildSection('8. Contact Us', _getContactInfo()),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildEffectiveDate() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Effective Date: 26/05/2025',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildIntroduction() {
    return const Text(
      'This Cookies Policy explains how the Vendor Application ("we", "our", or "us") uses cookies and similar technologies to recognize you when you use our mobile application or services. This policy applies solely to vendors accessing and using our vendor platform via the Vendor App.',
      style: TextStyle(
        fontSize: 14,
        color: AppTheme.textSecondaryColor,
        height: 1.5,
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
            height: 1.5,
          ),
        ),
      ],
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

  // Content methods
  String _getCookiesDefinition() {
    return 'Cookies are small text files that are stored on your device when you access a website or application. They help enhance user experience, improve performance, and collect information regarding usage patterns.\n\nIn our mobile application, we may use cookies and similar technologies like software development kits (SDKs), pixels, beacons, and local storage to store and access data for a smoother and more secure vendor experience.';
  }

  String _getWhyWeUseCookies() {
    return 'We use cookies and similar technologies for the following purposes:\n\n• Authentication: To recognize and log in registered vendors securely.\n• Security: To help detect and prevent fraud, unauthorized access, and to ensure safe vendor operations.\n• Preferences: To remember your settings and preferences such as language, location, and app behavior.\n• Analytics: To collect data about app usage and performance for internal analysis and improvement.\n• Support Services: To enable features such as in-app support, chat systems, and notification delivery.';
  }

  String _getTypesOfCookies() {
    return 'a. Strictly Necessary Cookies\nThese are essential for the operation of the Vendor App. Without these, the app may not function properly.\n\nb. Performance & Analytics Cookies\nThese cookies collect information on how vendors use the app to help us improve its performance. All data collected is anonymized.\n\nc. Functional Cookies\nThese cookies enable the app to remember choices you make (e.g., business category, preferred city) and provide enhanced features.\n\nd. Targeting/Advertising Cookies\nCurrently, no third-party advertisements are used in the Vendor App. If this changes, this section will be updated and vendors will be notified.';
  }

  String _getThirdPartyCookies() {
    return 'We may allow trusted third-party service providers (e.g., Google Analytics for Firebase, Razorpay) to place cookies or similar tracking technologies. These services help us:\n\n• Monitor app usage and errors\n• Process payments\n• Improve overall user experience\n\nThird-party cookies are governed by the privacy policies of the respective providers.';
  }

  String _getManagingCookies() {
    return 'By using the Vendor App, you consent to our use of cookies. You may disable or delete cookies by adjusting your mobile device settings. However, please note that disabling cookies may limit certain functionalities or result in reduced app performance.\n\nNote: For Android and iOS users, managing cookie preferences may depend on your OS version and device manufacturer.';
  }

  String _getDataCollection() {
    return 'All data collected through cookies and tracking technologies is handled as per our Vendor Privacy Policy, in compliance with:\n\n• The Information Technology Act, 2000\n• The Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Data or Information) Rules, 2011\n• Applicable sectoral regulations';
  }

  String _getPolicyUpdates() {
    return 'We may update this Cookies Policy from time to time. You will be notified of any material changes through the app or by email.';
  }

  String _getContactInfo() {
    return 'For questions, concerns, or requests regarding this Cookies Policy, please contact our Data Protection Officer (DPO) at:\n\nEmail: info@sylonow.com\nAddress: JP Nagar Bengaluru 560078\nPhone: 9480709432';
  }
} 