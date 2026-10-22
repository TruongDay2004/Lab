import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('Empty State displays correct message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TaskListScreen()));
    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
  });

  testWidgets('Add Task updates UI correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TaskListScreen()));

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'Buy groceries');

    final addButtonFinder = find.byType(FloatingActionButton);
    await tester.tap(addButtonFinder);
    await tester.pump();

    expect(find.text('Buy groceries'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsNothing);
  });

  testWidgets('Multiple tasks display both visible', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TaskListScreen()));

    final textFieldFinder = find.byType(TextField);
    final addButtonFinder = find.byType(FloatingActionButton);

    await tester.enterText(textFieldFinder, 'Task 1');
    await tester.tap(addButtonFinder);
    await tester.pump();

    await tester.enterText(textFieldFinder, 'Task 2');
    await tester.tap(addButtonFinder);
    await tester.pump();

    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });
}