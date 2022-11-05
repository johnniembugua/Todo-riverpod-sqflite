import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/db/db_helper.dart';

import '../models/task.dart';

final taskController = Provider((ref) => TaskController());
final getTasksController = FutureProvider<List<Task>?>((ref) {
  final tasks = ref.read(taskController).getTasks();
  return tasks;
});

class TaskController {
  var taskList = <Task>[];
  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  Future<List<Task>?> getTasks() async {
    try {
      List<Map<String, dynamic>> result = await DBHelper.query();
      final tasks = result.map((data) => Task.fromMap(data)).toList();
      return tasks;
    } catch (e) {
      print(e);
    }
  }

  void delete(Task task) async {
    await DBHelper.delete(task);
  }

  void update(Task task) async {
    await DBHelper.update(task.id!);
  }
}
