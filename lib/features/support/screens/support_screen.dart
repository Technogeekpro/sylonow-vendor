import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Support Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.pink, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our support team is here to help you 24/7',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Contact support
                      _contactSupport(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Contact Support',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick Help Options
            const Text(
              'Quick Help',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Only Call Us option, no Live Chat
            _buildQuickHelpCard(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '+91 98765 43210',
              color: Colors.green,
              onTap: () {
                // Make phone call
                _makePhoneCall('+919876543210');
              },
            ),
            const SizedBox(height: 32),
            
            // Help Categories
            const Text(
              'Help Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHelpOption(
                    icon: Icons.account_circle,
                    title: 'Account & Profile',
                    subtitle: 'Manage your account settings',
                    onTap: () {
                      // Navigate to account help
                      _showAccountHelpDialog(context);
                    },
                  ),
                  _buildDivider(),
                  _buildHelpOption(
                    icon: Icons.shopping_bag,
                    title: 'Orders & Bookings',
                    subtitle: 'Help with orders and bookings',
                    onTap: () {
                      // Navigate to orders help
                      _showOrdersHelpDialog(context);
                    },
                  ),
                  _buildDivider(),
                  _buildHelpOption(
                    icon: Icons.payment,
                    title: 'Payments & Wallet',
                    subtitle: 'Payment and wallet related queries',
                    onTap: () {
                      // Navigate to payment help
                      _showPaymentHelpDialog(context);
                    },
                  ),
                  _buildDivider(),
                  _buildHelpOption(
                    icon: Icons.verified_user,
                    title: 'Verification',
                    subtitle: 'Document verification help',
                    onTap: () {
                      // Navigate to verification help
                      _showVerificationHelpDialog(context);
                    },
                  ),
                  _buildDivider(),
                  _buildHelpOption(
                    icon: Icons.report_problem,
                    title: 'Report an Issue',
                    subtitle: 'Report technical or service issues',
                    onTap: () {
                      // Navigate to report issue
                      _showReportIssueDialog(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildFAQItem(
                    question: 'How do I get verified as a vendor?',
                    answer: 'Complete your profile, upload required documents, and wait for verification.',
                  ),
                  _buildDivider(),
                  _buildFAQItem(
                    question: 'How do I withdraw money from my wallet?',
                    answer: 'Go to Wallet > Withdraw and follow the instructions to transfer money to your bank.',
                  ),
                  _buildDivider(),
                  _buildFAQItem(
                    question: 'How do I update my service areas?',
                    answer: 'Go to Profile > Business Details to update your service areas and types.',
                  ),
                  _buildDivider(),
                  _buildFAQItem(
                    question: 'What should I do if I face payment issues?',
                    answer: 'Contact our support team immediately with your order details for quick resolution.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.pink,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      iconColor: Colors.pink,
      collapsedIconColor: Colors.grey,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) {
    // Implement the logic to make a phone call
    launchUrl(Uri.parse('tel:$phoneNumber'));
  }

  void _contactSupport(BuildContext context) {
    // Implement the logic to contact support
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text('Choose how you\'d like to contact our support team:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _makePhoneCall('+919876543210');
            },
            child: const Text('Call Us'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              launchUrl(Uri.parse('mailto:support@sylonow.com?subject=Vendor Support Request'));
            },
            child: const Text('Email Us'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAccountHelpDialog(BuildContext context) {
    // Implement the logic to show account help dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account & Profile Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• How to update your profile information'),
              SizedBox(height: 8),
              Text('• Managing your account settings'),
              SizedBox(height: 8),
              Text('• Changing your password'),
              SizedBox(height: 8),
              Text('• Account verification process'),
              SizedBox(height: 8),
              Text('• Deactivating your account'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showOrdersHelpDialog(BuildContext context) {
    // Implement the logic to show orders help dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Orders & Bookings Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Managing incoming booking requests'),
              SizedBox(height: 8),
              Text('• Accepting or declining orders'),
              SizedBox(height: 8),
              Text('• Updating order status'),
              SizedBox(height: 8),
              Text('• Communicating with customers'),
              SizedBox(height: 8),
              Text('• Handling cancellations and refunds'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPaymentHelpDialog(BuildContext context) {
    // Implement the logic to show payment help dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payments & Wallet Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Understanding your wallet balance'),
              SizedBox(height: 8),
              Text('• Withdrawing funds to your bank account'),
              SizedBox(height: 8),
              Text('• Payment processing and fees'),
              SizedBox(height: 8),
              Text('• Transaction history and receipts'),
              SizedBox(height: 8),
              Text('• Resolving payment disputes'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVerificationHelpDialog(BuildContext context) {
    // Implement the logic to show verification help dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Required documents for verification'),
              SizedBox(height: 8),
              Text('• Photo quality requirements'),
              SizedBox(height: 8),
              Text('• Verification timeline and process'),
              SizedBox(height: 8),
              Text('• What to do if verification is rejected'),
              SizedBox(height: 8),
              Text('• Updating verified documents'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    // Implement the logic to show report issue dialog
    final TextEditingController issueController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report an Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please describe the issue you\'re experiencing:'),
            const SizedBox(height: 16),
            TextField(
              controller: issueController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe your issue here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would typically send the issue to your backend
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Issue reported successfully! We\'ll get back to you soon.'),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
} 