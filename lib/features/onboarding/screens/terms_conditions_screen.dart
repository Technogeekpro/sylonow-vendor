import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
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
          'Terms & Conditions',
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
                    'Terms and Conditions',
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
                    'Effective Date: [Insert Launch Date]\nApplicable Jurisdiction: India\nCompany: Sylonow Vision Private Limited',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Terms Content
            _buildSection(
              '1. Acceptance of Terms',
              'By registering and using the Sylonow Vendor App ("App"), you ("Vendor") agree to comply with and be bound by these Terms and Conditions, the Privacy Policy, and the Cookies Policy. If you disagree with any part of the terms, you may not use the platform.',
            ),
            
            _buildSection(
              '2. Definitions',
              '• Sylonow: The celebration and surprise event platform operated by Sylonow Vision Private Limited.\n'
              '• Vendor: A service provider who accepts and fulfills orders placed by customers via the Sylonow platform.\n'
              '• Customer: A person or entity who books decoration or surprise services.\n'
              '• App: The official Sylonow Vendor Application available for Android and iOS.',
            ),
            
            _buildSection(
              '3. Vendor Responsibilities',
              'Step 1: New Order Notification\n'
              '• Vendors receive real-time alerts for new bookings.\n'
              '• Vendor must accept/reject within 15 minutes.\n'
              '• If rejected or unaccepted, the booking is:\n'
              '  ○ Reassigned to another vendor, OR\n'
              '  ○ Listed in an open marketplace for others to accept.\n\n'
              'Step 2: Order Acceptance & Execution\n'
              '• Upon acceptance:\n'
              '  ○ Full event details are visible.\n'
              '  ○ Vendor must arrive before the scheduled slot.\n'
              '  ○ Google Maps navigation is recommended.\n\n'
              'Step 3: Security Check via QR Code\n'
              '• On arrival:\n'
              '  ○ Vendor must scan the customer\'s QR code for validation.\n'
              '  ○ Customer will scan vendor\'s QR code for cross-verification.\n'
              '  ○ No service shall begin without mutual QR verification.\n\n'
              'Step 4: Decoration Setup & Completion\n'
              '• Perform setup as per booking.\n'
              '• Upload Before & After pictures via the app.\n'
              '• Mark job status as "Completed" after verification.\n\n'
              'Step 5: Payment & Rating\n'
              '• Earnings are transferred to the Vendor Wallet upon task completion.\n'
              '• Payouts can be withdrawn anytime (subject to wallet balance).\n'
              '• Customer provides ratings/reviews, influencing future job opportunities.',
            ),
            
            _buildSection(
              '4. Payment Structure',
              '• Payment percentages (e.g., customer pays 60% upfront) are not the vendor\'s responsibility unless explicitly mentioned.\n'
              '• Vendors are paid only upon task completion and confirmation.\n'
              '• No offline or direct payments to vendors are allowed.',
            ),
            
            _buildSection(
              '5. Cancellation & Compensation',
              '• If customer cancels less than 5 hours before the scheduled time:\n'
              '  ○ No compensation to vendor unless vendor was already at the location with evidence.\n'
              '• If vendor cancels after accepting:\n'
              '  ○ May result in temporary suspension or permanent ban based on history and severity.\n'
              '• Vendors must not cancel accepted orders without valid reasons.',
            ),
            
            _buildSection(
              '6. Use of App & Account',
              '• Vendors must maintain accurate business profiles.\n'
              '• Must not share login credentials or impersonate others.\n'
              '• Misuse of the platform, fraudulent claims, or tampering with app functionalities will lead to termination without payment.',
            ),
            
            _buildSection(
              '7. Liability & Indemnification',
              '• Sylonow is not liable for:\n'
              '  ○ Damage/loss to vendor equipment.\n'
              '  ○ Any criminal acts or negligence committed by the vendor.\n'
              '• Vendor agrees to:\n'
              '  ○ Conduct themselves professionally.\n'
              '  ○ Be solely responsible for actions during service execution.\n'
              '• In case of legal disputes or claims, the vendor shall indemnify Sylonow against any damage, cost, or legal fees incurred.',
            ),
            
            _buildSection(
              '8. Data Sharing & Privacy',
              '• Vendor\'s location, rating, and task history may be shared with customers for transparency.\n'
              '• Personal data is handled as per our Privacy Policy.',
            ),
            
            _buildSection(
              '9. Intellectual Property',
              '• All branding, UI/UX, and process flows belong to Sylonow Vision Private Limited.\n'
              '• Vendors must not replicate or use proprietary content elsewhere.',
            ),
            
            _buildSection(
              '10. Compliance & Conduct',
              '• Vendors must comply with:\n'
              '  ○ Indian Contract Act, 1872\n'
              '  ○ Indian IT Act, 2000\n'
              '  ○ Labour laws where applicable.\n'
              '• Misconduct such as:\n'
              '  ○ Harassment,\n'
              '  ○ Abuse,\n'
              '  ○ Theft, or\n'
              '  ○ Disrespect toward customers\n'
              '— will result in a lifetime ban and legal consequences.',
            ),
            
            _buildSection(
              '11. Termination',
              '• Sylonow may terminate vendor accounts:\n'
              '  ○ Upon repeated customer complaints.\n'
              '  ○ For breach of these Terms.\n'
              '  ○ For system misuse or fraud.',
            ),
            
            _buildSection(
              '12. Governing Law',
              '• These Terms are governed by the laws of India.\n'
              '• All disputes shall be subject to exclusive jurisdiction of Bengaluru courts.',
            ),
            
            _buildSection(
              '13. Dispute Resolution',
              '• Disputes shall first be resolved through internal grievance redressal.\n'
              '• If unresolved, parties may proceed to binding arbitration in Bengaluru, per the Arbitration and Conciliation Act, 1996.',
            ),
            
            _buildSection(
              '14. Contact Information',
              'For legal notices or complaints:\n'
              'Email: info@sylonow.com\n'
              'Registered Office: JP Nagar Bengaluru 560078',
            ),
            
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
} 