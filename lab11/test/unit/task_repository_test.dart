import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  late TaskRepository repository;

  setUp(() {
    repository = TaskRepository();
  });

  group('Task Repository Unit Tests', () {
    test('addTask() should add a new task to the repository', () {
      final task = Task(id: '1', title: 'New Task');
      repository.addTask(task);

      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'New Task');
    });

    test('deleteTask() should remove a task by id', () {
      final task = Task(id: '1', title: 'Task to Delete');
      repository.addTask(task);
      expect(repository.tasks.length, 1);

      repository.deleteTask('1');
      expect(repository.tasks.isEmpty, true);
    });

    test('updateTask() should update existing task details', () {
      final task = Task(id: '1', title: 'Old Title');
      repository.addTask(task);

      final updatedTask = Task(id: '1', title: 'Updated Title');
      repository.updateTask(updatedTask);

      expect(repository.tasks.first.title, 'Updated Title');
    });
  });
}