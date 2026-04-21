import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../../../providers/task/task_provider.dart'; // Sesuaikan path provider kamu
import '../widgets/empty_task_view.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'timer_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Fungsi navigasi tetap ada, tapi logic simpan dipindah ke ref.read
  Future<void> _navigateToAddTask(
    BuildContext context,
    WidgetRef ref, {
    TaskModel? task,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen(task: task)),
    );

    if (result != null && result is TaskModel) {
      // Panggil controller untuk simpan ke PowerSync
      ref.read(taskControllerProvider.notifier).addTask(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mendengarkan data dari PowerSync secara Real-time
    final tasksAsync = ref.watch(taskListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FocusFlow',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      // Menggunakan pola .when untuk menangani state data
      body: tasksAsync.when(
        data: (tasks) => tasks.isEmpty
            ? EmptyTaskView(onAddTask: () => _navigateToAddTask(context, ref))
            : _buildTaskList(tasks, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddTask(context, ref),
        label: const Text(
          "Fokus Baru",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_rounded),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> tasks, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: tasks.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: TaskCard(
            task: task,
            onDelete: (idx) =>
                ref.read(taskControllerProvider.notifier).deleteById(task.id),
            onEditStatus: (idx, updatedTask) =>
                ref.read(taskControllerProvider.notifier).addTask(updatedTask),
            onEditPressed: () => _navigateToAddTask(context, ref, task: task),
            onTap: () {
              // Navigasi ke timer tetap pakai Navigator
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerScreen(task: task),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
