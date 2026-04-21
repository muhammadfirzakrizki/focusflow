import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:powersync/powersync.dart';
// 1. Import file config tempat variabel 'db' berada
import '../core/database/powersync_config.dart';

import '../features/task/data/repositories/task_repository_impl.dart';
import '../features/task/domain/repositories/task_repository.dart';
import '../features/task/domain/usecases/complete_task_usecase.dart';

// 1. Provider untuk Database
final dbProvider = Provider<PowerSyncDatabase>((ref) {
  // 2. Langsung return variabel 'db' global dari powersync_config.dart
  return db;
});

// 2. Provider untuk Repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final database = ref.watch(dbProvider);
  return TaskRepositoryImpl(database);
});

// 3. Provider untuk UseCase
final completeTaskUseCaseProvider = Provider((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return CompleteTaskUseCase(repository);
});
