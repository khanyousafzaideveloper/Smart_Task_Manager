import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/task_model.dart';
import '../controller/task_controller.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, "/add", arguments: task);
        },
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) =>
              context.read<TaskController>().toggleTask(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
            task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          "${task.priority}${task.dueDate != null ? " • ${task.dueDate!.toLocal().toString().split(" ")[0]}" : ""}",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () =>
              context.read<TaskController>().deleteTask(task.id),
        ),
      ),
    );
  }
}
