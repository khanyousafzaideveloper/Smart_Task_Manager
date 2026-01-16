import '../model/task_model.dart';
import '../services/local_storage_service.dart';

class TaskRepository {
  final HiveService _service = HiveService();

  List<TaskModel> fetchTasks() => _service.getTasks();

  Future<void> add(TaskModel task) => _service.addTask(task);

  Future<void> update(TaskModel task) => _service.updateTask(task);

  Future<void> delete(String id) => _service.deleteTask(id);
}
