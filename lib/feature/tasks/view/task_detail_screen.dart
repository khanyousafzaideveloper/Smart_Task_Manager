import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/task_model.dart';
import '../controller/task_controller.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as TaskModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, "/add", arguments: task);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete Task"),
                  content: const Text("Are you sure?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );

              if (ok == true) {
                context.read<TaskController>().deleteTask(task.id);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(task.description),
            const SizedBox(height: 20),
            Row(
              children: [
                Chip(label: Text(task.priority)),
                const SizedBox(width: 10),
                Text(task.isCompleted ? "Completed" : "Pending"),
              ],
            ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 12),
              Text("Due: ${task.dueDate!.toLocal().toString().split(" ")[0]}"),
            ],
          ],
        ),
      ),
    );
  }
}
