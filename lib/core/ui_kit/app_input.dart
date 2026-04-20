import 'package:flutter/material.dart';

class AppInput {
  // Style dekorasi untuk TextFormField
  static InputDecoration decoration({
    required String label,
    IconData? icon,
    required ColorScheme colorScheme,
    bool isError = false, // TAMBAHKAN PARAMETER INI (default false)
  }) {
    // Tentukan warna border berdasarkan status error
    final borderColor = isError
        ? colorScheme.error
        : colorScheme.outlineVariant;
    final borderWidth = isError ? 2.0 : 1.0; // Sedikit tebal jika error

    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, size: 22) : null,
      labelStyle: TextStyle(
        // Label ikut merah jika error
        color: isError ? colorScheme.error : colorScheme.onSurfaceVariant,
      ),
      floatingLabelStyle: TextStyle(
        // Floating label tetap primer saat fokus, kecuali error
        color: isError ? colorScheme.error : colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      // BORDER SAAT KONDISI NORMAL (enabled)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        // Gunakan warna dinamis di sini
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),

      // BORDER SAAT DIKLIK (Focused)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        // Jika error, tetap merah. Jika normal, pakai warna primer.
        borderSide: BorderSide(
          color: isError ? colorScheme.error : colorScheme.primary,
          width: 2,
        ),
      ),

      // Border bawaan untuk error individual (tetap pertahankan)
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
