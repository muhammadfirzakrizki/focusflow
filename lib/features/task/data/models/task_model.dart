import 'dart:convert';

class TaskModel {
  final int id; // Kita buat non-nullable agar key Dismissible aman
  final String title;
  final String description;
  final bool isDone;
  final int duration;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.duration = 30,
  });

  // Fungsi CopyWith: Sangat berguna untuk update status isDone di UI Kit
  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
    int? duration,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      duration: duration ?? this.duration,
    );
  }

  // To Map: Langsung pakai bool untuk JSON SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone, // Simpan sebagai boolean langsung
      'duration': duration,
    };
  }

  // From Map: Ambil data dengan proteksi default value
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
      duration: map['duration'] ?? 30,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));
}
