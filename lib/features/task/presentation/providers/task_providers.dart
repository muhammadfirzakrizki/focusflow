import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:powersync/powersync.dart';

import '../../../../core/database/powersync_config.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/complete_task_usecase.dart';

final dbProvider = Provider<PowerSyncDatabase>((ref) => db);

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final database = ref.watch(dbProvider);
  return TaskRepositoryImpl(database);
});

final completeTaskUseCaseProvider = Provider<CompleteTaskUseCase>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return CompleteTaskUseCase(repository);
});

final taskListStreamProvider = StreamProvider<List<TaskEntity>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTasks();
});

class TaskController {
  TaskController(this._repository, this._completeTaskUseCase);

  final TaskRepository _repository;
  final CompleteTaskUseCase _completeTaskUseCase;

  Object? get isLoading => null;

  Future<void> saveTask(TaskEntity task) {
    debugPrint(
      'TaskController.saveTask: ${task.id} - remaining: ${task.remainingDurationMs}',
    );
    return _repository.saveTask(task);
  }

  Future<void> deleteById(String id) {
    return _repository.deleteTask(id);
  }

  Future<void> toggleStatus(TaskEntity task) {
    return _repository.saveTask(
      task.copyWith(
        isDone: !task.isDone,
        remainingDurationMs: !task.isDone ? 0 : task.duration * 1000,
      ),
    );
  }

  Future<void> completeTask(TaskEntity task) {
    return _completeTaskUseCase.execute(task);
  }
}

final taskControllerProvider = Provider<TaskController>((ref) {
  return TaskController(
    ref.watch(taskRepositoryProvider),
    ref.watch(completeTaskUseCaseProvider),
  );
});
