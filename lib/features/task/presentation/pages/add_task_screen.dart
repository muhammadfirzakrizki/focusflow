import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../../../providers/task/task_provider.dart';
import 'package:focus_flow/core/ui_kit/app_input.dart';
import 'package:focus_flow/core/ui_kit/app_button.dart';
import 'package:focus_flow/core/utils/time_converter.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;
  const AddTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
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
    setState(() => _durationError = null);

    final isFormValid = _formKey.currentState!.validate();

    final totalDuration = TimeConverter.toTotalSeconds(
      _hoursController.text,
      _minutesController.text,
      _secondsController.text,
    );

    if (totalDuration <= 0) {
      setState(() => _durationError = "Durasi fokus minimal 1 detik");
    }

    if (isFormValid && totalDuration > 0) {
      final task =
          widget.task?.copyWith(
            title: _titleController.text,
            description: _descController.text,
            duration: totalDuration,
          ) ??
          TaskModel(
            // Perbaikan: Konversi int ke String agar tidak error 'int cant be assigned to String'
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text,
            description: _descController.text,
            duration: totalDuration,
            isDone: false,
            // Perbaikan: Tambahkan parameter createdAt yang diwajibkan oleh model
            createdAt: DateTime.now(),
          );

      // Simpan langsung ke database lewat provider
      ref.read(taskControllerProvider.notifier).addTask(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Fokus' : 'Tambah Fokus Baru'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Judul kosong" : null,
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
                    ? "Deskripsi kosong"
                    : null,
              ),
              const SizedBox(height: 24),

              const Text(
                "Durasi Fokus",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeField(
                    _hoursController,
                    'Jam',
                    colorScheme,
                    hasError: _durationError != null,
                  ),
                  const SizedBox(width: 10),
                  _buildTimeField(
                    _minutesController,
                    'Menit',
                    colorScheme,
                    maxVal: 59,
                    hasError: _durationError != null,
                  ),
                  const SizedBox(width: 10),
                  _buildTimeField(
                    _secondsController,
                    'Detik',
                    colorScheme,
                    maxVal: 59,
                    hasError: _durationError != null,
                  ),
                ],
              ),
              if (_durationError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    _durationError!,
                    style: TextStyle(color: colorScheme.error, fontSize: 12),
                  ),
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

  Widget _buildTimeField(
    TextEditingController controller,
    String label,
    ColorScheme colorScheme, {
    int? maxVal,
    required bool hasError,
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        decoration: AppInput.decoration(
          label: label,
          colorScheme: colorScheme,
          isError: hasError,
        ).copyWith(floatingLabelAlignment: FloatingLabelAlignment.center),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final numValue = int.tryParse(value);
            if (numValue != null && maxVal != null && numValue > maxVal) {
              return "<=$maxVal";
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
