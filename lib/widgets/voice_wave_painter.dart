// lib/widgets/voice_wave_painter.dart

import 'dart:math'; // DIPERBAIKI: Ternyata math dibutuhkan untuk 'sin' dan 'pi'
import 'package:flutter/material.dart';

class VoiceWavePainter extends CustomPainter {
  final double animationValue;
  final bool isActive;

  VoiceWavePainter({required this.animationValue, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    // DIPERBAIKI: Menggunakan variabel 'paint'
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final centerX = size.width / 2;

    if (isActive) {
      // Draw animated sound waves
      for (int i = 0; i < 5; i++) {
        // 'sin' dan 'pi' berasal dari 'dart:math', jadi import dibutuhkan
        double waveHeight = sin((animationValue * 2 * pi) + i) * 20 + 10;
        double x = centerX + (i - 2) * 15;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(x, centerY),
              width: 4,
              height: waveHeight,
            ),
            const Radius.circular(2),
          ),
          paint, // Variabel paint digunakan di sini
        );
      }
    } else {
      // Draw static microphone icon
      canvas.drawCircle(
        Offset(centerX, centerY),
        30,
        paint..color = Colors.white.withOpacity(0.3),
      );

      // Microphone shape
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, centerY - 5),
            width: 20,
            height: 30,
          ),
          const Radius.circular(10),
        ),
        paint..color = Colors.white,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 15),
          width: 2,
          height: 15,
        ),
        paint,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 25),
          width: 20,
          height: 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(VoiceWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isActive != isActive;
  }
}
