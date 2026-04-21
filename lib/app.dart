import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/task/presentation/pages/home_screen.dart';

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Flow',
      debugShowCheckedModeBanner: false,

      // 🌗 Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // 🧭 Navigation (future-ready)
      home: const HomeScreen(),
      // Agar scroll terasa natural di semua device
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      // 💡 Optional (biar UX lebih halus)
      themeAnimationDuration: const Duration(milliseconds: 200),
    );
  }
}
