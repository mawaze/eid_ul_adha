import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Floating/twinkling star particles for backgrounds.
class StarField extends StatefulWidget {
  final int starCount;
  final Color starColor;
  final double maxRadius;

  const StarField({
    super.key,
    this.starCount = 30,
    this.starColor = Colors.white,
    this.maxRadius = 2.5,
  });

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_StarData> _stars;
  final _rng = math.Random(42);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _stars = List.generate(widget.starCount, (i) => _StarData(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      radius: _rng.nextDouble() * widget.maxRadius + 0.5,
      phase: _rng.nextDouble() * math.pi * 2,
      speed: _rng.nextDouble() * 0.6 + 0.4,
    ));
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
      builder: (_, __) => CustomPaint(
        painter: _StarPainter(
          stars: _stars,
          progress: _ctrl.value,
          color: widget.starColor,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _StarData {
  final double x, y, radius, phase, speed;
  const _StarData({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
    required this.speed,
  });
}

class _StarPainter extends CustomPainter {
  final List<_StarData> stars;
  final double progress;
  final Color color;

  const _StarPainter({
    required this.stars,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final opacity = (0.3 +
              0.7 * math.sin(s.phase + progress * math.pi * 2 * s.speed)
                  .abs())
          .clamp(0.2, 1.0);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.radius,
        Paint()..color = color.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.progress != progress;
}
