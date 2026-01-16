import 'package:hive/hive.dart';
import '../model/task_model.dart';

class HiveService {
  final Box<TaskModel> _box = Hive.box<TaskModel>('tasksBox');

  List<TaskModel> getTasks() {
    return _box.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    await task.save();
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
