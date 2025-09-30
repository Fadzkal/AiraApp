// lib/widgets/trend_chart_painter.dart

import 'package:flutter/material.dart';

class TrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // DIPERBAIKI: Menggunakan variabel 'paint' untuk menggambar
    final paint = Paint()
      ..color = const Color(0xFF4DD0E1) // DITAMBAH: const untuk performa
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // DIPERBAIKI: Menggunakan variabel 'path' untuk menggambar
    final path = Path();

    // Sample data points for trend line
    List<Offset> points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.5),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.45, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width * 0.9, size.height * 0.3),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // DIPERBAIKI: Menggambar path ke canvas
    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint = Paint()
      ..color = const Color(0xFF00BCD4) // DITAMBAH: const untuk performa
      ..style = PaintingStyle.fill;

    for (Offset point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      double y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
