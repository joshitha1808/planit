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
  bool isCompleted;

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'due_at': dueAt.millisecondsSinceEpoch,
      'is_completed': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      category: map['category'] as String,
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
      dueAt: _parseDateTime(map['due_at']),
      isCompleted: map['is_completed'] as bool? ?? false,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

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
