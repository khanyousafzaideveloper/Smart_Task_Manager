
import '../../feature/tasks/view/add_task_screen.dart';
import '../../feature/tasks/view/home_screen.dart';
import '../../feature/tasks/view/task_detail_screen.dart';

class AppRoutes {
  static const home = "/";
  static const add = "/add";
  static const detail = "/detail";

  static final routes = {
    home: (context) => const HomeScreen(),
    add: (context) => const AddTaskScreen(),
    detail: (context) => const TaskDetailScreen()
  };
}
