import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/theme_helper.dart';
import '../models/category.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final VoidCallback? onTap;
  final LinearGradient iconGradient;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.iconGradient = AppColors.categoryPurpleMagenta,
    this.icon = Icons.image_outlined,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
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
          padding: const EdgeInsets.all(28),
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
                      color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildDescription(),
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: widget.iconGradient,
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.icon,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.category.name,
      style: GoogleFonts.inter(
        color: context.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.category.description,
      style: GoogleFonts.inter(
        color: context.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${widget.category.toolCount} tools',
          style: GoogleFonts.inter(
            color: context.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Text(
              'Explore',
              style: GoogleFonts.inter(
                color: AppColors.purplePrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward,
              color: AppColors.purplePrimary,
              size: 14,
            ),
          ],
        ),
      ],
    );
  }
}
