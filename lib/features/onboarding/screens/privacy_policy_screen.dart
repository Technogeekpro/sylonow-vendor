import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimaryColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sylonow Vendor App',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Effective Date: May 12, 2025\nLast Updated: May 12, 2025\nOwned by: Sylonow Vision Private Limited',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Privacy Policy Content
            _buildSection(
              '1. INTRODUCTION',
              'Sylonow Vision Private Limited ("Sylonow", "we", "us", or "our") is committed to safeguarding the privacy and security of your personal data. This Privacy Policy outlines how we collect, use, store, and share your data when you use the Sylonow Vendor App ("App"). By using the App, you agree to the collection and use of information in accordance with this policy.\n\n'
              'This policy is governed by the Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Data or Information) Rules, 2011, under the Information Technology Act, 2000 of India.',
            ),
            
            _buildSection(
              '2. INFORMATION WE COLLECT',
              'We collect the following types of information from vendors:\n\n'
              '2.1 Personal Information:\n'
              '• Full name\n'
              '• Business name and location\n'
              '• Mobile number\n'
              '• Email address\n'
              '• Profile image (optional)\n'
              '• GST number (for invoicing purposes)\n'
              '• PAN number (for tax compliance)\n\n'
              '2.2 Vendor-Specific Data:\n'
              '• Service categories (e.g., decorator, venue, catering)\n'
              '• Service-related data, including pricing and availability\n'
              '• Vendor operating hours\n'
              '• Bookings and order details\n\n'
              '2.3 Device & Usage Data:\n'
              '• Device information (e.g., device type, OS, version)\n'
              '• IP address\n'
              '• App usage logs (pages visited, actions taken, clicks, etc.)\n'
              '• Geolocation data (for delivery coordination)\n'
              '• Error logs and crash data\n\n'
              '2.4 Payment Data:\n'
              '• Payment details (processed via third-party payment providers, such as Razorpay, Paytm)\n'
              '• Invoices and transaction history',
            ),
            
            _buildSection(
              '3. HOW WE USE YOUR INFORMATION',
              'We use the information we collect to:\n'
              '• Register and maintain your vendor account\n'
              '• Process service bookings and manage customer interactions\n'
              '• Enable secure QR-based verification during service provision\n'
              '• Notify you of new orders, updates, and system changes\n'
              '• Manage payments and invoicing\n'
              '• Provide customer support\n'
              '• Analyze usage trends and improve app functionality\n'
              '• Send promotional offers and service updates (optional)\n'
              '• Comply with legal and regulatory obligations',
            ),
            
            _buildSection(
              '4. DATA SHARING AND DISCLOSURE',
              'We do not sell or rent your personal information. However, we may share your data under the following circumstances:\n'
              '• With customers: Customer-specific details (such as service, booking time, and location) may be shared to fulfill the booking.\n'
              '• With third-party service providers: For payment processing, cloud storage, SMS/email notifications, and app analytics.\n'
              '• For legal purposes: We may disclose information when required by law, a court order, or to protect legal rights.\n\n'
              'All third-party providers must comply with data protection regulations and are bound by confidentiality agreements.',
            ),
            
            _buildHighlightSection(
              '5. QR-BASED VENDOR VERIFICATION',
              'To ensure a secure service experience:\n'
              '• Vendors must scan a QR code provided by customers upon arrival for service verification.\n'
              '• Customer data will be shared only for verification purposes and will not be accessible post-service.\n'
              '• Sylonow will not be responsible for any issues related to the vendor\'s actions or the service post-QR verification.',
              AppTheme.warningColor,
            ),
            
            _buildSection(
              '6. DATA SECURITY',
              'We take the following measures to ensure the safety of your data:\n'
              '• Encryption: All sensitive data is encrypted during transmission and storage.\n'
              '• Access Control: Only authorized personnel have access to your personal and business data.\n'
              '• Two-Factor Authentication (2FA): For account security, we encourage the use of two-factor authentication during login.\n\n'
              'Despite our best efforts, no method of electronic transmission or storage is 100% secure. If there is a data breach, we will notify affected users within 72 hours as per legal requirements.',
            ),
            
            _buildSection(
              '7. COOKIES AND TRACKING TECHNOLOGY',
              'The app uses cookies and similar technologies to:\n'
              '• Improve app performance\n'
              '• Track usage patterns\n'
              '• Provide personalized content\n'
              '• Enable marketing campaigns (if opted-in)\n\n'
              'You can manage your cookie preferences through your browser settings.',
            ),
            
            _buildSection(
              '8. YOUR RIGHTS UNDER INDIAN LAW',
              'As per the Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Data or Information) Rules, 2011, you have the right to:\n'
              '• Access your personal information\n'
              '• Correct, update, or delete your data\n'
              '• Withdraw your consent at any time (this may limit functionality)\n'
              '• Request that we stop using your personal data for marketing purposes\n\n'
              'For exercising any of these rights, please contact us at: info@sylonow.com',
            ),
            
            _buildSection(
              '9. RETENTION OF DATA',
              'We retain your data for as long as your account is active, or as necessary to fulfill the purposes for which it was collected, including legal, tax, and accounting obligations.\n\n'
              'You may request data deletion by contacting us, and we will comply, except where retention is required for compliance with legal obligations.',
            ),
            
            _buildSection(
              '10. CHILDREN\'S PRIVACY',
              'The App is not intended for individuals under the age of 18, and we do not knowingly collect or store data from children. If we learn that we have inadvertently collected personal information from a child under 18, we will take steps to delete such information.',
            ),
            
            _buildSection(
              '11. CHANGES TO THIS PRIVACY POLICY',
              'We may revise this Privacy Policy periodically to reflect changes in our practices or for legal, regulatory, or operational reasons. All changes will be posted on this page with an updated "Last Updated" date.',
            ),
            
            _buildContactSection(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
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
      ),
    );
  }

  Widget _buildHighlightSection(String title, String content, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security_rounded,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: color.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.contact_support_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                '12. CONTACT US',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'For any questions or concerns regarding this Privacy Policy, or to request changes to your information, please contact us at:',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sylonow Vision Private Limited',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildContactItem(Icons.location_on_rounded, 'JP Nagar Bengaluru 560078'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.email_rounded, 'info@sylonow.com'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.phone_rounded, '9480709432'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
} 