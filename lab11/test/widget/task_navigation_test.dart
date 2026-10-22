import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('Navigation from TaskListScreen to TaskDetailScreen works', (WidgetTester tester) async {
    final repository = TaskRepository();
    repository.addTask(Task(id: '1', title: 'Seeded Task For Navigation'));

    await tester.pumpWidget(
      MaterialApp(
        home: TaskListScreen(repository: repository),
      ),
    );

    expect(find.text('Seeded Task For Navigation'), findsOneWidget);
    await tester.tap(find.text('Seeded Task For Navigation'));
    await tester.pumpAndSettle();

    expect(find.text('Task Detail'), findsOneWidget);
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}