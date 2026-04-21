import 'package:powersync/powersync.dart';
import '../../../../core/database/powersync_config.dart' as core_db;

class DatabaseHelper {
  static PowerSyncDatabase get db => core_db.db;

  static Future<void> init() async {}
}
