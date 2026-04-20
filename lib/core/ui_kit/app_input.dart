import 'package:flutter/material.dart';

class AppInput {
  // Style dekorasi untuk TextFormField
  static InputDecoration decoration({
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 22),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      floatingLabelStyle: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),

      // Padding di dalam input
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      // Border saat kondisi normal
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),

      // Border saat diklik (Focus)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),

      // Border saat terjadi Error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),

      filled: true,
      fillColor: colorScheme.surface,
    );
  }
}
