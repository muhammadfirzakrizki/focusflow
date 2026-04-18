import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/screens/add_task_screen.dart';
import 'presentation/screens/timer_screen.dart';
import 'data/models/task_model.dart';

void main() {
  runApp(const FocusFlowApp());
}

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Focus Flow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _tasks.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return _buildTaskCard(task, index);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (result != null && result is TaskModel) {
            _addTask(result);
          }
        },
        label: const Text("Fokus Baru"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.nights_stay_outlined,
            size: 80,
            color: Colors.deepPurple.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            "Belum ada target fokus hari ini.",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, int index) {
    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteTask(index),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
            child: Text(
              "${task.duration}s", // Menampilkan durasi dalam detik
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // Jika done, kasih efek coret (strikethrough)
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: task.isDone ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(
            task.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Ganti trailing agar lebih dinamis
          trailing: Wrap(
            // Gunakan Wrap agar bisa menampung dua tombol jika perlu
            spacing: 12,
            children: [
              if (task.isDone)
                // Tombol untuk membatalkan status Selesai
                IconButton(
                  icon: const Icon(Icons.undo, color: Colors.orange),
                  onPressed: () {
                    // Tampilkan dialog konfirmasi sebelum reset status
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Reset Tugas?"),
                        content: const Text(
                          "Apakah kamu ingin mengembalikan tugas ini ke daftar fokus?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context), // Tutup tanpa aksi
                            child: const Text("BATAL"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final unDoneTask = TaskModel(
                                id: task.id,
                                title: task.title,
                                description: task.description,
                                duration: task.duration,
                                isDone: false, // Set jadi belum selesai
                              );
                              _editTask(index, unDoneTask); // Update ke memory
                              Navigator.pop(context); // Tutup dialog
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("YA, RESET"),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              // Tombol edit tetap ada jika belum selesai
              if (!task.isDone)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskScreen(task: task),
                      ),
                    );
                    if (result != null && result is TaskModel) {
                      _editTask(index, result);
                    }
                  },
                ),
            ],
          ),
          onTap: task.isDone
              ? null // Matikan navigasi ke Timer jika sudah selesai
              : () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimerScreen(task: task),
                    ),
                  );
                  if (result != null && result is TaskModel) {
                    _editTask(index, result);
                  }
                },
        ),
      ),
    );
  }
}
