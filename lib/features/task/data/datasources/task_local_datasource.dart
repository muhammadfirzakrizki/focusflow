import '../../../../core/database/powersync_config.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  /// Mengambil data secara reaktif (Stream).
  /// Setiap kali ada perubahan di database, UI akan otomatis update.
  Stream<List<TaskModel>> watchTasks() {
    return db
        .watch('SELECT * FROM tasks ORDER BY created_at DESC')
        .map((results) {
          return results.map((row) => TaskModel.fromMap(row)).toList();
        });
  }

  /// Mengambil semua task sekali panggil (Future).
  Future<List<TaskModel>> getAllTasks() async {
    final results = await db.getAll(
      'SELECT * FROM tasks ORDER BY created_at DESC',
    );
    return results.map((row) => TaskModel.fromMap(row)).toList();
  }

  /// Menambah atau mengupdate task (Upsert).
  Future<void> saveTask(TaskModel task) async {
    await db.execute(
      '''
      INSERT OR REPLACE INTO tasks (id, title, description, is_done, duration, created_at)
      VALUES (?, ?, ?, ?, ?, ?)
      ''',
      [
        task.id,
        task.title,
        task.description,
        task.isDone ? 1 : 0,
        task.duration,
        task.createdAt.toIso8601String(),
      ],
    );
  }

  /// Menghapus task berdasarkan ID.
  Future<void> deleteTask(String id) async {
    await db.execute('DELETE FROM tasks WHERE id = ?', [id]);
  }

  /// Mengubah status isDone secara cepat.
  Future<void> toggleTaskStatus(String id, bool isDone) async {
    await db.execute(
      'UPDATE tasks SET is_done = ? WHERE id = ?',
      [isDone ? 1 : 0, id],
    );
  }
}
