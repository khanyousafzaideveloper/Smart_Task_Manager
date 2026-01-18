import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../controller/task_controller.dart';
import '../controller/theme_controller.dart';
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
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeController>().isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeController>().toggleTheme();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),

              onChanged: (value) {
                context.read<TaskController>().setSearch(value);
              },
            ),
          ),

          Expanded(
            child: Consumer<TaskController>(
              builder: (context, controller, _) {
                final list = controller.filteredTasks;

                if (list.isEmpty) {
                  return const Center(
                    child: Text("No tasks found"),
                  );
                }

                return AnimationLimiter(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final task = list[index];

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: TaskTile(task: task),
                          ),
                        ),
                      );
                    },
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}


Future<bool> showConfirmDialog(BuildContext context, String title) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Confirm"),
      content: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Delete "),
        ),
      ],
    ),
  );

  return result ?? false;
}
