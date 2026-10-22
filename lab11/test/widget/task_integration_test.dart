import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('Full flow integration test: Add, View Detail, Edit, Save, Verify', (WidgetTester tester) async {
    // Arrange: Khởi động trực tiếp TaskListScreen trong MaterialApp thay vì app.main()
    await tester.pumpWidget(const MaterialApp(home: TaskListScreen()));
    await tester.pumpAndSettle();

    // 1. Tìm TextField và FloatingActionButton trên màn hình
    final textField = find.byType(TextField);
    final addButton = find.byType(FloatingActionButton);

    // Nhập "Original title" và bấm nút Add
    await tester.enterText(textField, 'Original title');
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Xác thực task đã xuất hiện
    expect(find.text('Original title'), findsOneWidget);

    // 2. Chạm vào task để mở màn hình chi tiết
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    // 3. Sửa tiêu đề thành "Updated title" tại màn hình chi tiết
    final detailField = find.byKey(const Key('detailTitleField'));
    await tester.enterText(detailField, 'Updated title');

    // 4. Bấm nút Save
    final saveButton = find.text('Save');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // 5. Xác thực tiêu đề mới đã được cập nhật và tiêu đề cũ không còn
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}