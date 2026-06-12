import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.title,
    this.completed = false,
    this.dueDate,
    this.priority = 0,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  final int id;
  final String title;
  final bool completed;
  final DateTime? dueDate;
  final int priority;

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
    DateTime? dueDate,
    int? priority,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [id, title, completed, dueDate, priority];
}
