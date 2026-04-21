import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class CompleteTaskUseCase {
  final TaskRepository repository;

  CompleteTaskUseCase(this.repository);

  Future<void> execute(TaskEntity task) async {
    // Di sini kamu bisa tambah logika bisnis tambahan, misalnya:
    // "Hanya bisa diselesaikan jika waktu sudah lewat dari jam tertentu"
    final completedTask = task.copyWith(isDone: true);

    return await repository.saveTask(completedTask);
  }
}
