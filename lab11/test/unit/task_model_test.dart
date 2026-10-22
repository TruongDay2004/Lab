import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Default completed value should be false', () {
      final task = Task(id: '1', title: 'Test Task');
      expect(task.isCompleted, false);
    });

    test('toggle() should switch isCompleted true <-> false', () {
      final task = Task(id: '1', title: 'Test Task', isCompleted: false);

      task.toggle();
      expect(task.isCompleted, true);

      task.toggle();
      expect(task.isCompleted, false);
    });
  });
}