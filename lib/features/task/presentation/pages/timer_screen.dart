import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../widgets/timer_display.dart';
import 'package:focus_flow/core/ui_kit/app_button.dart';
import 'package:focus_flow/core/ui_kit/app_sheet.dart';

class TimerScreen extends StatefulWidget {
  final TaskModel task;
  const TimerScreen({super.key, required this.task});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.task.duration;
  }

  // --- LOGIC PERIPHERALS ---

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

    // Menggunakan copyWith dari Model agar data konsisten
    final completedTask = widget.task.copyWith(isDone: true);
    _showFinishedDialog(completedTask);
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // --- UI COMPONENTS ---

  void _showFinishedDialog(TaskModel completedTask) {
    AppSheet.showConfirmation(
      context: context,
      title: "Luar Biasa!",
      description:
          "Sesi fokus '${completedTask.title}' telah selesai. Kamu selangkah lebih dekat dengan tujuanmu.",
      icon: Icons.stars_rounded,
      confirmLabel: "KEMBALI KE BERANDA",
      // Kamu bisa kustom warna di sini, misal warna emas agar terasa premium
      confirmColor: Colors.amber.shade700,
      onConfirm: () {
        // Karena Navigator.pop(context) sudah dijalankan di dalam AppSheet,
        // kita tinggal menjalankan Navigator.pop untuk balik ke Home bawa data.
        Navigator.pop(context, completedTask);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Sesi Fokus")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Header: Judul & Deskripsi
            _buildHeader(colorScheme),

            const Spacer(),

            // Timer: Lingkaran & Angka (Modular Widget)
            TimerDisplay(
              progress: _secondsRemaining / widget.task.duration,
              formattedTime: _formatTime(_secondsRemaining),
              isRunning: _isRunning,
            ),

            const Spacer(),

            // Kontrol: Play, Pause, Reset
            _buildActionControls(colorScheme),

            const SizedBox(height: 12),

            // Tombol Skip / Selesaikan Manual
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
        // Tombol reset hanya muncul jika timer sedang berhenti dan sudah sempat berjalan
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
