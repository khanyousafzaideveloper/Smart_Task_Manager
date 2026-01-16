import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/task_controller.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskController>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Task Manager"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<TaskController>(
        builder: (context, controller, _) {
          if (controller.tasks.isEmpty) {
            return const Center(
              child: Text("No tasks yet. Add one!"),
            );
          }

          return ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return TaskTile(task: task);
            },
          );
        },
      ),
    );
  }
}
