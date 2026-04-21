import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 DaisyUI Color Palette (Contoh Tema: Modern/Corporate)
  static const Color _primary = Color(0xFF6C3FC5); // Primary
  static const Color _secondary = Color(0xFF9F7AEA);
  static const Color _accent = Color(0xFF37CDBE); // Accent/Info
  static const Color _neutral = Color(0xFF3D4451); // Neutral (untuk text/dark)
  static const Color _error = Color(0xFFF87272); // Error
  // static const Color _warning = Color(0xFFFBBD23); // Warning
  // static const Color _success = Color(0xFF36D399); // Success

  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _primary,
          primary: _primary,
          secondary: _secondary,
          tertiary: _accent, // Kita gunakan tertiary sebagai 'Accent'
          surface: const Color(0xFFFFFFFF),
          onSurface: _neutral,
          error: _error,
          brightness: Brightness.light,
        ).copyWith(
          // Info warna di Flutter biasanya diarahkan ke tertiary atau secondaryContainer
          secondaryContainer: _accent.withValues(alpha: 0.2),
          onSecondaryContainer: _accent,
        );

    return _baseTheme(colorScheme);
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      secondary: _secondary,
      tertiary: _accent,
      surface: const Color(0xFF1D232A), // DaisyUI Dark background
      onSurface: const Color(0xFFA6ADBB),
      error: _error,
      brightness: Brightness.dark,
    ).copyWith(surfaceContainerHighest: const Color(0xFF191E24));

    return _baseTheme(colorScheme);
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme().apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // 🔹 AppBar (Gaya DaisyUI: Clean & Bold)
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false, // Alignment kiri lebih DaisyUI
      ),

      // 🔹 Card (Gaya DaisyUI: Card Bordered)
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),

      // 🔹 FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 🔹 Button (Mirip Btn-Primary, Btn-Secondary di DaisyUI)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0, // DaisyUI rata-rata flat
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Lebih kotak khas DaisyUI
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // 🔹 Input Field (Gaya 'input-bordered')
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
