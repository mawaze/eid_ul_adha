import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Animated crescent moon that gently pulses.
class CrescentMoon extends StatefulWidget {
  final double size;
  final Color color;

  const CrescentMoon({
    super.key,
    this.size = 48,
    this.color = AppColors.goldPrimary,
  });

  @override
  State<CrescentMoon> createState() => _CrescentMoonState();
}

class _CrescentMoonState extends State<CrescentMoon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _glow = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _MoonPainter(
            color: widget.color,
            glowOpacity: _glow.value * 0.18,
          ),
        ),
      ),
    );
  }
}

class _MoonPainter extends CustomPainter {
  final Color color;
  final double glowOpacity;

  const _MoonPainter({required this.color, required this.glowOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Glow halo
    final glowPaint = Paint()
      ..color = color.withOpacity(glowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(w * 0.42, h * 0.5), w * 0.42, glowPaint);

    // Moon crescent path
    final moonPaint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(w * 0.18, h * 0.08)
      ..quadraticBezierTo(w * -0.12, h * 0.5, w * 0.18, h * 0.92)
      ..quadraticBezierTo(w * 0.52, h * 0.72, w * 0.48, h * 0.5)
      ..quadraticBezierTo(w * 0.52, h * 0.28, w * 0.18, h * 0.08)
      ..close();
    canvas.drawPath(path, moonPaint);

    // Small accent star
    final starPaint = Paint()
      ..color = color.withOpacity(0.75)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.68, h * 0.28), w * 0.06, starPaint);
  }

  @override
  bool shouldRepaint(_MoonPainter old) => old.glowOpacity != glowOpacity;
}
