import 'package:flutter/material.dart';
import 'app_button.dart';

class AppSheet {
  static Future<void> showConfirmation({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required String confirmLabel,
    required VoidCallback onConfirm,
    Color? confirmColor,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),

            // Icon Header
            CircleAvatar(
              radius: 40,
              backgroundColor:
                  (confirmColor ?? Theme.of(context).colorScheme.primary)
                      .withValues(alpha: 0.1),
              child: Icon(
                icon,
                size: 40,
                color: confirmColor ?? Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Main Action
            AppButton(
              label: confirmLabel,
              icon: Icons.check_rounded,
              backgroundColor: confirmColor,
              onPressed: () {
                onConfirm();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),

            // Cancel Action
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Batal",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
