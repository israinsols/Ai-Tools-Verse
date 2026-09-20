import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/theme_helper.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const CustomSearchBar({
    super.key,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: context.cardBgSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.borderColor,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: context.textMuted,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: readOnly
                  ? Text(
                      hintText ?? 'Search AI tools...',
                      style: GoogleFonts.inter(
                        color: context.textMuted,
                        fontSize: 14,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      readOnly: readOnly,
                      style: GoogleFonts.inter(
                        color: context.textPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText ?? 'Search AI tools...',
                        hintStyle: GoogleFonts.inter(
                          color: context.textMuted,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
            ),
            if (!readOnly)
              Icon(
                Icons.tune,
                color: context.textMuted,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
