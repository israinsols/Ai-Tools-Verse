import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                padding: const EdgeInsets.fromLTRB(0, 10, 16, 10),
                child: Text(
                  'About AIVerse',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientLogo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'AIVerse',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.inter(
                    color: context.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildSection(context,
                'What is AIVerse?',
                'AIVerse is your one-stop directory for discovering the best AI tools available today. From image generators to coding assistants, find the perfect AI tool for your needs.',
              ),
              const SizedBox(height: 20),
              _buildSection(context,
                'Features',
                '• Browse 12+ curated AI tools\n• Search and filter by category\n• Save your favorite tools\n• Submit new tools for review\n• Read and write reviews\n• Dark mode for comfortable browsing',
              ),
              const SizedBox(height: 20),
              _buildSection(context,
                'Built With',
                '• Flutter (Frontend)\n• Node.js + Express (Backend)\n• Riverpod (State Management)\n• Hive (Local Storage)',
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Made with ❤️ for AI enthusiasts',
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
