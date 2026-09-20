import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/subscription.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/payment_provider.dart';
import 'subscription_plans_screen.dart';

class MySubscriptionScreen extends ConsumerWidget {
  const MySubscriptionScreen({super.key});

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
          'My Subscription',
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
            _buildCurrentPlanCard(subscription, isDark),
            const SizedBox(height: 16),
            if (subscription.trialActive) ...[
              _buildTrialCountdown(subscription, isDark),
              const SizedBox(height: 16),
            ],
            _buildTotalSavedCard(subscription, isDark),
            const SizedBox(height: 16),
            _buildClaimedDiscounts(subscription, isDark),
            const SizedBox(height: 16),
            _buildBillingSection(context, ref, isDark),
            const SizedBox(height: 24),
            _buildActionButtons(context, ref, subscription, isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard(Subscription subscription, bool isDark) {
    final tierName = subscription.tier == SubscriptionTier.free
        ? 'Free'
        : subscription.tier == SubscriptionTier.plus
            ? 'Plus'
            : 'Pro';

    final tierColor = subscription.tier == SubscriptionTier.free
        ? Colors.grey
        : subscription.tier == SubscriptionTier.plus
            ? AppColors.purplePrimary
            : const Color(0xFF10B981);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tierColor,
            tierColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                subscription.tier == SubscriptionTier.free
                    ? Icons.person_rounded
                    : Icons.diamond_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Current Plan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'AIVerse $tierName',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          if (subscription.subscribedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Member since ${_formatDate(subscription.subscribedAt!)}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrialCountdown(Subscription subscription, bool isDark) {
    final remaining = subscription.trialEndsAt!.difference(DateTime.now());
    final days = remaining.inDays.clamp(0, 7);
    final hours = (remaining.inHours % 24).clamp(0, 23);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.timer_rounded,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Free Trial Active',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '$days days, $hours hours remaining',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSavedCard(Subscription subscription, bool isDark) {
    // Dummy fixed-value calculation for demo purposes — not tied to real tool pricing
    final savedAmount = subscription.claimedDiscounts.length * 12;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.savings_rounded,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Saved',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '\$$savedAmount saved with discounts',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimedDiscounts(Subscription subscription, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Claimed Discounts',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        if (subscription.claimedDiscounts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 40,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'No discounts claimed yet',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  'Visit tool pages to claim exclusive discounts',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          )
        else
          ...subscription.claimedDiscounts.map(
            (claimKey) {
              final parts = claimKey.split('_');
              final toolId = parts.isNotEmpty ? parts[0] : claimKey;
              final tier = parts.length > 1 ? parts[1].toUpperCase() : '';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.purplePrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.purplePrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tool #$toolId',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          if (tier.isNotEmpty)
                            Text(
                              '$tier Discount',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : Colors.black.withValues(alpha: 0.5),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.verified_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    Subscription subscription,
    bool isDark,
  ) {
    return Row(
      children: [
        if (subscription.tier != SubscriptionTier.free) ...[
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(subscriptionProvider.notifier).cancelSubscription();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Subscription cancelled',
                        style: GoogleFonts.inter(),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancel Plan',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubscriptionPlansScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purplePrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                subscription.tier == SubscriptionTier.free
                    ? 'Upgrade Plan'
                    : 'Change Plan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildBillingSection(BuildContext context, WidgetRef ref, bool isDark) {
    final cards = ref.watch(paymentCardsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BILLING',
          style: GoogleFonts.inter(
            color: context.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        if (cards.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.credit_card_off_outlined,
                  color: context.textMuted,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No payment method',
                        style: GoogleFonts.inter(
                          color: context.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Add a card to manage billing',
                        style: GoogleFonts.inter(
                          color: context.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          ...cards.map(
            (card) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: card.isDefault
                      ? AppColors.purplePrimary
                      : isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1),
                  width: card.isDefault ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.credit_card_rounded,
                      color: context.textMuted,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.maskedNumber,
                          style: GoogleFonts.inter(
                            color: context.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${card.cardHolderName} • ${card.expiryMonth}/${card.expiryYear}',
                          style: GoogleFonts.inter(
                            color: context.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (card.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.purplePrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'DEFAULT',
                        style: GoogleFonts.inter(
                          color: AppColors.purplePrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ]
    );
  }
}
