import 'package:flutter/cupertino.dart';

import '../../../data/model/task_model.dart';
import '../../../data/repositories/task_repository.dart';

import 'package:flutter/material.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository _repo = TaskRepository();

  List<TaskModel> tasks = [];
  String _search = "";
  String _filter = "All";

  void loadTasks() {
    tasks = _repo.fetchTasks();
    notifyListeners();
  }

  List<TaskModel> get filteredTasks {
    var list = tasks;

    if (_filter == "Pending") {
      list = list.where((e) => !e.isCompleted).toList();
    } else if (_filter == "Completed") {
      list = list.where((e) => e.isCompleted).toList();
    }

    if (_search.isNotEmpty) {
      list = list
          .where((e) =>
          e.title.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    }

    return list;
  }

  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  Future addTask(TaskModel task) async {
    await _repo.add(task);
    loadTasks();
  }

  Future updateTask(TaskModel task) async {
    await _repo.update(task);
    loadTasks();
  }

  Future toggleTask(TaskModel task) async {
    task.isCompleted = !task.isCompleted;
    await _repo.update(task);
    loadTasks();
  }

  Future deleteTask(String id) async {
    await _repo.delete(id);
    loadTasks();
  }
}
