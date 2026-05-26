import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Draws layered Islamic geometric pattern (hexagonal star rings + dots)
/// as a decorative overlay on the hero card.
class IslamicPatternPainter extends CustomPainter {
  final double opacity;
  final Color color;

  const IslamicPatternPainter({
    this.opacity = 0.14,
    this.color = AppColors.goldPrimary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final cx = size.width * 0.72;
    final cy = size.height * 0.35;

    // Concentric hexagon rings
    for (int ring = 1; ring <= 3; ring++) {
      final r = ring * 28.0;
      final path = Path();
      for (int i = 0; i < 6; i++) {
        final angle = (math.pi / 3) * i - math.pi / 6;
        final x = cx + r * math.cos(angle);
        final y = cy + r * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint..strokeWidth = (0.9 - ring * 0.2).clamp(0.3, 0.9));
    }

    // Radial lines from centre
    for (int i = 0; i < 12; i++) {
      final angle = (math.pi / 6) * i;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + 84 * math.cos(angle), cy + 84 * math.sin(angle)),
        paint
          ..strokeWidth = 0.4
          ..color = color.withOpacity(opacity * 0.6),
      );
    }

    // Scatter small star dots
    final dotPaint = Paint()
      ..color = color.withOpacity(opacity * 1.8)
      ..style = PaintingStyle.fill;

    const dots = [
      Offset(0.12, 0.15), Offset(0.28, 0.08), Offset(0.42, 0.20),
      Offset(0.15, 0.75), Offset(0.88, 0.78), Offset(0.92, 0.22),
    ];
    for (final d in dots) {
      canvas.drawCircle(
        Offset(size.width * d.dx, size.height * d.dy), 2, dotPaint,
      );
    }

    // Bottom-left mini motif
    final blx = size.width * 0.14;
    final bly = size.height * 0.82;
    final smallPaint = Paint()
      ..color = color.withOpacity(opacity * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    canvas.drawCircle(Offset(blx, bly), 18, smallPaint);
    canvas.drawCircle(Offset(blx, bly), 10, smallPaint);
    canvas.drawLine(Offset(blx - 18, bly), Offset(blx + 18, bly), smallPaint);
    canvas.drawLine(Offset(blx, bly - 18), Offset(blx, bly + 18), smallPaint);
  }

  @override
  bool shouldRepaint(IslamicPatternPainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.color != color;
}
