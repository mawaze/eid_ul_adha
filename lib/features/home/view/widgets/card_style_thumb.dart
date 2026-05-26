import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class CardStyleThumb extends StatelessWidget {
  final String styleName;
  final bool isSelected;
  final VoidCallback onTap;

  const CardStyleThumb({
    super.key,
    required this.styleName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.cardThemes[styleName] ??
        [AppColors.emeraldDeep, AppColors.emeraldMid];
    final isIvory = styleName == 'Ivory';
    final textColor =
        isIvory ? const Color(0xFF7A6A4A) : const Color(0xFFD8C890);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppDimensions.durationMid),
        curve: Curves.easeInOut,
        width: AppDimensions.cardStyleThumbSize,
        height: AppDimensions.cardStyleThumbSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isSelected
                ? AppColors.goldPrimary
                : Colors.transparent,
            width: isSelected ? 2.2 : 0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.goldPrimary.withOpacity(0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            styleName,
            style: GoogleFonts.playfairDisplay(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
