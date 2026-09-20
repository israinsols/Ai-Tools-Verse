import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/theme_helper.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
                  'Terms & Privacy',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(context,
                'Terms of Service',
                'By using AIVerse, you agree to these terms. AIVerse is a directory service that provides information about AI tools. We are not responsible for the content, accuracy, or availability of third-party tools listed on our platform.',
              ),
              const SizedBox(height: 20),
              _buildSection(context,
                'User Responsibilities',
                '• You must be at least 13 years old to use AIVerse\n• You are responsible for your account security\n• You agree not to misuse the platform\n• Tool submissions must be accurate and truthful',
              ),
              const SizedBox(height: 20),
              _buildSection(context,
                'Tool Submissions',
                'When you submit a tool, you grant AIVerse permission to display and promote your tool. Submitted tools go through a review process before being published. We reserve the right to reject any submission.',
              ),
              const SizedBox(height: 20),
              _buildSection(context,
                'Privacy Policy',
                'We collect minimal personal information:\n• Email address (for authentication)\n• Display name (for reviews)\n• Saved tools (stored locally on your device)\n\nWe do not sell your data to third parties.',
              ),
              const SizedBox(height: 20),
              _buildSection(context,
                'Data Storage',
                '• Authentication tokens are stored securely\n• Bookmarks are stored locally on your device\n• Tool data is cached for better performance\n• No tracking or analytics without consent',
              ),
              const SizedBox(height: 20),
              _buildSection(context,
                'Contact',
                'For privacy concerns or data requests, contact us at:\nprivacy@aiverse.com',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: context.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.inter(
            color: context.textSecondary,
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
