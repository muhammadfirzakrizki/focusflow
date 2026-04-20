import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final double progress;
  final String formattedTime;
  final bool isRunning;

  const TimerDisplay({
    super.key,
    required this.progress,
    required this.formattedTime,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 1. Perbaikan Font Size Dinamis
    // HH:MM:SS biasanya 7-8 karakter. Kita buat lebih safe.
    double dynamicFontSize;
    if (formattedTime.length > 7) {
      dynamicFontSize = 44; // Sangat panjang (misal 10:00:00)
    } else if (formattedTime.length > 5) {
      dynamicFontSize = 50; // Format H:MM:SS
    } else {
      dynamicFontSize = 64; // Format MM:SS
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Glow (Opsional - Menambah kesan premium)
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isRunning ? colorScheme.primary : colorScheme.secondary)
                .withValues(alpha: 0.03),
          ),
        ),

        // Lingkaran Progress
        SizedBox(
          width: 280,
          height: 280,
          child: CircularProgressIndicator(
            // Balikkan value jika kamu ingin progress berkurang (Countdown)
            // Biasanya: 1.0 -> 0.0
            value: progress,
            strokeWidth: 12,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: isRunning ? colorScheme.primary : colorScheme.secondary,
            strokeCap: StrokeCap.round,
          ),
        ),

        // Teks Waktu
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            formattedTime,
            maxLines: 1, // Pastikan tidak membungkus ke bawah
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: dynamicFontSize,
              fontWeight: FontWeight.w200,
              fontFamily: 'monospace',
              color: colorScheme.onSurface,
              letterSpacing: -2, // Lebih rapat = lebih modern/elegant
              // Memastikan angka tetap di tengah meski font sizenya berubah
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
