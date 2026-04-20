import 'package:flutter/material.dart';
import 'dart:math' as math;

class FocusFlowEmptyPainter extends StatelessWidget {
  final Color color;
  final double size;

  const FocusFlowEmptyPainter({
    super.key,
    required this.color,
    this.size = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FlowPainter(color: color),
    );
  }
}

class _FlowPainter extends CustomPainter {
  final Color color;
  _FlowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 1. Lingkaran Luar (Garis Putus-putus Melingkar)
    paint.strokeWidth = 1.5;
    paint.color = color.withValues(alpha: 0.2);
    canvas.drawCircle(center, size.width * 0.45, paint);

    // 2. Aset Utama: Double Organic Arcs (Efek Mengalir)
    paint.strokeWidth = 3.0;
    paint.color = color.withValues(alpha: 0.6);

    // Arc 1
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.35),
      -math.pi / 2,
      1.5 * math.pi,
      false,
      paint,
    );

    // Arc 2 (Lebih kecil di dalam)
    paint.strokeWidth = 2.0;
    paint.color = color.withValues(alpha: 0.4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.25),
      math.pi / 4,
      math.pi,
      false,
      paint,
    );

    // 3. Titik Pusat (Focus Point)
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _FlowPainter oldDelegate) =>
      oldDelegate.color != color;
}
