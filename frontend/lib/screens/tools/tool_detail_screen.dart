import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../providers/providers.dart';
import '../../providers/subscription_provider.dart';
import '../../models/tool.dart';
import '../../models/subscription.dart';
import '../../widgets/app_network_image.dart';

class ToolDetailScreen extends ConsumerWidget {
  final String toolId;

  const ToolDetailScreen({
    super.key,
    required this.toolId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tool = ref.watch(toolByIdProvider(toolId));
    final bookmarkIds = ref.watch(bookmarksProvider);

    return Scaffold(
      body: tool.when(
        data: (tool) => _buildContent(context, ref, tool, bookmarkIds),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Tool tool, List<String> bookmarkIds) {
    final isBookmarked = bookmarkIds.contains(tool.id);

    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context, ref, tool, isBookmarked),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToolCard(context, tool),
                  const SizedBox(height: 12),
                  _buildActionButtons(context, ref, tool, isBookmarked),
                  const SizedBox(height: 20),
                  _buildAboutSection(context, tool),
                  const SizedBox(height: 16),
                  _buildAtAGlance(context, tool),
                  const SizedBox(height: 16),
                  if (tool.pricingPlans.isNotEmpty || tool.freeTierInfo != null)
                    _buildPricingSection(context, tool),
                  if (tool.pricingPlans.isNotEmpty || tool.freeTierInfo != null)
                    const SizedBox(height: 16),
                  if (tool.plusDiscountPercent != null || tool.proDiscountPercent != null)
                    _buildDiscountSection(context, ref, tool),
                  if (tool.plusDiscountPercent != null || tool.proDiscountPercent != null)
                    const SizedBox(height: 16),
                  _buildKeyFeatures(context, tool),
                  const SizedBox(height: 16),
                  _buildProsCons(context, tool),
                  const SizedBox(height: 16),
                  _buildTags(context, tool),
                  const SizedBox(height: 16),
                  _buildRateThisTool(context, ref, tool),
                  const SizedBox(height: 24),
                  _buildReviewsSection(context, ref, tool),
                  const SizedBox(height: 24),
                  _buildRelatedTools(context, ref, tool),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, Tool tool, bool isBookmarked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: context.textPrimary, size: 20),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Share.share('Check out ${tool.name} on AIVerse!\n${tool.websiteUrl}'),
            icon: Icon(Icons.share_outlined, color: context.textPrimary, size: 20),
          ),
          IconButton(
            onPressed: () => ref.read(bookmarksProvider.notifier).toggleBookmark(tool.id),
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: isBookmarked ? AppColors.purplePrimary : context.textPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, Tool tool) {
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
          Row(
            children: [
              AppNetworkImage(
                imageUrl: tool.logoUrl,
                initials: tool.name.length >= 2 ? tool.name.substring(0, 2).toUpperCase() : tool.name.toUpperCase(),
                size: 64,
                borderRadius: 16,
                gradientColors: AppNetworkImage.getGradientForId(tool.id),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            tool.name,
                            style: GoogleFonts.inter(
                              color: context.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (tool.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, color: AppColors.purplePrimary, size: 18),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (tool.isTrending) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.pinkAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Trending',
                          style: GoogleFonts.inter(
                            color: AppColors.pinkAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tool.description,
            style: GoogleFonts.inter(
              color: context.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildStatChip(context, Icons.star, Colors.amber, '${tool.rating.toStringAsFixed(1)} (${_formatViewCount(tool.viewCount)})'),
              _buildStatChip(context, Icons.visibility_outlined, context.textMuted, '${_formatViewCount(tool.viewCount)} views'),
              _buildPricingBadge(context, tool.pricingType),
              _buildCategoryBadge(context, tool.categoryId),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, Color iconColor, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(color: context.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPricingBadge(BuildContext context, PricingType pricingType) {
    Color bgColor;
    Color textColor;
    String text;

    switch (pricingType) {
      case PricingType.free:
        bgColor = context.freeBg;
        textColor = context.freeText;
        text = 'Free';
        break;
      case PricingType.freemium:
        bgColor = context.freemiumBg;
        textColor = context.freemiumText;
        text = 'Freemium';
        break;
      case PricingType.paid:
        bgColor = context.paidBg;
        textColor = context.paidText;
        text = 'Paid';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(color: textColor, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context, String categoryId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.purplePrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getCategoryName(categoryId),
        style: GoogleFonts.inter(
          color: AppColors.purplePrimary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getCategoryName(String categoryId) {
    const categoryNames = {
      '1': 'AI Image Generators',
      '2': 'AI Video Tools',
      '3': 'AI Music Tools',
      '4': 'AI Writing Tools',
      '5': 'AI Coding Tools',
      '6': 'AI Voice Tools',
      '7': 'AI Logo Makers',
      '8': 'AI Presentation Tools',
      '9': 'AI Productivity',
    };
    return categoryNames[categoryId] ?? 'AI Tools';
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, Tool tool, bool isBookmarked) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final url = Uri.parse(tool.websiteUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            icon: const Icon(Icons.open_in_new, size: 16),
            label: Text(
              'Visit Website',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purplePrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildIconAction(
          context,
          isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
          isBookmarked ? AppColors.purplePrimary : context.textMuted,
          () => ref.read(bookmarksProvider.notifier).toggleBookmark(tool.id),
        ),
        const SizedBox(width: 8),
        _buildIconAction(
          context,
          Icons.share_outlined,
          context.textMuted,
          () => Share.share('Check out ${tool.name} on AIVerse!\n${tool.websiteUrl}'),
        ),
        const SizedBox(width: 8),
        _buildIconAction(
          context,
          Icons.flag_outlined,
          context.textMuted,
          () {},
        ),
      ],
    );
  }

  Widget _buildIconAction(BuildContext context, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.borderColor, width: 0.5),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, Tool tool) {
    return _buildSectionCard(
      context,
      title: 'About',
      child: Text(
        tool.description,
        style: GoogleFonts.inter(
          color: context.textSecondary,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildAtAGlance(BuildContext context, Tool tool) {
    return _buildSectionCard(
      context,
      title: 'At a glance',
      child: Column(
        children: [
          _buildGlanceRow(context, 'Pricing', _getPricingText(tool.pricingType)),
          _buildGlanceRow(context, 'Category', _getCategoryName(tool.categoryId)),
          _buildGlanceRow(context, 'Rating', '${tool.rating.toStringAsFixed(1)} / 5'),
          _buildGlanceRow(context, 'Reviews', '${tool.viewCount}'),
          _buildGlanceRow(context, 'Views', _formatViewCount(tool.viewCount)),
        ],
      ),
    );
  }

  String _getPricingText(PricingType type) {
    switch (type) {
      case PricingType.free:
        return 'Free';
      case PricingType.freemium:
        return 'Freemium';
      case PricingType.paid:
        return 'Paid';
    }
  }

  Widget _buildGlanceRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: context.textMuted, fontSize: 13),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context, Tool tool) {
    return _buildSectionCard(
      context,
      title: 'Pricing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tool.freeTierInfo != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.freeBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: context.freeText, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Free Tier',
                        style: GoogleFonts.inter(
                          color: context.freeText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tool.freeTierInfo!,
                    style: GoogleFonts.inter(
                      color: context.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (tool.pricingPlans.isNotEmpty) const SizedBox(height: 12),
          ],
          if (tool.trialInfo != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.purplePrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.autorenew, color: AppColors.purplePrimary, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      tool.trialInfo!,
                      style: GoogleFonts.inter(
                        color: AppColors.purplePrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (tool.pricingPlans.isNotEmpty) ...[
            Text(
              'Plans',
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...tool.pricingPlans.map((plan) => _buildPricingPlan(context, plan)),
          ],
          if (tool.membershipBenefits.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'What\'s included',
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...tool.membershipBenefits.map((benefit) => _buildBenefitItem(context, benefit)),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingPlan(BuildContext context, PricingPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardBgSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.name,
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (plan.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    plan.description!,
                    style: GoogleFonts.inter(
                      color: context.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.price,
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                plan.period,
                style: GoogleFonts.inter(
                  color: context.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              benefit,
              style: GoogleFonts.inter(
                color: context.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection(BuildContext context, WidgetRef ref, Tool tool) {
    final subscription = ref.watch(subscriptionProvider);
    final tier = subscription.tier;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildSectionCard(
      context,
      title: 'AIVerse Premium Discounts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tier == SubscriptionTier.free) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.diamond_rounded,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock Premium Discounts',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upgrade to Plus or Pro to access exclusive discounts',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (tool.plusDiscountPercent != null) ...[
            _buildDiscountRow(
              context: context,
              ref: ref,
              tool: tool,
              tier: 'Plus',
              discount: tool.plusDiscountPercent!,
              code: tool.discountCodePlus,
              isUnlocked: tier == SubscriptionTier.plus || tier == SubscriptionTier.pro,
              color: AppColors.purplePrimary,
            ),
            const SizedBox(height: 8),
          ],
          if (tool.proDiscountPercent != null) ...[
            _buildDiscountRow(
              context: context,
              ref: ref,
              tool: tool,
              tier: 'Pro',
              discount: tool.proDiscountPercent!,
              code: tool.discountCodePro,
              isUnlocked: tier == SubscriptionTier.pro,
              color: const Color(0xFF10B981),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscountRow({
    required BuildContext context,
    required WidgetRef ref,
    required Tool tool,
    required String tier,
    required int discount,
    required String? code,
    required bool isUnlocked,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final claimKey = '${tool.id}_${tier.toLowerCase()}';
    final isClaimed = ref.watch(subscriptionProvider).claimedDiscounts.contains(claimKey);
    final userTier = ref.watch(subscriptionProvider).tier;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUnlocked ? color.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.local_offer_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '$tier Discount',
                        style: GoogleFonts.inter(
                          color: context.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$discount% OFF',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (code != null && isUnlocked) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Code: $code',
                    style: GoogleFonts.inter(
                      color: context.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isUnlocked && !isClaimed)
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(subscriptionProvider.notifier).claimDiscount(claimKey);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Discount claimed! Code: $code',
                        style: GoogleFonts.inter(),
                      ),
                      backgroundColor: color,
                      action: SnackBarAction(
                        label: 'Copy',
                        textColor: Colors.white,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: code ?? ''));
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Claim',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (isUnlocked && isClaimed)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Claimed',
                    style: GoogleFonts.inter(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          if (!isUnlocked)
            Tooltip(
              message: tier == 'Pro' && userTier == SubscriptionTier.plus
                  ? 'Upgrade to Pro to unlock'
                  : 'Subscribe to unlock',
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.textMuted.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: context.textMuted,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKeyFeatures(BuildContext context, Tool tool) {
    if (tool.keyFeatures.isEmpty) return const SizedBox.shrink();

    return _buildSectionCard(
      context,
      title: 'Key features',
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: tool.keyFeatures.map((feature) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: AppColors.purplePrimary, size: 16),
              const SizedBox(width: 6),
              Text(
                feature,
                style: GoogleFonts.inter(
                  color: context.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProsCons(BuildContext context, Tool tool) {
    if (tool.pros.isEmpty && tool.cons.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tool.pros.isNotEmpty)
          Expanded(
            child: _buildSectionCard(
              context,
              title: 'Pros',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tool.pros.map((pro) => _buildProConItem(context, true, pro)).toList(),
              ),
            ),
          ),
        if (tool.pros.isNotEmpty && tool.cons.isNotEmpty) const SizedBox(width: 12),
        if (tool.cons.isNotEmpty)
          Expanded(
            child: _buildSectionCard(
              context,
              title: 'Cons',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tool.cons.map((con) => _buildProConItem(context, false, con)).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProConItem(BuildContext context, bool isPro, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPro ? Icons.check_circle : Icons.cancel,
            color: isPro ? Colors.green : Colors.redAccent,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: context.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context, Tool tool) {
    if (tool.tags.isEmpty) return const SizedBox.shrink();

    return _buildSectionCard(
      context,
      title: 'Tags',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tool.tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.cardBgSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor, width: 0.5),
            ),
            child: Text(
              '#$tag',
              style: GoogleFonts.inter(color: context.textSecondary, fontSize: 12),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRateThisTool(BuildContext context, WidgetRef ref, Tool tool) {
    final authState = ref.watch(authStateProvider);

    return _buildSectionCard(
      context,
      title: 'Rate this tool',
      child: Row(
        children: [
          Row(
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: authState.isAuthenticated
                    ? () => _showAddReviewDialog(context)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    index < tool.rating.round() ? Icons.star : Icons.star_border,
                    color: index < tool.rating.round() ? Colors.amber : context.textMuted,
                    size: 28,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tool.rating.toStringAsFixed(1)} (${tool.viewCount} ratings)',
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                authState.isAuthenticated ? 'Tap to rate' : 'Sign in to rate',
                style: GoogleFonts.inter(color: context.textMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, WidgetRef ref, Tool tool) {
    final reviewsAsync = ref.watch(reviewsProvider(tool.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reviews',
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.cardBgSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tool.rating.toStringAsFixed(1),
                style: GoogleFonts.inter(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        reviewsAsync.when(
          data: (reviews) {
            if (reviews.isEmpty) return _buildEmptyReviews(context, ref);
            return Column(
              children: reviews.take(3).map((review) => _buildReviewCard(context, review)).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()),
          ),
          error: (e, _) => _buildEmptyReviews(context, ref),
        ),
      ],
    );
  }

  Widget _buildEmptyReviews(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Column(
        children: [
          Icon(Icons.rate_review_outlined, color: context.textMuted, size: 40),
          const SizedBox(height: 12),
          Text(
            'No reviews yet',
            style: GoogleFonts.inter(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to review this tool',
            style: GoogleFonts.inter(color: context.textSecondary, fontSize: 12),
          ),
          if (authState.isAuthenticated) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddReviewDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purplePrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Write a Review',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, dynamic review) {
    final userName = (review['userName'] ?? 'User') as String;
    final initials = userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U';
    final timeAgo = (review['timeAgo'] ?? '') as String;
    final title = (review['title'] ?? '') as String;
    final comment = (review['comment'] ?? '') as String;
    final rating = (review['rating'] ?? 0) as int;
    final helpful = (review['helpful'] ?? 0) as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(gradient: AppColors.gradientLogo, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: GoogleFonts.inter(color: context.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      timeAgo,
                      style: GoogleFonts.inter(color: context.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _buildStars(context, rating),
            ],
          ),
          if (title.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            comment,
            style: GoogleFonts.inter(color: context.textSecondary, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, color: context.textMuted, size: 14),
              const SizedBox(width: 6),
              Text(
                '$helpful',
                style: GoogleFonts.inter(color: context.textMuted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStars(BuildContext context, int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.amber : context.textMuted,
          size: 14,
        );
      }),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddReviewSheet(toolId: toolId),
    );
  }

  Widget _buildRelatedTools(BuildContext context, WidgetRef ref, Tool tool) {
    final toolsAsync = ref.watch(toolsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related tools',
          style: GoogleFonts.inter(color: context.textPrimary, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        toolsAsync.when(
          data: (tools) {
            final related = tools.where((t) => t.id != tool.id && t.categoryId == tool.categoryId).take(4).toList();
            if (related.isEmpty) {
              return Text(
                'No related tools found',
                style: GoogleFonts.inter(color: context.textMuted, fontSize: 13),
              );
            }
            return SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final t = related[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ToolDetailScreen(toolId: t.id),
                        ),
                      );
                    },
                    child: Container(
                      width: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.borderColor, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppNetworkImage(
                                imageUrl: t.logoUrl,
                                initials: t.name.length >= 2 ? t.name.substring(0, 2).toUpperCase() : t.name.toUpperCase(),
                                size: 32,
                                borderRadius: 8,
                                gradientColors: AppNetworkImage.getGradientForId(t.id),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  t.name,
                                  style: GoogleFonts.inter(
                                    color: context.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.description,
                            style: GoogleFonts.inter(color: context.textSecondary, fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              const SizedBox(width: 2),
                              Text(
                                t.rating.toStringAsFixed(1),
                                style: GoogleFonts.inter(color: context.textMuted, fontSize: 11),
                              ),
                              const SizedBox(width: 8),
                              _buildPricingBadge(context, t.pricingType),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const SizedBox(
            height: 130,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class _AddReviewSheet extends ConsumerStatefulWidget {
  final String toolId;

  const _AddReviewSheet({required this.toolId});

  @override
  ConsumerState<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends ConsumerState<_AddReviewSheet> {
  int _rating = 5;
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: context.textMuted, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Write a Review',
              style: GoogleFonts.inter(color: context.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text(
              'Rating',
              style: GoogleFonts.inter(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = index + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: index < _rating ? Colors.amber : context.textMuted,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              'Title (optional)',
              style: GoogleFonts.inter(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: GoogleFonts.inter(color: context.textPrimary, fontSize: 14),
              decoration: const InputDecoration(hintText: 'Summarize your experience'),
            ),
            const SizedBox(height: 20),
            Text(
              'Review',
              style: GoogleFonts.inter(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              style: GoogleFonts.inter(color: context.textPrimary, fontSize: 14),
              decoration: const InputDecoration(hintText: 'Share your experience with this tool'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purplePrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'Submit Review',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final api = ref.read(apiServiceProvider);
      await api.addReview(widget.toolId, {
        'rating': _rating,
        'title': _titleController.text.trim(),
        'comment': _commentController.text.trim(),
      });

      ref.invalidate(reviewsProvider(widget.toolId));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }

    setState(() => _isSubmitting = false);
  }
}
