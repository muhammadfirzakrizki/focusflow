import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/theme_local_datasource.dart';

final themeDataSourceProvider = Provider<ThemeLocalDataSource>((ref) {
  return ThemeLocalDataSource();
});

final themeModeProvider = StreamProvider<ThemeMode>((ref) {
  return ref.watch(themeDataSourceProvider).watchThemeMode();
});

class ThemeController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> setThemeMode(ThemeMode mode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Simulasi delay 5 detik untuk menguji loading state overlay
      // await Future.delayed(const Duration(seconds: 5));
      await ref.read(themeDataSourceProvider).saveThemeMode(mode);
    });
  }
}

final themeControllerProvider = AsyncNotifierProvider<ThemeController, void>(
  ThemeController.new,
);
