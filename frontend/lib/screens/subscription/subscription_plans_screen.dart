import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/subscription.dart';
import '../../providers/subscription_provider.dart';
import 'my_subscription_screen.dart';
import 'payment_method_screen.dart';

class SubscriptionPlansScreen extends ConsumerWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ref.read(subscriptionProvider.notifier).checkTrialExpiry();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bg : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bg : AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'AIVerse Premium',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildHeader(isDark),
            const SizedBox(height: 24),
            _buildPlanCard(
              context: context,
              ref: ref,
              tier: SubscriptionTier.free,
              name: 'Free',
              price: '\$0',
              period: 'forever',
              features: [
                'Browse all AI tools',
                'Basic search & filters',
                'Community access',
                'Standard tool info',
              ],
              isCurrentTier: subscription.tier == SubscriptionTier.free,
              isPopular: false,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              context: context,
              ref: ref,
              tier: SubscriptionTier.plus,
              name: 'Plus',
              price: '\$4.99',
              period: '/month',
              features: [
                '10-20% off on all tools',
                'Early access to new tools',
                'Priority support',
                'Ad-free experience',
                'Exclusive tutorials',
              ],
              isCurrentTier: subscription.tier == SubscriptionTier.plus,
              isPopular: true,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildPlanCard(
              context: context,
              ref: ref,
              tier: SubscriptionTier.pro,
              name: 'Pro',
              price: '\$9.99',
              period: '/month',
              features: [
                '20-30% off on all tools',
                'Everything in Plus',
                'Custom discount codes',
                'API access',
                'Dedicated support',
                'White-label options',
              ],
              isCurrentTier: subscription.tier == SubscriptionTier.pro,
              isPopular: false,
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            _buildFAQSection(isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.purplePrimary.withValues(alpha: 0.35),
                AppColors.purplePrimary.withValues(alpha: 0.10),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC084FC), Color(0xFFA855F7), Color(0xFF9333EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purplePrimary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                'Unlock discounts on every AI tool',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Save up to 25% on tool memberships',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.black.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required WidgetRef ref,
    required SubscriptionTier tier,
    required String name,
    required String price,
    required String period,
    required List<String> features,
    required bool isCurrentTier,
    required bool isPopular,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular
              ? AppColors.purplePrimary
              : isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.purplePrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'MOST POPULAR',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (isPopular) const SizedBox(width: 8),
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              if (isCurrentTier)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'CURRENT',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                period,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.black.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.purplePrimary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!isCurrentTier)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _handleSubscription(
                  context: context,
                  ref: ref,
                  tier: tier,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPopular
                      ? AppColors.purplePrimary
                      : isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                  foregroundColor:
                      isPopular ? Colors.white : (isDark ? Colors.white : Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  tier == SubscriptionTier.free
                      ? 'Downgrade'
                      : 'Start 7-Day Free Trial',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleSubscription({
    required BuildContext context,
    required WidgetRef ref,
    required SubscriptionTier tier,
  }) {
    if (tier == SubscriptionTier.free) {
      ref.read(subscriptionProvider.notifier).cancelSubscription();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Downgraded to Free plan',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentMethodScreen(selectedTier: tier),
        ),
      );
    }
  }

  Widget _buildFAQSection(bool isDark) {
    final faqs = [
      {
        'q': 'Can I cancel anytime?',
        'a': 'Yes, you can cancel your subscription at any time. Your benefits will continue until the end of your billing period.',
      },
      {
        'q': 'What payment methods are accepted?',
        'a': 'We accept all major credit cards, debit cards, and digital wallets.',
      },
      {
        'q': 'How do discounts work?',
        'a': 'AIVerse negotiates exclusive discounts with AI tool providers. As a Premium member, you get access to these discounts and unique promo codes.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...faqs.map(
          (faq) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq['q']!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  faq['a']!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
