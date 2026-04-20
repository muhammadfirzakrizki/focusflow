import 'package:flutter/material.dart';

class EmptyTaskView extends StatelessWidget {
  const EmptyTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita ambil warna dari theme yang sudah kamu buat tadi
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.nights_stay_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada target fokus hari ini.",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
