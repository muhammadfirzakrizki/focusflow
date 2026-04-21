import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final int duration; // Dalam detik
  final bool isDone;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    this.isDone = false,
    required this.createdAt,
  });

  // Method copyWith sangat penting untuk Use Case (Immutability)
  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    int? duration,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    duration,
    isDone,
    createdAt,
  ];
}
