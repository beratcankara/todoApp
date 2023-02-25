import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
part 'taskModel.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.isCompleted,
  });

  factory Task.create(name, createdAt) {
    return Task(
        id: const Uuid().v1(),
        name: name,
        createdAt: createdAt,
        isCompleted: false);
  }

  @override
  String toString() {
    return 'Task(id: $id, name: $name, createdAt: $createdAt, isCompleted: $isCompleted)';
  }
}
