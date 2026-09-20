import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final double borderRadius;
  final List<Color>? gradientColors;

  const AppNetworkImage({
    super.key,
    this.imageUrl,
    required this.initials,
    required this.size,
    this.borderRadius = 16,
    this.gradientColors,
  });

  static const List<Color> _defaultGradients = [
    Color(0xFF14B8A6), Color(0xFF059669),
    Color(0xFF8B5CF6), Color(0xFF6366F1),
    Color(0xFFF97316), Color(0xFFEA580C),
    Color(0xFF334155), Color(0xFF1E293B),
    Color(0xFFEC4899), Color(0xFFDB2777),
    Color(0xFF22C55E), Color(0xFF16A34A),
    Color(0xFF3B82F6), Color(0xFF2563EB),
  ];

  static List<Color> getGradientForId(String id) {
    final index = int.tryParse(id) ?? 0;
    final i = (index - 1) * 2;
    if (i >= 0 && i + 1 < _defaultGradients.length) {
      return [_defaultGradients[i], _defaultGradients[i + 1]];
    }
    return [AppColors.purplePrimary, AppColors.pinkAccent];
  }

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? getGradientForId(initials);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _fallback(colors);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _fallback(colors),
        errorWidget: (context, url, error) => _fallback(colors),
      ),
    );
  }

  Widget _fallback(List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
