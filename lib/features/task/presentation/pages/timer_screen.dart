import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Tambahkan Riverpod
import '../../data/models/task_model.dart';
import '../../../../providers/task/task_provider.dart'; // Import provider kamu
import '../widgets/timer_display.dart';
import 'package:focus_flow/core/ui_kit/app_button.dart';
import 'package:focus_flow/core/ui_kit/app_sheet.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final TaskModel task;
  const TimerScreen({super.key, required this.task});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.task.duration;
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _finishTask();
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _finishTask() {
    _timer?.cancel();
    setState(() => _isRunning = false);

    final completedTask = widget.task.copyWith(isDone: true);

    // UPDATE DATABASE LANGSUNG
    ref.read(taskControllerProvider.notifier).addTask(completedTask);

    _showFinishedDialog(completedTask);
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showFinishedDialog(TaskModel completedTask) {
    AppSheet.showConfirmation(
      context: context,
      title: "Luar Biasa!",
      description:
          "Sesi fokus '${completedTask.title}' telah selesai. Kamu selangkah lebih dekat dengan tujuanmu.",
      icon: Icons.stars_rounded,
      confirmLabel: "KEMBALI KE BERANDA",
      confirmColor: Colors.amber.shade700,
      onConfirm: () {
        // Cukup pop sekali untuk kembali ke Home
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sesi Fokus"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildHeader(colorScheme),
            const Spacer(),
            TimerDisplay(
              progress: _secondsRemaining / widget.task.duration,
              formattedTime: _formatTime(_secondsRemaining),
              isRunning: _isRunning,
            ),
            const Spacer(),
            _buildActionControls(colorScheme),
            const SizedBox(height: 12),
            _buildSkipButton(colorScheme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          widget.task.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          widget.task.description,
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildActionControls(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: _isRunning ? "PAUSE" : "MULAI",
            icon: _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            backgroundColor: _isRunning ? Colors.orange : colorScheme.primary,
            onPressed: _toggleTimer,
          ),
        ),
        if (!_isRunning && _secondsRemaining < widget.task.duration) ...[
          const SizedBox(width: 12),
          IconButton.filledTonal(
            onPressed: () =>
                setState(() => _secondsRemaining = widget.task.duration),
            icon: const Icon(Icons.refresh_rounded),
            padding: const EdgeInsets.all(16),
          ),
        ],
      ],
    );
  }

  Widget _buildSkipButton(ColorScheme colorScheme) {
    return TextButton(
      onPressed: _finishTask,
      child: Text(
        "Selesaikan Sekarang",
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
