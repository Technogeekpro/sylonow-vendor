import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class RevenuePolicyScreen extends StatefulWidget {
  const RevenuePolicyScreen({super.key});

  @override
  State<RevenuePolicyScreen> createState() => _RevenuePolicyScreenState();
}

class _RevenuePolicyScreenState extends State<RevenuePolicyScreen> {
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
          'Revenue & Commission Policy',
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
                    'Sylonow Revenue & Commission Policy (EUL)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'For Registered Vendors (Decorators, Cafes, Hybrid Providers)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Effective Date: 26/05/2025\nGoverning Law: Applicable laws of India',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Policy Content
            _buildSection(
              '1. Introduction',
              'This policy outlines the framework under which vendors using the Sylonow platform (Vendor App) earn revenue, pay commissions, and receive payouts. By registering as a vendor, you ("Vendor") agree to abide by the terms of this policy and other agreements entered into with Sylonow Vision Private Limited ("Sylonow", "we", "our", "us").',
            ),
            
            _buildSection(
              '2. Revenue Distribution',
              '2.1 Total Order Value (TOV):\n'
              'Total Order Value is defined as the complete amount paid by the customer for a particular booking on the Sylonow platform, inclusive of GST but exclusive of convenience/service charges and fast delivery fees.\n\n'
              '2.2 Vendor Share:\n'
              '• Vendors will receive 95% of the TOV (excluding taxes).\n'
              '• Sylonow retains 5% as platform commission.\n'
              '• In certain high-demand events or strategic campaigns, Sylonow may apply dynamic commissions up to 8% with prior intimation via written communication or in-app notification.',
            ),
            
            _buildHighlightSection(
              'Vendor Earnings',
              '95% of Total Order Value',
              'Platform Commission: 5%',
              AppTheme.successColor,
            ),
            
            _buildSection(
              '3. Additional Charges (Non-Shareable)',
              '3.1 Fast Service Fee:\n'
              'If the customer opts for a service that must be executed within 2 hours, a Fast Service Fee is charged.\n'
              '• This fee is non-commissionable and retained 100% by Sylonow.\n'
              '• The vendor is compensated only based on the TOV.\n\n'
              '3.2 Convenience/Platform Fee:\n'
              'Any service, platform, or convenience fee applied to the customer invoice is exclusively for system maintenance and customer support.\n'
              '• These are not part of Vendor earnings.',
            ),
            
            _buildSection(
              '4. Vendor Wallet & Payment Schedule',
              '4.1 Earnings Update:\n'
              'Once the task is marked completed by the customer or auto-confirmed after 3 hours, the vendor\'s wallet is credited.\n\n'
              '4.2 Withdrawal Timeline:\n'
              '• Vendors may raise a withdrawal request any time.\n'
              '• Payouts are processed within 3–5 working days through IMPS/NEFT/UPI.\n'
              '• Sylonow is not liable for delays caused by incorrect bank details, public holidays, or third-party payment gateways.',
            ),
            
            _buildSection(
              '5. Taxation & Compliance',
              '5.1 GST Compliance:\n'
              '• Vendors must provide a valid GSTIN if applicable.\n'
              '• Sylonow shall generate monthly GST-compliant invoices reflecting commission deducted.\n'
              '• Vendors are responsible for filing their GST returns based on their income.\n\n'
              '5.2 TDS (Tax Deducted at Source):\n'
              '• Sylonow may deduct TDS as per Section 194H or other applicable sections of the Income Tax Act.\n'
              '• TDS certificates will be issued quarterly as per law.',
            ),
            
            _buildPenaltyTable(),
            
            _buildSection(
              '7. Order Cancellations',
              '7.1 Customer-Initiated:\n'
              '• If the customer cancels more than 5 hours before the event, the vendor receives no payment or penalty.\n'
              '• If within 5 hours, vendor receives 60% of the agreed payout, and customer forfeits advance.\n\n'
              '7.2 Vendor-Initiated:\n'
              '• Cancellations must happen at least 6 hours before event.\n'
              '• For any cancellation within 3 hours, ₹100–₹500 is deducted from vendor wallet.\n'
              '• Repeated cancellations may lead to blacklisting or permanent removal.',
            ),
            
            _buildSection(
              '8. Refund Policy Impact on Vendors',
              '• Refunds initiated to the customer (e.g., due to vendor\'s fault) will result in proportionate deduction from vendor wallet.\n'
              '• If wallet has insufficient balance, future payouts will be adjusted.',
            ),
            
            _buildSection(
              '9. Fraud & Security Breaches',
              'Vendors found engaging in any of the following will face immediate termination and potential legal action:\n'
              '• Sharing confidential booking data\n'
              '• Accepting direct payments from customers outside the platform\n'
              '• Misuse of QR codes or impersonation\n'
              '• Theft or damage to property\n\n'
              'Sylonow will cooperate with police authorities and may file FIRs under the Indian Penal Code (IPC), if necessary.',
            ),
            
            _buildSection(
              '10. Dispute Resolution',
              '• Any disputes regarding payment or commissions must be raised within 7 days of the event.\n'
              '• Email: info@sylonow.com\n'
              '• Call: +91-9480709432\n'
              '• Disputes will be resolved within 5 business days.',
            ),
            
            _buildSection(
              '11. Legal Protections & Limitation of Liability',
              '• Sylonow is not liable for vendor behavior, on-ground execution errors, or theft, and shall not be sued for damages caused by third-party vendors.\n'
              '• Vendors agree not to take legal action against Sylonow for delays, cancellations, customer complaints, or payment delays caused by third-party systems.\n'
              '• All earnings are subject to verification, audit, and cancellation in case of fraud.\n'
              '• The vendor relationship is on a principal-to-principal basis. No employer-employee relationship is implied.',
            ),
            
            _buildSection(
              '12. Governing Law & Jurisdiction',
              'This Policy shall be governed by the laws of India. Any dispute arising out of or in connection with this Policy shall be subject to the exclusive jurisdiction of the courts in Bangalore, Karnataka, India.',
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

  Widget _buildHighlightSection(String title, String mainText, String subText, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mainText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: TextStyle(
              fontSize: 14,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyTable() {
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
          const Text(
            '6. Deductions & Penalties',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Table Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Violation',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Deduction',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Table Rows
          _buildTableRow('Late Arrival (>10 min)', '₹50', 'Per 10-minute block'),
          _buildTableRow('No-show or Unjustified Cancellation', '₹100–₹500', 'Based on damage severity'),
          _buildTableRow('Incomplete Service Execution', 'Up to 50% of payout withheld', 'Post investigation'),
          _buildTableRow('Misrepresentation or Fraud', 'Termination & legal action', 'FIR may be filed'),
          _buildTableRow('Low Rating (<2 stars repeatedly)', 'Visibility reduced', 'Reviewed quarterly'),
        ],
      ),
    );
  }

  Widget _buildTableRow(String violation, String deduction, String notes) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              violation,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              deduction,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              notes,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 