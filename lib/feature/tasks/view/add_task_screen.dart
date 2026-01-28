import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../data/model/task_model.dart';
import '../widgets/app_appBar.dart';
import '../widgets/app_textFiled.dart';
import '../controller/task_controller.dart';
import '../widgets/primary_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _controller = TextEditingController();
  DateTime? _dueDate;
  String _priority = "Low";
  final _descController = TextEditingController();


  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  void _saveTask() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Task title cannot be empty")));
      return;
    }

    if (editingTask != null) {
      editingTask!.title = _controller.text.trim();
      editingTask!.description = _descController.text.trim();
      editingTask!.priority = _priority;
      editingTask!.dueDate = _dueDate;

      context.read<TaskController>().updateTask(editingTask!);
    } else {
      final task = TaskModel(
        id: const Uuid().v4(),
        title: _controller.text.trim(),
        description: _descController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
      );

      context.read<TaskController>().addTask(task);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: editingTask == null ? "Add Task" : "Edit Task"),

      // appBar: AppBar(title: Text(editingTask == null ? "Add Task" : "Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(controller: _controller, label: "Task Title"),

            const SizedBox(height: 16),

            AppTextField(controller: _descController, label: "Task Detail", maxLines: 4),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _priority,
              items: ["Low", "Medium", "High"]
                  .map(
                    (e) => DropdownMenuItem(value: e, child: Text(e)),
              )
                  .toList(),
              onChanged: (v) => setState(() => _priority = v!),
              decoration: const InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? "No date selected"
                        : "Due: ${_dueDate!.toLocal().toString().split(" ")[0]}",
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const Spacer(),

            PrimaryButton(title: "Save Task", onPressed: _saveTask),

          ],
        ),
      ),
    );
  }

  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;
    _loaded = true;

    final task = ModalRoute.of(context)?.settings.arguments as TaskModel?;

    if (task != null) {
      _controller.text = task.title;
      _descController.text = task.description;
      _priority = task.priority;
      _dueDate = task.dueDate;
      editingTask = task;
    }
  }

  TaskModel? editingTask;
}
