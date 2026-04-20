import 'package:flutter/material.dart';
import 'package:focus_flow/core/widgets/focus_flow_painter_asset.dart';

class EmptyTaskView extends StatelessWidget {
  final VoidCallback onAddTask;

  const EmptyTaskView({super.key, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Visual Asset Custom Paint
            FocusFlowEmptyPainter(
              size: 180,
              color: colorScheme.primary, // Otomatis ikut warna utama app
            ),

            const SizedBox(height: 32),

            Text(
              "Deep Focus Awaits",
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Daftar targetmu kosong. Siap untuk memulai aliran produktivitas baru?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            // Tombol opsional yang minimalis
            OutlinedButton.icon(
              onPressed: onAddTask, // Panggil fungsi callback di sini
              icon: const Icon(Icons.add_rounded),
              label: const Text("Buat Target Pertama"),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.outlineVariant),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
