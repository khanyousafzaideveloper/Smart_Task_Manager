import 'package:hive/hive.dart';

part 'task_model.g.dart';


@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  String priority;

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.priority = "Low",
  });
}
