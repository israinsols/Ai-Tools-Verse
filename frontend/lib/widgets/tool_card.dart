import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/theme_helper.dart';
import '../models/tool.dart';
import 'app_network_image.dart';

class ToolCard extends StatefulWidget {
  final Tool tool;
  final VoidCallback? onTap;
  final LinearGradient avatarGradient;
  final bool isVerified;
  final bool isTrending;

  const ToolCard({
    super.key,
    required this.tool,
    this.onTap,
    this.avatarGradient = AppColors.avatarTeal,
    this.isVerified = false,
    this.isTrending = false,
  });

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered ? context.borderHover : context.borderColor,
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.purplePrimary.withValues(alpha: 0.15),
                      blurRadius: 24,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 16),
              _buildTags(),
              const SizedBox(height: 16),
              Divider(
                color: context.borderColor,
                height: 1,
              ),
              const SizedBox(height: 16),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.tool.name,
                      style: GoogleFonts.inter(
                        color: context.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.isVerified) ...[
                    const SizedBox(width: 6),
                    _buildVerifiedBadge(),
                  ],
                  if (widget.isTrending) ...[
                    const SizedBox(width: 6),
                    _buildTrendingIcon(),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getTagline(),
                style: GoogleFonts.inter(
                  color: context.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return AppNetworkImage(
      imageUrl: widget.tool.logoUrl,
      initials: _getInitials(),
      size: 56,
      borderRadius: 28,
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: AppColors.purplePrimary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 12,
      ),
    );
  }

  Widget _buildTrendingIcon() {
    return Icon(
      Icons.trending_up,
      color: AppColors.pinkAccent,
      size: 18,
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.tool.description,
      style: GoogleFonts.inter(
        color: context.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTags() {
    final tags = widget.tool.tags.take(3).toList();
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: context.cardBgSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.borderColor,
              width: 1,
            ),
          ),
          child: Text(
            '#$tag',
            style: GoogleFonts.inter(
              color: context.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.star,
              color: AppColors.starGold,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              widget.tool.rating.toStringAsFixed(1),
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.visibility_outlined,
              color: context.textMuted,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              _formatViewCount(widget.tool.viewCount),
              style: GoogleFonts.inter(
                color: context.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        _buildPricingBadge(),
      ],
    );
  }

  Widget _buildPricingBadge() {
    Color bgColor;
    Color textColor;
    String text;

    switch (widget.tool.pricingType) {
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getInitials() {
    final words = widget.tool.name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return widget.tool.name.length >= 2 ? widget.tool.name.substring(0, 2).toUpperCase() : widget.tool.name.toUpperCase();
  }

  String _getTagline() {
    final taglines = {
      'ChatGPT': 'Conversational AI for everything',
      'Midjourney': 'Stunning AI-generated art',
      'Claude': 'Thoughtful AI for long context',
      'Cursor': 'The AI code editor',
      'Suno': 'Make any song you imagine',
      'Runway': 'Next-gen AI video',
      'Flux': 'Open-weight image model',
      'Perplexity': 'AI answer engine',
      'ElevenLabs': 'Lifelike voice AI',
    };
    return taglines[widget.tool.name] ?? widget.tool.description;
  }

  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
