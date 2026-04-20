import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/task_model.dart';
import 'package:focus_flow/core/ui_kit/app_input.dart';
import 'package:focus_flow/core/ui_kit/app_button.dart';
import 'package:focus_flow/core/utils/time_converter.dart'; // Import helper baru

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  // Pisahkan controller untuk Jam, Menit dan Detik
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descController = TextEditingController(
      text: widget.task?.description ?? "",
    );

    // Gunakan TimeConverter untuk mengisi nilai awal (jika mode edit)
    final initialDuration = widget.task?.duration ?? 0;
    _hoursController = TextEditingController(
      text: initialDuration > 0
          ? TimeConverter.getHours(initialDuration).toString()
          : "",
    );
    _minutesController = TextEditingController(
      text: initialDuration > 0
          ? TimeConverter.getMinutes(initialDuration).toString()
          : "",
    );
    _secondsController = TextEditingController(
      text: initialDuration > 0
          ? TimeConverter.getSeconds(initialDuration).toString()
          : "",
    );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // Gabungkan menit & detik kembali menjadi total detik sebelum simpan
      final totalDuration = TimeConverter.toTotalSeconds(
        _hoursController.text,
        _minutesController.text,
        _secondsController.text,
      );

      // Validasi tambahan jika total durasi adalah 0
      if (totalDuration <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Durasi fokus tidak boleh kosong!")),
        );
        return;
      }

      final updatedTask = TaskModel(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        description: _descController.text,
        duration: totalDuration,
        isDone: widget.task?.isDone ?? false,
      );

      Navigator.pop(context, updatedTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Fokus' : 'Tambah Fokus Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: AppInput.decoration(
                  label: 'Apa fokus utamamu?',
                  icon: Icons.assignment_outlined,
                  colorScheme: colorScheme,
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Judul tidak boleh kosong"
                    : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: AppInput.decoration(
                  label: 'Detail singkat',
                  icon: Icons.notes_outlined,
                  colorScheme: colorScheme,
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Deskripsi harus diisi"
                    : null,
              ),
              const SizedBox(height: 20),

              // INPUT DURASI (JAM : MENIT : DETIK)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JAM
                  Expanded(
                    child: TextFormField(
                      controller:
                          _hoursController, // Jangan lupa deklarasi di atas
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: AppInput.decoration(
                        label: 'Jam',
                        icon: Icons.hourglass_top_rounded,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // MENIT
                  Expanded(
                    child: TextFormField(
                      controller: _minutesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: AppInput.decoration(
                        label: 'Menit',
                        icon: Icons.hourglass_bottom_rounded,
                        colorScheme: colorScheme,
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (int.parse(value) >= 60) return "Maks 59";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // DETIK
                  Expanded(
                    child: TextFormField(
                      controller: _secondsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: AppInput.decoration(
                        label: 'Detik',
                        icon: Icons.hourglass_bottom_rounded,
                        colorScheme: colorScheme,
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (int.parse(value) >= 60) return "Maks 59";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              AppButton(
                label: isEdit ? 'PERBARUI TUGAS' : 'SIMPAN KE DAFTAR',
                icon: isEdit ? Icons.check_circle_outline : Icons.save_rounded,
                backgroundColor: isEdit
                    ? colorScheme.secondary
                    : colorScheme.primary,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }
}
