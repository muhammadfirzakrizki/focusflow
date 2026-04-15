import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';

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

  void _finishTask() {
    _timer?.cancel();

    // Buat objek baru dengan status isDone = true
    final completedTask = TaskModel(
      id: widget.task.id,
      title: widget.task.title,
      description: widget.task.description,
      duration: widget.task.duration,
      isDone: true,
    );

    _showFinishedDialog(completedTask);
  }

  @override
  void initState() {
    super.initState();
    // Konversi durasi menit dari model ke detik
    _secondsRemaining = widget.task.duration;
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      // Pastikan jika waktu sudah 0 dan ditekan MULAI lagi, dia reset ke awal
      if (_secondsRemaining <= 0) {
        _secondsRemaining = widget.task.duration;
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          timer.cancel(); // Lebih aman pakai parameter timer dari callback
          setState(() {
            _isRunning = false;
          });
          _showFinishedDialog();
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _showFinishedDialog([TaskModel? completedTask]) {
    // 1. Pastikan kita punya objek task yang statusnya isDone = true
    final taskToReturn =
        completedTask ??
        TaskModel(
          id: widget.task.id,
          title: widget.task.title,
          description: widget.task.description,
          duration: widget.task.duration,
          isDone: true, // Paksa jadi true di sini
        );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.stars, color: Colors.amber, size: 50),
            SizedBox(height: 10),
            Text("Luar Biasa!", textAlign: TextAlign.center),
          ],
        ),
        content: Text(
          "Kamu telah berhasil fokus pada '${taskToReturn.title}' selama ${taskToReturn.duration} detik.",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog

              // 2. KRUSIAL: Kirim objek taskToReturn, BUKAN cuma 'true'
              Navigator.pop(context, taskToReturn);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("KEMBALI KE BERANDA"),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTimeUp = _secondsRemaining == 0;
    final double progress = _secondsRemaining / (widget.task.duration);

    return Scaffold(
      appBar: AppBar(title: const Text("Sesi Fokus")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.task.description,
              style: const TextStyle(color: Colors.grey),
            ),
            // Tampilan status berbeda jika sudah selesai
            Text(
              isTimeUp ? "Sesi Selesai!" : "Sedang Fokus...",
              style: TextStyle(
                color: isTimeUp ? Colors.green : Colors.grey,
                fontWeight: isTimeUp ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 50),

            // Visual Timer Ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    // Berubah warna saat selesai
                    color: isTimeUp ? Colors.green : Colors.deepPurple,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  _formatTime(_secondsRemaining),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: isTimeUp ? Colors.green : Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            // Tombol Kontrol
            // Tombol Kontrol
            Column(
              // Gunakan Column agar tombol bisa disusun vertikal atau Row untuk horizontal
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tombol Utama (Mulai / Pause)
                    ElevatedButton.icon(
                      onPressed: isTimeUp
                          ? null
                          : _toggleTimer, // Disable jika sudah nol
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        backgroundColor: _isRunning
                            ? Colors.orange.shade100
                            : Colors.deepPurple,
                        foregroundColor: _isRunning
                            ? Colors.orange.shade900
                            : Colors.white,
                      ),
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(_isRunning ? "PAUSE" : "MULAI"),
                    ),
                    const SizedBox(width: 12),

                    // Tombol Selesai Sekarang (Selalu Muncul)
                    ElevatedButton.icon(
                      onPressed: _finishTask, // Langsung panggil fungsi dialog
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("SELESAI"),
                    ),
                  ],
                ),

                // Tombol Reset (Muncul saat tidak berjalan)
                if (!_isRunning && _secondsRemaining < widget.task.duration)
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _secondsRemaining = widget.task.duration);
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text("Reset Waktu"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
