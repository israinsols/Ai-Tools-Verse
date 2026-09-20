import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../providers/providers.dart';
import '../../providers/theme_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../models/subscription.dart';
import 'about_screen.dart';
import 'admin_screen.dart';
import 'contact_screen.dart';
import 'testimonials_screen.dart';
import '../auth/login_screen.dart';
import 'notifications_screen.dart';
import 'saved_screen.dart';
import '../tools/submit_tool_screen.dart';
import 'terms_screen.dart';
import '../subscription/subscription_plans_screen.dart';
import '../subscription/my_subscription_screen.dart';
import '../subscription/payment_methods_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const Color _purplePrimary = Color(0xFFA78BFA);
  static const Color _purpleDeep = Color(0xFF7C3AED);
  static const Color _purpleDark = Color(0xFF6D28D9);
  static const Color _purpleAccent = Color(0xFFC4B5FD);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileCard(context, ref, authState),
              const SizedBox(height: 32),
              _buildAppearanceSection(context, ref),
              const SizedBox(height: 28),
              _buildYourActivitySection(context, ref, authState),
              const SizedBox(height: 28),
              _buildAboutSection(context, ref, authState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref, AuthState authState) {
    return GestureDetector(
      onTap: () {
        if (!authState.isAuthenticated) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.isDark
              ? const Color(0xFF1A1025)
              : const Color(0xFFEDE9FE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: context.isDark
                ? const Color(0xFF6D28D9)
                : const Color(0xFFC4B5FD),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB49AFF),
                    Color(0xFF9061F9),
                    Color(0xFF7C3AED),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authState.isAuthenticated
                        ? (authState.displayName ?? 'User')
                        : 'Sign in to get started',
                    style: GoogleFonts.inter(
                      color: context.isDark ? Colors.white : const Color(0xFF1E1533),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    authState.isAuthenticated
                        ? (authState.email ?? '')
                        : 'Save tools, submit new ones, and more',
                    style: GoogleFonts.inter(
                      color: context.isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : const Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: context.isDark
                    ? const Color(0xFF2D1F45)
                    : const Color(0xFFD4C4FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_right,
                color: context.isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : const Color(0xFF6D28D9),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'APPEARANCE',
          style: GoogleFonts.inter(
            color: context.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.borderColor,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'Theme',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              _buildThemeOption(
                context,
                ref: ref,
                icon: Icons.dark_mode_rounded,
                mode: ThemeMode.dark,
                isSelected: themeState.themeMode == ThemeMode.dark,
              ),
              const SizedBox(width: 6),
              _buildThemeOption(
                context,
                ref: ref,
                icon: Icons.light_mode_rounded,
                mode: ThemeMode.light,
                isSelected: themeState.themeMode == ThemeMode.light,
              ),
              const SizedBox(width: 6),
              _buildThemeOption(
                context,
                ref: ref,
                icon: Icons.computer_rounded,
                mode: ThemeMode.system,
                isSelected: themeState.themeMode == ThemeMode.system,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required WidgetRef ref,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(themeProvider.notifier).setThemeMode(mode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB49AFF),
                    Color(0xFF9061F9),
                    Color(0xFF7C3AED),
                  ],
                )
              : null,
          color: isSelected ? null : (context.isDark ? const Color(0xFF1A1525) : const Color(0xFFE8E4EE)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : context.textMuted,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildYourActivitySection(BuildContext context, WidgetRef ref, AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR ACTIVITY',
          style: GoogleFonts.inter(
            color: context.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.borderColor,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: Icons.send_outlined,
                iconColor: _purplePrimary,
                title: 'Submit Tool',
                onTap: () {
                  if (authState.isAuthenticated) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SubmitToolScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                icon: Icons.bookmark_outline,
                iconColor: _purplePrimary,
                title: 'Saved Tools',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFE8E4EE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '0',
                    style: GoogleFonts.inter(
                      color: context.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SavedScreen()),
                  );
                },
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                icon: Icons.notifications_outlined,
                iconColor: _purplePrimary,
                title: 'Notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                icon: Icons.credit_card_outlined,
                iconColor: _purplePrimary,
                title: 'Payment Methods',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                  );
                },
              ),
              _buildDivider(context),
              _buildSubscriptionItem(context, ref),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, WidgetRef ref, AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ABOUT',
          style: GoogleFonts.inter(
            color: context.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.borderColor,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: Icons.info_outline,
                iconColor: context.textMuted,
                title: 'About AIVerse',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  );
                },
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                icon: Icons.favorite_outline,
                iconColor: context.textMuted,
                title: 'Loved by creators',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TestimonialsScreen()),
                  );
                },
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                icon: Icons.description_outlined,
                iconColor: context.textMuted,
                title: 'Terms & Privacy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsScreen()),
                  );
                },
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                icon: Icons.support_outlined,
                iconColor: context.textMuted,
                title: 'Contact/Support',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactScreen()),
                  );
                },
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                icon: Icons.star_outline,
                iconColor: context.textMuted,
                title: 'Rate the app',
                onTap: () async {
                  final url = Uri.parse(
                    Theme.of(context).platform == TargetPlatform.android
                        ? 'market://details?id=com.aiverse.app'
                        : 'itms-apps://itunes.apple.com/app/aiverse',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
              if (authState.isAuthenticated && authState.role == 'admin') ...[
                _buildDivider(context),
                _buildMenuItem(
                  context,
                  icon: Icons.admin_panel_settings_outlined,
                  iconColor: _purplePrimary,
                  title: 'Admin Dashboard',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminScreen()),
                    );
                  },
                ),
              ],
              if (authState.isAuthenticated) ...[
                _buildDivider(context),
                _buildMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  iconColor: Colors.redAccent,
                  title: 'Logout',
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: context.cardBg,
                        title: Text(
                          'Logout',
                          style: GoogleFonts.inter(
                            color: context.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: GoogleFonts.inter(
                            color: context.textSecondary,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(color: context.textMuted),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(
                              'Logout',
                              style: GoogleFonts.inter(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await ref.read(authStateProvider.notifier).signOut();
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing,
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.chevron_right,
              color: context.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionItem(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    final tierName = subscription.tier == SubscriptionTier.free
        ? 'Free'
        : subscription.tier == SubscriptionTier.plus
            ? 'Plus'
            : 'Pro';

    final tierColor = subscription.tier == SubscriptionTier.free
        ? context.textMuted
        : subscription.tier == SubscriptionTier.plus
            ? AppColors.purplePrimary
            : const Color(0xFF10B981);

    return GestureDetector(
      onTap: () {
        if (subscription.tier == SubscriptionTier.free) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubscriptionPlansScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MySubscriptionScreen()),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: subscription.tier != SubscriptionTier.free
                    ? LinearGradient(
                        colors: [tierColor, tierColor.withValues(alpha: 0.8)],
                      )
                    : null,
                color: subscription.tier == SubscriptionTier.free
                    ? context.textMuted.withValues(alpha: 0.1)
                    : null,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.diamond_rounded,
                color: subscription.tier != SubscriptionTier.free
                    ? Colors.white
                    : context.textMuted,
                size: 16,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AIVerse Premium',
                    style: GoogleFonts.inter(
                      color: context.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subscription.tier == SubscriptionTier.free
                        ? 'Unlock exclusive discounts'
                        : 'Plan: $tierName',
                    style: GoogleFonts.inter(
                      color: tierColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: subscription.tier != SubscriptionTier.free
                    ? LinearGradient(
                        colors: [tierColor, tierColor.withValues(alpha: 0.8)],
                      )
                    : null,
                color: subscription.tier == SubscriptionTier.free
                    ? context.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFE8E4EE)
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                subscription.tier == SubscriptionTier.free ? 'Upgrade' : tierName,
                style: GoogleFonts.inter(
                  color: subscription.tier != SubscriptionTier.free
                      ? Colors.white
                      : context.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: context.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.isDark
          ? Colors.white.withValues(alpha: 0.06)
          : const Color(0xFFE8E4EE),
      indent: 52,
      endIndent: 16,
    );
  }
}
