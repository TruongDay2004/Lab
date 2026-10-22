import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final String taskId;

  const TaskTile({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<TaskProvider, Task?>(
      selector: (context, provider) => provider.getTaskById(taskId),
      builder: (context, task, child) {
        if (task == null) {
          return const SizedBox.shrink();
        }

        final currentTask = task;

        return ListTile(
          leading: Checkbox(
            value: currentTask.isCompleted,
            onChanged: (_) {
              context.read<TaskProvider>().toggleTaskStatus(currentTask.id);
            },
          ),
          title: Text(
            currentTask.title,
            style: TextStyle(
              decoration: currentTask.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<TaskProvider>().deleteTask(currentTask.id);
            },
          ),
        );
      },
    );
  }
}