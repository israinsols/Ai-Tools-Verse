import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeHelper on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  
  // Background
  Color get bg => isDark ? AppColors.bg : AppColors.bgLight;
  
  // Cards / Surfaces
  Color get cardBg => isDark ? AppColors.surface : AppColors.surfaceLightBg;
  Color get cardBgSecondary => isDark ? AppColors.surfaceLight : AppColors.surfaceMedium;
  
  // Text
  Color get textPrimary => isDark ? Colors.white : AppColors.textPrimaryLight;
  Color get textSecondary => isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
  Color get textMuted => isDark ? AppColors.textMuted : AppColors.textMutedLight;
  
  // Borders
  Color get borderColor => isDark ? AppColors.border : AppColors.borderLight;
  Color get borderHover => isDark ? AppColors.borderHover : AppColors.borderLight;
  
  // Scaffold
  Color get scaffoldBg => isDark ? AppColors.bg : AppColors.bgLight;
  
  // Badge backgrounds
  Color get freemiumBg => isDark ? AppColors.freemiumBg : AppColors.freemiumBgLight;
  Color get freemiumText => isDark ? AppColors.freemiumText : AppColors.freemiumTextLight;
  Color get paidBg => isDark ? AppColors.paidBg : AppColors.paidBgLight;
  Color get paidText => isDark ? AppColors.paidText : AppColors.paidTextLight;
  Color get freeBg => isDark ? AppColors.freeBg : AppColors.freeBgLight;
  Color get freeText => isDark ? AppColors.freeText : AppColors.freeTextLight;
}
