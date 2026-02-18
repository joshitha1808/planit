// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  final String id;
  final String title;
  final String? description;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
    this.isCompleted = false,
  });

  /// ✅ Convert Task → Map (for Supabase insert/update)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'due_at': dueAt.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  /// ✅ Convert Map → Task (from Supabase)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      dueAt: DateTime.parse(map['due_at']),
      isCompleted: map['is_completed'] as bool? ?? false,
    );
  }

  /// JSON conversion
  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  /// CopyWith for updating task
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueAt,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
