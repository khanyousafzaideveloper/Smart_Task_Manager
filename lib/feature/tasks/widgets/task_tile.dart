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
        elevation: 3,
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Checkbox(
              key: ValueKey(task.isCompleted),
              value: task.isCompleted,
              onChanged: (_) =>
                  context.read<TaskController>().toggleTask(task),
            ),
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
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getPriorityColor(task.priority, context).withOpacity(.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.priority,
                  style: TextStyle(
                    color: getPriorityColor(task.priority, context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (task.dueDate != null)
                Text(
                  task.dueDate!.toLocal().toString().split(" ")[0],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
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


Color getPriorityColor(String p, BuildContext context) {
  switch (p) {
    case "High":
      return Colors.redAccent;
    case "Medium":
      return Colors.orangeAccent;
    default:
      return Colors.green;
  }
}
