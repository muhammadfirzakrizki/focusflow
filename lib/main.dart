import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/database/powersync_config.dart'; // Import config baru

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("DEBUG: Memulai Init DB...");

  // Beri timeout 5 detik agar tidak stuck selamanya
  await PowerSyncConfig.init().timeout(
    const Duration(seconds: 5),
    onTimeout: () {
      print("DEBUG: Init DB kelamaan!");
    },
  );

  print("DEBUG: Menjalankan runApp...");
  runApp(const ProviderScope(child: FocusFlowApp()));
}
