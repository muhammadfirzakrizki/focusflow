import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import '../../features/task/data/datasources/task_schema.dart';

late final PowerSyncDatabase db;

class PowerSyncConfig {
  static Future<void> init() async {
    try {
      // 1. Ambil folder dokumen resmi di Android/iOS
      final dir = await getApplicationDocumentsDirectory();
      final path = join(dir.path, 'focus_flow.db');

      // 2. Inisialisasi Database dengan path absolut
      db = PowerSyncDatabase(schema: mySchema, path: path);

      print("DEBUG: Memulai db.initialize()...");
      await db.initialize();
      print("DEBUG: db.initialize() Selesai!");
    } catch (e) {
      print("DEBUG: Error saat init database: $e");
    }
  }
}
