import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../onboarding/providers/vendor_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorAsync = ref.watch(vendorProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        color: AppTheme.primaryColor,
        backgroundColor: AppTheme.surfaceColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header with Profile Info
              _buildProfileHeader(context, vendorAsync, currentUser),
              
              // Profile Options
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Profile Options Container
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [AppTheme.cardShadow],
                      ),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            icon: Icons.person_outline,
                            title: 'Edit Profile',
                            subtitle: 'Update your personal information',
                            onTap: () {
                              context.push('/edit-profile');
                            },
                          ),
                          _buildDivider(),
                          _buildProfileOption(
                            icon: Icons.business_outlined,
                            title: 'Business Details',
                            subtitle: 'Manage your business information',
                            onTap: () {
                              context.push('/business-details');
                            },
                          ),
                          _buildDivider(),
                          _buildProfileOption(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Payment Settings',
                            subtitle: 'Manage payment methods',
                            onTap: () {
                              context.push('/payment-settings');
                            },
                          ),
                          _buildDivider(),
                          _buildProfileOption(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            subtitle: 'Get help and contact support',
                            onTap: () {
                              context.push('/support');
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Legal Documents Section
                    _buildSectionHeader('Legal Documents'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [AppTheme.cardShadow],
                      ),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            subtitle: 'Read our privacy policy',
                            onTap: () {
                              context.push('/privacy-policy');
                            },
                          ),
                          _buildDivider(),
                          _buildProfileOption(
                            icon: Icons.description_outlined,
                            title: 'Terms & Conditions',
                            subtitle: 'View terms and conditions',
                            onTap: () {
                              context.push('/terms-conditions');
                            },
                          ),
                          _buildDivider(),
                          _buildProfileOption(
                            icon: Icons.monetization_on_outlined,
                            title: 'Revenue Policy',
                            subtitle: 'Commission and payment policy',
                            onTap: () {
                              context.push('/revenue-policy');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Logout Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [AppTheme.cardShadow],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _showLogoutDialog(context, ref),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.logout,
                                    color: AppTheme.errorColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.errorColor,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Sign out of your account',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppTheme.errorColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      print('🔄 Refreshing profile screen data...');
      
      // Show haptic feedback
      HapticFeedback.lightImpact();
      
      // Refresh vendor data
      await ref.read(vendorProvider.notifier).refreshVendor();
      
      print('🟢 Profile screen refresh completed');
    } catch (e) {
      print('🔴 Profile screen refresh failed: $e');
    }
  }

  Widget _buildProfileHeader(BuildContext context, AsyncValue vendorAsync, currentUser) {
    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 40),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              const Expanded(
                child: Text(
                  'Profile',
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
          
          const SizedBox(height: 20),
          
          // Profile Info
          vendorAsync.when(
            data: (vendor) => Column(
              children: [
                // Profile Picture
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [AppTheme.cardShadow],
                  ),
                  child: ClipOval(
                    child: _buildProfileImage(vendor),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Name
                Text(
                  vendor?.fullName ?? 'Vendor Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                // Vendor ID
                if (vendor?.vendorId != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          color: Colors.white.withOpacity(0.8),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          vendor!.vendorId!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 8),
                
                // Email or Phone
                Text(
                  vendor?.phone?.isNotEmpty == true 
                      ? vendor!.phone!
                      : vendor?.email?.isNotEmpty == true 
                      ? vendor!.email!
                      : currentUser?.email ?? 'No contact info',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Verification Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: vendor?.verificationStatus == 'verified' 
                        ? AppTheme.successColor 
                        : vendor?.verificationStatus == 'rejected'
                        ? AppTheme.errorColor
                        : AppTheme.warningColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        vendor?.verificationStatus == 'verified' 
                            ? Icons.verified 
                            : vendor?.verificationStatus == 'rejected'
                            ? Icons.cancel
                            : Icons.pending,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        vendor?.verificationStatus == 'verified' 
                            ? 'Verified Vendor' 
                            : vendor?.verificationStatus == 'rejected'
                            ? 'Verification Rejected'
                            : 'Pending Verification',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (vendor?.businessName != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    vendor!.businessName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
            loading: () => _buildProfileHeaderSkeleton(),
            error: (error, stack) => _buildProfileHeaderError(currentUser),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderSkeleton() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 24,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 16,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeaderError(currentUser) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [AppTheme.cardShadow],
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppTheme.primaryColor,
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Unable to load profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentUser?.email ?? 'No contact info',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.errorColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                'Failed to load data',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption({
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
                  color: AppTheme.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
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
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: AppTheme.borderColor,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppTheme.surfaceColor,
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                context.pop();
                await _handleLogout(context, ref);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      print('🔵 Logout: Starting logout process...');
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      );

      // Clear vendor data first (before auth logout)
      print('🔵 Logout: Clearing vendor data...');
      ref.read(vendorProvider.notifier).clearVendorData();
      
      // Perform logout from Supabase
      print('🔵 Logout: Signing out from Supabase...');
      await SupabaseConfig.client.auth.signOut();
      
      // Force invalidate all providers to clear cached data
      print('🔵 Logout: Invalidating providers...');
      ref.invalidate(vendorProvider);
      ref.invalidate(authStateProvider);
      
      // Small delay to ensure state propagation
      await Future.delayed(const Duration(milliseconds: 200));
      
      print('🟢 Logout: Logout successful, navigating to welcome...');
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Navigate to welcome screen and clear the navigation stack
        context.go('/welcome');
        
        // Fallback: If go() doesn't work, force navigation after a delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            final currentRoute = GoRouterState.of(context).matchedLocation;
            if (currentRoute != '/welcome') {
              print('🔴 Logout: Router redirect failed, forcing navigation...');
              context.pushReplacement('/welcome');
            }
          }
        });
      }
    } catch (e) {
      print('🔴 Logout: Error during logout: $e');
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Even on error, try to navigate to welcome
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            context.go('/welcome');
          }
        });
      }
    }
  }

  Widget _buildProfileImage(vendor) {
    // Debug information
    print('🔍 Profile Image Debug:');
    print('🔍 Vendor ID: ${vendor?.id}');
    print('🔍 Profile Picture URL: ${vendor?.profilePicture}');
    print('🔍 Profile Picture null? ${vendor?.profilePicture == null}');
    print('🔍 Profile Picture empty? ${vendor?.profilePicture?.isEmpty ?? true}');

    if (vendor?.profilePicture != null && vendor!.profilePicture!.isNotEmpty) {
      return Image.network(
        vendor.profilePicture!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppTheme.primaryColor,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('🔴 Profile picture loading error: $error');
          print('🔴 Image URL: ${vendor.profilePicture}');
          print('🔴 Stack trace: $stackTrace');
          return Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_rounded,
                  color: AppTheme.primaryColor,
                  size: 40,
                ),
                const SizedBox(height: 4),
                Text(
                  'Image Error',
                  style: TextStyle(
                    fontSize: 8,
                    color: AppTheme.primaryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person_rounded,
          color: AppTheme.primaryColor,
          size: 50,
        ),
      );
    }
  }
} 