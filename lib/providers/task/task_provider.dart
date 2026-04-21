import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/task/data/datasources/task_local_datasource.dart';
import '../../features/task/data/models/task_model.dart';

part 'task_provider.g.dart';

/// Provider untuk akses DataSource secara global
@riverpod
TaskLocalDataSource taskDataSource(Ref ref) {
  return TaskLocalDataSource();
}

/// StreamProvider versi Riverpod 4 untuk data real-time dari PowerSync
@riverpod
Stream<List<TaskModel>> taskListStream(Ref ref) {
  final dataSource = ref.watch(taskDataSourceProvider);
  return dataSource.watchTasks();
}

/// Notifier untuk mengelola state dan interaksi (CRUD)
@riverpod
class TaskController extends _$TaskController {
  @override
  FutureOr<void> build() {
    // Initial state bisa kosong karena kita menggunakan taskListStream
    // untuk menampilkan data. Controller ini fokus ke logic aksi.
  }

  Future<void> addTask(TaskModel task) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(taskDataSourceProvider).saveTask(task);
    });
  }

  Future<void> deleteById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(taskDataSourceProvider).deleteTask(id);
    });
  }

  Future<void> toggleStatus(String id, bool currentStatus) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(taskDataSourceProvider)
          .toggleTaskStatus(id, !currentStatus);
    });
  }
}
