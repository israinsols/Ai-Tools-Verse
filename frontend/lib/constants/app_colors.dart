import 'package:flutter/material.dart';

class AppColors {
  // Background colors
  static const bg = Color(0xFF0D0A14);
  static const bgDark = Color(0xFF0A0812);
  static const bgLight = Color(0xFFF8F9FC);
  
  // Card surface
  static const surface = Color(0xFF13101F);
  static const surfaceLight = Color(0xFF1C1730);
  static const surfaceLightBg = Color(0xFFFFFFFF);
  static const surfaceMedium = Color(0xFFF1F3F9);
  
  // Border
  static const border = Color(0x14FFFFFF);
  static const borderHover = Color(0x26FFFFFF);
  static const borderLight = Color(0xFFE2E4E9);
  
  // Primary accents
  static const purplePrimary = Color(0xFF8B7FE8);
  static const purpleDark = Color(0xFF534AB7);
  static const pinkAccent = Color(0xFFE14F8A);
  
  // Text colors
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9B9AA5);
  static const textMuted = Color(0xFF6B6975);
  static const textPrimaryLight = Color(0xFF1A1625);
  static const textSecondaryLight = Color(0xFF6B7280);
  static const textMutedLight = Color(0xFF9CA3AF);
  
  // Rating star
  static const starGold = Color(0xFFF5B942);
  
  // Badge colors - Freemium
  static const freemiumBg = Color(0xFF2A2450);
  static const freemiumText = Color(0xFFC4B5FD);
  static const freemiumBgLight = Color(0xFFEDE9FE);
  static const freemiumTextLight = Color(0xFF6D28D9);
  
  // Badge colors - Paid
  static const paidBg = Color(0xFFF5B942);
  static const paidText = Color(0xFF4A2E0A);
  static const paidBgLight = Color(0xFFFEF3C7);
  static const paidTextLight = Color(0xFF92400E);
  
  // Badge colors - Free
  static const freeBg = Color(0xFF1E3B2E);
  static const freeText = Color(0xFF4ADE80);
  static const freeBgLight = Color(0xFFDCFCE7);
  static const freeTextLight = Color(0xFF166534);
  
  // Avatar gradients
  static const avatarTeal = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const avatarPurple = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const avatarOrange = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const avatarNavy = LinearGradient(
    colors: [Color(0xFF334155), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const avatarPink = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const avatarGreen = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const avatarBlue = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Category icon gradients
  static const categoryPurpleMagenta = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const categoryPinkRed = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const categoryBluePurple = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const categoryBlueCyan = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradients
  static const gradientPrimary = LinearGradient(
    colors: [purplePrimary, purpleDark],
  );
  
  static const gradientLogo = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
