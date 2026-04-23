import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';
import '../widgets/empty_task_view.dart';
import '../widgets/task_card.dart';
import '../../../settings/presentation/pages/settings_screen.dart';
import 'add_task_screen.dart';
import 'timer_screen.dart';
import '../../../../core/ui_kit/app_loading_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Fungsi navigasi tetap ada, tapi logic simpan dipindah ke ref.read
  Future<void> _navigateToAddTask(
    BuildContext context,
    WidgetRef ref, {
    TaskEntity? task,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen(task: task)),
    );

    if (!context.mounted) return;

    if (result != null && result is TaskEntity) {
      await _saveTask(context, ref, result);
    }
  }

  Future<void> _saveTask(
    BuildContext context,
    WidgetRef ref,
    TaskEntity task,
  ) async {
    debugPrint(
      '_saveTask called: ${task.id} - remainingDurationMs: ${task.remainingDurationMs}, isDone: ${task.isDone}',
    );
    try {
      await ref.read(taskControllerProvider).saveTask(task);
      debugPrint('Save completed for: ${task.id}');
    } catch (e) {
      debugPrint('Save failed: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan task.')));
    }
  }

  Future<void> _deleteTask(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    try {
      await ref.read(taskControllerProvider).deleteById(id);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menghapus task.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mendengarkan data dari PowerSync secara Real-time
    final tasksAsync = ref.watch(taskListStreamProvider);
    final isSaving = ref.watch(taskControllerProvider).isLoading;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      // Menggunakan pola .when untuk menangani state data
      body: tasksAsync.when(
        data: (tasks) => tasks.isEmpty
            ? EmptyTaskView(onAddTask: () => _navigateToAddTask(context, ref))
            : _buildTaskList(tasks, ref),
        loading: () => isSaving
            ? const AppLoadingOverlay(isLoading: true, child: SizedBox.expand())
            : const Center(child: CircularProgressIndicator()),
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

  Widget _buildTaskList(List<TaskEntity> tasks, WidgetRef ref) {
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
            onDelete: (id) => _deleteTask(context, ref, id),
            onEditStatus: (_, updatedTask) async {
              debugPrint(
                'Reset task: ${updatedTask.id} - remaining: ${updatedTask.remainingDurationMs}',
              );
              await _saveTask(context, ref, updatedTask);
            },
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
