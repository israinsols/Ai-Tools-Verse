import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loved by creators',
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Builders, marketers, and engineers rely on AIVerse to stay current.',
                style: GoogleFonts.inter(color: context.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _buildTestimonialCard(
                context,
                'Maya R.',
                'Indie designer',
                'I find new tools here every week. The curation is just chef\'s kiss.',
              ),
              const SizedBox(height: 16),
              _buildTestimonialCard(
                context,
                'Devon K.',
                'Engineering manager',
                'Replaced three newsletters with AIVerse. Cleanest directory I\'ve used.',
              ),
              const SizedBox(height: 16),
              _buildTestimonialCard(
                context,
                'Aria S.',
                'Content lead',
                'The comparison pages alone saved my team hours of evaluation.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(BuildContext context, String name, String role, String quote) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$quote"',
            style: GoogleFonts.inter(
              color: context.textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientLogo,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      color: context.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    role,
                    style: GoogleFonts.inter(color: context.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
