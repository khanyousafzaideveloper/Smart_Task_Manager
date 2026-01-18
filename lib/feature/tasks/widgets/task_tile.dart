import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../data/model/task_model.dart';
import '../controller/task_controller.dart';
import '../view/home_screen.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final ok = await showConfirmDialog(
                context,
                "Delete this task?",
              );

              if (ok) {
                context.read<TaskController>().deleteTask(task.id);
              }
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 2,
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) =>
                context.read<TaskController>().toggleTask(task),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "${task.priority}${task.dueDate != null ? " • ${task.dueDate!.toLocal().toString().split(" ")[0]}" : ""}",
          ),
          trailing: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/add", arguments: task);
            },
            child: const Icon(
              Icons.edit,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
