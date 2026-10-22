import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository? repository;

  const TaskListScreen({super.key, this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late TaskRepository _repository;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? TaskRepository();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_inputController.text.trim().isNotEmpty) {
      setState(() {
        _repository.addTask(
          Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _inputController.text.trim(),
          ),
        );
        _inputController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'), // Thêm key định danh cho integration test
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task title...',
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: _addTask,
                  mini: true,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: _repository.tasks.isEmpty
                ? const Center(child: Text('No tasks yet. Add one!'))
                : ListView.builder(
              itemCount: _repository.tasks.length,
              itemBuilder: (context, index) {
                final task = _repository.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(
                          task: task,
                          onSave: (newTitle) {
                            setState(() {
                              _repository.updateTask(
                                Task(
                                  id: task.id,
                                  title: newTitle,
                                  isCompleted: task.isCompleted,
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}