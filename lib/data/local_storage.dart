import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/models/taskModel.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<List<Task>> getAllTask();
  Future<void> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box("tasks");
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask({required Task task}) async {
    await _taskBox.delete(task.id);
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();

    if (_allTask.length > 0) {
      _allTask.sort((Task a, Task b) => b.createdAt.compareTo(a.createdAt));
    }
    return _allTask;
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
