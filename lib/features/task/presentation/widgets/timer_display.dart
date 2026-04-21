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

    // Perbaikan Font Size Dinamis
    double dynamicFontSize;
    if (formattedTime.length > 7) {
      dynamicFontSize = 44;
    } else if (formattedTime.length > 5) {
      dynamicFontSize = 50;
    } else {
      dynamicFontSize = 64;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Glow
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isRunning ? colorScheme.primary : colorScheme.secondary)
                .withAlpha(8), // Sekitar 0.03 alpha
          ),
        ),

        // Lingkaran Progress dengan Animasi Halus
        SizedBox(
          width: 280,
          height: 280,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: progress, end: progress),
            duration: const Duration(
              milliseconds: 500,
            ), // Animasi pergerakan progress
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: isRunning ? colorScheme.primary : colorScheme.secondary,
                strokeCap: StrokeCap.round,
              );
            },
          ),
        ),

        // Teks Waktu
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            formattedTime,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: dynamicFontSize,
              fontWeight: FontWeight.w200, // Light weight bikin kesan elegan
              fontFamily: 'monospace',
              color: colorScheme.onSurface,
              letterSpacing: -2,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
