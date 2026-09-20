import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                child: Text(
                  'Contact & Support',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Get in Touch',
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Have a question, suggestion, or need help? We\'d love to hear from you.',
                style: GoogleFonts.inter(
                  color: context.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildContactOption(
                context: context,
                icon: Icons.email_outlined,
                title: 'Email Us',
                subtitle: 'support@aiverse.com',
                onTap: () => _launchEmail('support@aiverse.com'),
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                context: context,
                icon: Icons.bug_report_outlined,
                title: 'Report a Bug',
                subtitle: 'Found something wrong? Let us know',
                onTap: () => _launchEmail('bugs@aiverse.com', subject: 'Bug Report'),
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                context: context,
                icon: Icons.lightbulb_outline,
                title: 'Suggest a Feature',
                subtitle: 'Have an idea? We\'re all ears',
                onTap: () => _launchEmail('features@aiverse.com', subject: 'Feature Suggestion'),
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                context: context,
                icon: Icons.handshake_outlined,
                title: 'Partner With Us',
                subtitle: 'Want to list your AI tool?',
                onTap: () => _launchEmail('partners@aiverse.com', subject: 'Partnership Inquiry'),
              ),
              const SizedBox(height: 32),
              Text(
                'Follow Us',
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildSocialButton(context, Icons.smart_display_outlined, 'YouTube'),
                  const SizedBox(width: 12),
                  _buildSocialButton(context, Icons.code_outlined, 'GitHub'),
                  const SizedBox(width: 12),
                  _buildSocialButton(context, Icons.chat_bubble_outline, 'Discord'),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'We typically respond within 24-48 hours',
                  style: GoogleFonts.inter(
              color: context.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.borderColor, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.purplePrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.purplePrimary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: context.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                color: context.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: context.textMuted,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon, String label) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: context.textSecondary, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: context.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email, {String? subject}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: subject != null ? 'subject=$subject' : null,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
