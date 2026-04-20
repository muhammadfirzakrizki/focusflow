import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/task_model.dart';
import '../widgets/empty_task_view.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Sekarang menggunakan List TaskModel
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Memuat data JSON dari memori dan merubahnya kembali jadi List Objek
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('saved_tasks_v2'); // Versi baru

    if (tasksJson != null) {
      final List<dynamic> decodedList = json.decode(tasksJson);
      setState(() {
        _tasks = decodedList.map((item) => TaskModel.fromMap(item)).toList();
      });
    }
  }

  // Merubah List Objek menjadi String JSON agar bisa disimpan
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _tasks.map((task) => task.toMap()).toList(),
    );
    await prefs.setString('saved_tasks_v2', encodedData);
  }

  void _addTask(TaskModel task) {
    setState(() {
      _tasks.add(task);
    });
    _saveTasks();
  }

  void _editTask(int index, TaskModel updatedTask) {
    setState(() {
      _tasks[index] = updatedTask;
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  // Fungsi untuk pindah ke halaman tambah/edit tugas
  Future<void> _navigateToAddTask({TaskModel? task, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen(task: task)),
    );

    if (result != null && result is TaskModel) {
      if (index != null) {
        _editTask(index, result); // Kalau dari tombol edit
      } else {
        _addTask(result); // Kalau dari tombol FAB (tambah baru)
      }
    }
  }

  // Fungsi untuk pindah ke halaman Timer
  Future<void> _navigateToTimer(TaskModel task, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerScreen(task: task)),
    );

    if (result != null && result is TaskModel) {
      _editTask(index, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Focus Flow',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _tasks.isEmpty ? const EmptyTaskView() : _buildTaskList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddTask(),
        label: const Text(
          "Fokus Baru",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_rounded),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        100,
      ), // Ruang ekstra di bawah untuk FAB
      itemCount: _tasks.length,
      physics: const BouncingScrollPhysics(), // Scroll ala iPhone yang kenyal
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final task = _tasks[index];

        // Animasi muncul staggered (satu-persatu)
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)), // Slide up effect
                child: child,
              ),
            );
          },
          child: TaskCard(
            task: task,
            index: index,
            onDelete: (idx) => _deleteTask(idx), // Panggil konfirmasi sheet
            onEditStatus: _editTask,
            onEditPressed: () => _navigateToAddTask(task: task, index: index),
            onTap: () => _navigateToTimer(task, index),
          ),
        );
      },
    );
  }
}
