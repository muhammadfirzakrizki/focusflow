import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui_kit/app_loading_state.dart';
import '../providers/theme_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isSaving = ref.watch(themeControllerProvider).isLoading;

    final isDark = themeModeAsync.maybeWhen(
      data: (mode) => mode == ThemeMode.dark,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: AppLoadingOverlay(
        isLoading: isSaving,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Text(
              'TAMPILAN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: colorScheme.primary, // Warna teks mengikuti theme
              ),
            ),
            const SizedBox(height: 12),

            // Card yang warnanya dinamis sesuai theme
            Material(
              color: colorScheme
                  .surfaceContainerHigh, // Mengikuti container theme M3
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _toggleTheme(ref, isDark),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Lingkaran ikon dengan warna primary theme
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            isDark ? Icons.dark_mode : Icons.wb_sunny,
                            key: ValueKey(isDark),
                            color: colorScheme.onPrimaryContainer,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isDark ? 'Dark Mode' : 'Light Mode',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              'Ketuk untuk ganti tema',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Switch modern
                      Switch(
                        value: isDark,
                        onChanged: (_) => _toggleTheme(ref, isDark),
                        activeThumbColor: colorScheme.primary,
                        activeTrackColor: colorScheme.primaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTheme(WidgetRef ref, bool isCurrentlyDark) {
    HapticFeedback.lightImpact();
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    ref.read(themeControllerProvider.notifier).setThemeMode(newMode);
  }
}
