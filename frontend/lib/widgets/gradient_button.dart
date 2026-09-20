import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isEnabled;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isEnabled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final active = isEnabled && !isLoading;

    return GestureDetector(
      onTap: active ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: isOutlined
              ? null
              : active
                  ? AppColors.gradientPrimary
                  : LinearGradient(
                      colors: [
                        AppColors.purplePrimary.withValues(alpha: 0.4),
                        AppColors.pinkAccent.withValues(alpha: 0.4),
                      ],
                    ),
          color: isOutlined ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(14),
          border: isOutlined
              ? Border.all(
                  color: active ? AppColors.purplePrimary : AppColors.border,
                  width: 1,
                )
              : null,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: isOutlined
                          ? (active ? AppColors.purplePrimary : AppColors.textMuted)
                          : Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      color: isOutlined
                          ? (active ? AppColors.purplePrimary : AppColors.textMuted)
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
