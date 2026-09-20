import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/theme_helper.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        border: Border(
          top: BorderSide(
            color: context.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home_rounded, Icons.home_outlined),
              _buildNavItem(context, 1, Icons.category_rounded, Icons.category_outlined),
              _buildNavItem(context, 2, Icons.bookmark_rounded, Icons.bookmark_outline_rounded),
              _buildNavItem(context, 3, Icons.person_rounded, Icons.person_outline_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData filledIcon, IconData outlinedIcon) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          isSelected ? filledIcon : outlinedIcon,
          color: isSelected ? AppColors.purplePrimary : context.textMuted,
          size: 26,
        ),
      ),
    );
  }
}
