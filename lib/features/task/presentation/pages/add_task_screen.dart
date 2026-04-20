import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/task_model.dart';
import 'package:focus_flow/core/ui_kit/app_input.dart';
import 'package:focus_flow/core/ui_kit/app_button.dart';
import 'package:focus_flow/core/utils/time_converter.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _durationError;

  late TextEditingController _titleController;
  late TextEditingController _descController;
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
    // 1. Reset pesan error manual setiap kali tombol ditekan
    setState(() => _durationError = null);

    // 2. Jalankan validasi standar Form (Judul, Deskripsi, dan batas angka 59)
    final isFormValid = _formKey.currentState!.validate();

    // 3. Hitung total durasi untuk pengecekan "Minimal 1 Detik"
    final totalDuration = TimeConverter.toTotalSeconds(
      _hoursController.text,
      _minutesController.text,
      _secondsController.text,
    );

    // 4. Validasi Durasi Minimal (Logika Manual)
    if (totalDuration <= 0) {
      setState(() => _durationError = "Durasi fokus minimal 1 detik");
      // Kita tidak return dulu di sini agar pesan error
      // di field lain (seperti Judul) juga muncul barengan.
    }

    // 5. Final Check: Form harus valid DAN durasi harus > 0
    if (isFormValid && totalDuration > 0) {
      final task =
          widget.task?.copyWith(
            title: _titleController.text,
            description: _descController.text,
            duration: totalDuration,
          ) ??
          TaskModel(
            id: DateTime.now().millisecondsSinceEpoch,
            title: _titleController.text,
            description: _descController.text,
            duration: totalDuration,
            isDone: false,
          );

      Navigator.pop(context, task);
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
            crossAxisAlignment: CrossAxisAlignment.start,
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

              // BAGIAN INPUT DURASI
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimeField(
                        _hoursController,
                        'Jam',
                        colorScheme,
                        icon: Icons.access_time_outlined,
                        hasError:
                            _durationError != null, // Kirim status error ke UI
                      ),
                      const SizedBox(width: 8),
                      _buildTimeField(
                        _minutesController,
                        'Menit',
                        colorScheme,
                        icon: Icons.access_time_outlined,
                        maxVal: 59,
                        hasError:
                            _durationError != null, // Kirim status error ke UI
                      ),
                      const SizedBox(width: 8),
                      _buildTimeField(
                        _secondsController,
                        'Detik',
                        colorScheme,
                        icon: Icons.access_time_outlined,
                        maxVal: 59,
                        hasError:
                            _durationError != null, // Kirim status error ke UI
                      ),
                    ],
                  ),
                  if (_durationError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        _durationError!,
                        style: TextStyle(
                          color: colorScheme.error,
                          fontSize: 12,
                        ),
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

  // Di dalam class _AddTaskScreenState di AddTaskScreen

  // 1. Update parameter fungsi helper
  Widget _buildTimeField(
    TextEditingController controller,
    String label,
    ColorScheme colorScheme, {
    IconData? icon,
    int? maxVal,
    required bool hasError, // TAMBAHKAN PARAMETER INI
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        decoration: AppInput.decoration(
          label: label,
          icon: icon,
          colorScheme: colorScheme,
          // KIRIM STATUS ERROR KE UI KIT
          isError: hasError,
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final numValue = int.tryParse(value);
            if (numValue != null && maxVal != null && numValue > maxVal) {
              return "Maks $maxVal";
            }
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }
}
