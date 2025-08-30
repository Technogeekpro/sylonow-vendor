import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/admin_settings_provider.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportContactAsync = ref.watch(supportContactProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              const Text(
                'Get in touch with our support team',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 64),

              // Contact Options - Dynamic from Admin Settings
              supportContactAsync.when(
                data: (supportContact) => Column(
                  children: [
                    _buildContactCard(
                      context: context,
                      icon: HeroIcons.phone,
                      title: 'Call Us',
                      subtitle: supportContact['phone']!,
                      description: 'Available 24/7 for immediate assistance',
                      color: AppTheme.successColor,
                      onTap: () => _makePhoneCall(supportContact['phone']!),
                    ),

                    const SizedBox(height: 24),

                    _buildContactCard(
                      context: context,
                      icon: HeroIcons.envelope,
                      title: 'Email Us',
                      subtitle: supportContact['email']!,
                      description: 'We\'ll respond within 24 hours',
                      color: AppTheme.accentBlue,
                      onTap: () => _sendEmail(supportContact['email']!),
                    ),
                  ],
                ),
                loading: () => Column(
                  children: [
                    _buildLoadingCard('Phone Support'),
                    const SizedBox(height: 24),
                    _buildLoadingCard('Email Support'),
                  ],
                ),
                error: (error, stackTrace) => Column(
                  children: [
                    _buildContactCard(
                      context: context,
                      icon: HeroIcons.phone,
                      title: 'Call Us',
                      subtitle: '+91 98765 43210', // Fallback
                      description: 'Available 24/7 for immediate assistance',
                      color: AppTheme.successColor,
                      onTap: () => _makePhoneCall('+919876543210'),
                    ),

                    const SizedBox(height: 24),

                    _buildContactCard(
                      context: context,
                      icon: HeroIcons.envelope,
                      title: 'Email Us',
                      subtitle: 'support@sylonow.com', // Fallback
                      description: 'We\'ll respond within 24 hours',
                      color: AppTheme.accentBlue,
                      onTap: () => _sendEmail('support@sylonow.com'),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Footer
              const Text(
                'We\'re here to help you succeed!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required HeroIcons icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: HeroIcon(
                    icon,
                    size: 32,
                    color: color,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: HeroIcon(
                    HeroIcons.arrowRight,
                    size: 20,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    try {
      final Uri uri = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch phone dialer';
      }
    } catch (e) {
      print('Error making phone call: $e');
    }
  }

  void _sendEmail(String email) async {
    try {
      final Uri uri = Uri.parse(
          'mailto:$email?subject=Support Request - SyloNow Vendor App');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      print('Error opening email: $e');
    }
  }

  Widget _buildLoadingCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
