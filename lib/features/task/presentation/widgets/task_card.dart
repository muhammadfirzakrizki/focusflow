import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import 'package:focus_flow/core/ui_kit/app_sheet.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  // Hapus parameter index karena kita pakai task.id sekarang
  final Function(String) onDelete;
  final Function(String, TaskModel) onEditStatus;
  final VoidCallback onTap;
  final VoidCallback onEditPressed;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEditStatus,
    required this.onTap,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color statusColor = task.isDone ? Colors.green : colorScheme.primary;

    return Dismissible(
      key: ValueKey(task.id), // Sangat penting untuk PowerSync/SQLite
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        bool shouldDelete = false;
        await AppSheet.showConfirmation(
          context: context,
          title: "Hapus Fokus?",
          description: "Tugas '${task.title}' akan dihapus secara permanen.",
          icon: Icons.delete_sweep_rounded,
          confirmLabel: "YA, HAPUS",
          confirmColor: colorScheme.error,
          onConfirm: () => shouldDelete = true,
        );
        return shouldDelete;
      },
      // Mengirim task.id ke fungsi onDelete
      onDismissed: (_) => onDelete(task.id),
      background: _buildDeleteBackground(colorScheme),

      child: Opacity(
        opacity: task.isDone ? 0.7 : 1.0,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: statusColor.withAlpha(
                128,
              ), // Mengganti .withValues agar lebih kompatibel
              width: task.isDone ? 2 : 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: statusColor.withAlpha(25),
              child: Icon(
                task.isDone ? Icons.check_rounded : Icons.timer_outlined,
                color: statusColor,
                size: 20,
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
                color: task.isDone
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              task.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: !task.isDone
                ? IconButton(
                    icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                    onPressed: onEditPressed,
                  )
                : null,
            onTap: () {
              if (task.isDone) {
                _showResetDialog(context);
              } else {
                onTap();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteBackground(ColorScheme colorScheme) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    AppSheet.showConfirmation(
      context: context,
      title: "Kerjakan Lagi?",
      description:
          "Tugas '${task.title}' sudah selesai. Mau diulang dari awal?",
      icon: Icons.refresh_rounded,
      confirmLabel: "YA, ULANGI",
      confirmColor: Theme.of(context).colorScheme.secondary,
      onConfirm: () {
        final unDoneTask = task.copyWith(isDone: false);
        // Mengirim task.id ke fungsi onEditStatus
        onEditStatus(task.id, unDoneTask);
      },
    );
  }
}
