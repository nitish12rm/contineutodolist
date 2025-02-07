import 'package:hive/hive.dart';
part 'task_model.g.dart'; // Required for Hive adapter generation

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime createdAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  // Convert to JSON (for Firebase)
  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "title": title,
    "isCompleted": isCompleted,
    "createdAt": createdAt.toIso8601String(),
  };
  Task copyWith({
    String? id,
    String? userId,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  // Convert from JSON (for Firebase)
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    userId: json['userId'],
    title: json['title'],
    isCompleted: json['isCompleted'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
