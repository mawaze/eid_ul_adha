import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/crescent_moon.dart';
import '../../../../shared/widgets/islamic_pattern_painter.dart';
import '../../../../shared/widgets/star_field.dart';

class HeroWishCard extends StatefulWidget {
  final String cardStyle;

  const HeroWishCard({super.key, required this.cardStyle});

  @override
  State<HeroWishCard> createState() => _HeroWishCardState();
}

class _HeroWishCardState extends State<HeroWishCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(HeroWishCard old) {
    super.didUpdateWidget(old);
    if (old.cardStyle != widget.cardStyle) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.cardThemes[widget.cardStyle] ??
        [AppColors.emeraldDeep, const Color(0xFF152E24)];
    final isIvory = widget.cardStyle == 'Ivory';
    final textColor = isIvory ? const Color(0xFF2E1A00) : AppColors.goldPale;
    final accentColor =
        isIvory ? const Color(0xFF7A6A3A) : AppColors.goldPrimary;
    final patternColor =
        isIvory ? const Color(0xFFBFAA7A) : AppColors.goldPrimary;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            boxShadow: [
              BoxShadow(
                color: colors.first.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Star field (skip on ivory)
                if (!isIvory)
                  StarField(
                    starCount: 22,
                    starColor: AppColors.goldLight,
                    maxRadius: 1.5,
                  ),

                // Geometric overlay
                CustomPaint(
                  painter: IslamicPatternPainter(
                    color: patternColor,
                    opacity: isIvory ? 0.08 : 0.14,
                  ),
                ),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CrescentMoon(size: 44),
                      const SizedBox(height: 14),
                      Text(
                        AppStrings.homeGreeting,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.homeMubarak,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: accentColor,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Decorative divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 36,
                              height: 0.7,
                              color: accentColor.withOpacity(0.55)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: accentColor,
                              ),
                            ),
                          ),
                          Container(
                              width: 36,
                              height: 0.7,
                              color: accentColor.withOpacity(0.55)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Arabic footer
                      Text(
                        AppStrings.splashArabic,
                        style: GoogleFonts.scheherazadeNew(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
