import '../entities/task_entity.dart';

abstract class TaskRepository {
  Stream<List<TaskEntity>> watchTasks();
  Future<void> saveTask(TaskEntity task);
  Future<void> deleteTask(String id);
}
