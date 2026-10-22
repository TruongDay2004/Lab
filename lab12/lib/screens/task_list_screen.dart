import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly - Optimized List'),
      ),
      body: Selector<TaskProvider, List<String>>(
        selector: (context, provider) =>
            provider.tasks.map((task) => task.id).toList(),
        builder: (context, taskIds, child) {
          if (taskIds.isEmpty) {
            return const Center(
              child: Text('Chưa có công việc nào!'),
            );
          }

          return ListView.builder(
            itemCount: taskIds.length,
            itemBuilder: (context, index) {
              final id = taskIds[index];
              return TaskTile(
                key: ValueKey(id),
                taskId: id,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TaskProvider>().addTask('Task mới ${DateTime.now().second}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}